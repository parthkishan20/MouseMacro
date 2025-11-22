import Cocoa
import SwiftUI
import ApplicationServices
import os.log

/// Main application delegate managing menu bar presence and event tap
final class AppDelegate: NSObject, NSApplicationDelegate {
    
    // MARK: - Properties
    
    private var statusItem: NSStatusItem?
    private var preferencesWindow: NSWindow?
    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    private let logger = Logger(subsystem: "com.skybolt.MouseMacro", category: "AppDelegate")
    
    // MARK: - Lifecycle
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        logger.info("Application launching...")
        
        // Hide from Dock and prevent app from appearing in Command+Tab
        NSApplication.shared.setActivationPolicy(.prohibited)
        
        // Setup components in order
        setupStatusBar()
        checkAccessibilityPermissions()
        setupEventTap()
        
        logger.info("Application launched successfully")
    }

    func applicationWillTerminate(_ notification: Notification) {
        logger.info("Application terminating - cleaning up resources")
        cleanupEventTap()
    }
    
    // MARK: - Cleanup
    
    /// Safely cleanup event tap and run loop source
    private func cleanupEventTap() {
        if let eventTap = eventTap {
            CGEvent.tapEnable(tap: eventTap, enable: false)
            CFMachPortInvalidate(eventTap)
            self.eventTap = nil
            logger.debug("Event tap invalidated")
        }
        
        if let runLoopSource = runLoopSource {
            CFRunLoopRemoveSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
            self.runLoopSource = nil
            logger.debug("Run loop source removed")
        }
    }

    // MARK: - Status Bar
    
    private func setupStatusBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        guard let button = statusItem?.button else {
            logger.error("Failed to create status bar button")
            return
        }
        
        // Configure button appearance
        button.image = NSImage(systemSymbolName: "bolt.circle", accessibilityDescription: "MouseMacro")
        button.toolTip = "MouseMacro - Button 4: ⌘+C, Button 5: ⌘+V"
        
        // Create menu
        let menu = NSMenu()
        menu.autoenablesItems = false
        
        let prefsItem = NSMenuItem(title: "Preferences...", action: #selector(showPreferences), keyEquivalent: ",")
        prefsItem.isEnabled = true
        menu.addItem(prefsItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let quitItem = NSMenuItem(title: "Quit MouseMacro", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.isEnabled = true
        menu.addItem(quitItem)
        
        statusItem?.menu = menu
        logger.debug("Status bar configured successfully")
    }

    // MARK: - Actions
    
    @objc private func quitApp() {
        logger.info("User initiated quit")
        NSApplication.shared.terminate(nil)
    }

    @objc private func showPreferences() {
        logger.debug("Opening preferences window")
        
        if preferencesWindow == nil {
            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 400, height: 240),
                styleMask: [.titled, .closable, .miniaturizable],
                backing: .buffered,
                defer: false
            )
            window.center()
            window.title = "MouseMacro Preferences"
            window.isReleasedWhenClosed = false
            window.level = .floating
            window.contentView = NSHostingView(rootView: PreferencesView())
            
            preferencesWindow = window
        }
        
        preferencesWindow?.makeKeyAndOrderFront(nil)
        NSApplication.shared.activate(ignoringOtherApps: true)
    }

    // MARK: - Event Tap
    
    private func setupEventTap() {
        logger.info("Setting up event tap...")
        
        // Only listen for otherMouseDown events (buttons beyond left/right click)
        let eventMask: CGEventMask = (1 << CGEventType.otherMouseDown.rawValue)
        
        guard let eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,  // Default tap can suppress events by returning nil
            eventsOfInterest: eventMask,
            callback: { _, type, event, _ in
                return handleMouseEvent(type: type, event: event)
            },
            userInfo: nil
        ) else {
            logger.error("Failed to create event tap - check accessibility permissions")
            showEventTapFailureAlert()
            return
        }
        
        // Create and add run loop source
        guard let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0) else {
            logger.error("Failed to create run loop source")
            CFMachPortInvalidate(eventTap)
            return
        }
        
        self.eventTap = eventTap
        self.runLoopSource = runLoopSource
        
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
        
        logger.info("Event tap created and enabled successfully")
    }
    
    private func showEventTapFailureAlert() {
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = "Event Tap Failed"
            alert.informativeText = "MouseMacro couldn't set up event monitoring. Please ensure you've granted Accessibility permissions and restart the app."
            alert.alertStyle = .critical
            alert.addButton(withTitle: "Open Settings")
            alert.addButton(withTitle: "Quit")
            
            let response = alert.runModal()
            if response == .alertFirstButtonReturn {
                self.openAccessibilitySettings()
            } else {
                NSApplication.shared.terminate(nil)
            }
        }
    }

    // MARK: - Accessibility Permissions
    
    private func checkAccessibilityPermissions() {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options)
        
        if accessEnabled {
            logger.info("Accessibility permissions granted")
        } else {
            logger.warning("Accessibility permissions not granted")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.showPermissionsAlert()
            }
        }
    }
    
    private func showPermissionsAlert() {
        let alert = NSAlert()
        alert.messageText = "Accessibility Access Required"
        alert.informativeText = "MouseMacro needs Accessibility permissions to detect mouse button clicks and send keyboard shortcuts.\n\nPlease enable this app in:\nSystem Settings → Privacy & Security → Accessibility"
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Open Settings")
        alert.addButton(withTitle: "Quit")
        
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            openAccessibilitySettings()
        } else {
            NSApplication.shared.terminate(nil)
        }
    }
    
    private func openAccessibilitySettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") {
            NSWorkspace.shared.open(url)
        }
    }
}
