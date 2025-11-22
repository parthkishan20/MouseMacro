import Cocoa
import os.log

/// Logger for debugging and error tracking
private let logger = Logger(subsystem: "com.skybolt.MouseMacro", category: "MouseHandler")

/// Handles mouse events and converts them to keyboard shortcuts
/// - Parameters:
///   - type: The type of mouse event
///   - event: The CGEvent to process
/// - Returns: nil to suppress the original event, or the event to pass it through
func handleMouseEvent(type: CGEventType, event: CGEvent) -> Unmanaged<CGEvent>? {
    let buttonNumber = event.getIntegerValueField(.mouseEventButtonNumber)
    
    // Only process otherMouseDown events (buttons 3+)
    guard type == .otherMouseDown else {
        return Unmanaged.passUnretained(event)
    }
    
    // Handle Button 4 (buttonNumber 3) and Button 5 (buttonNumber 4)
    switch buttonNumber {
    case 3: // Button 4 on the mouse
        logger.info("Button 4 pressed - triggering ⌘+C")
        sendShortcut(key: .c, modifier: .maskCommand)
        Task { @MainActor in
            PreferencesState.shared.recordCopy()
        }
        return nil // Suppress the original event to prevent forward navigation
        
    case 4: // Button 5 on the mouse
        logger.info("Button 5 pressed - triggering ⌘+V")
        sendShortcut(key: .v, modifier: .maskCommand)
        Task { @MainActor in
            PreferencesState.shared.recordPaste()
        }
        return nil // Suppress the original event to prevent backward navigation
        
    default:
        // Pass through any other button events unchanged
        return Unmanaged.passUnretained(event)
    }
}

/// Sends a keyboard shortcut by simulating key press and release
/// - Parameters:
///   - key: The key to press
///   - modifier: The modifier flags (Command, Option, Control, Shift)
private func sendShortcut(key: VirtualKey, modifier: CGEventFlags) {
    // Create event source with proper state
    guard let source = CGEventSource(stateID: .combinedSessionState) else {
        logger.error("Failed to create CGEventSource")
        return
    }
    
    // Suppress event source seconds to prevent feedback loops
    source.setLocalEventsSuppressionInterval(0.25)
    
    // Create key down event
    guard let keyDown = CGEvent(keyboardEventSource: source, virtualKey: key.rawValue, keyDown: true) else {
        logger.error("Failed to create key down event for \(key.description)")
        return
    }
    keyDown.flags = modifier
    
    // Create key up event
    guard let keyUp = CGEvent(keyboardEventSource: source, virtualKey: key.rawValue, keyDown: false) else {
        logger.error("Failed to create key up event for \(key.description)")
        return
    }
    keyUp.flags = modifier
    
    // Post events to the system
    keyDown.post(tap: .cghidEventTap)
    
    // Small delay between key down and up for better compatibility
    usleep(1000) // 1ms delay
    
    keyUp.post(tap: .cghidEventTap)
    
    logger.debug("Successfully sent \(key.description) with modifiers")
}

// MARK: - Virtual Key Enumeration

/// Virtual key codes for macOS keyboard events
enum VirtualKey: CGKeyCode, CustomStringConvertible {
    case a = 0
    case s = 1
    case d = 2
    case f = 3
    case h = 4
    case g = 5
    case z = 6
    case x = 7
    case c = 8
    case v = 9
    case b = 11
    case q = 12
    case w = 13
    case e = 14
    case r = 15
    case y = 16
    case t = 17
    case one = 18
    case two = 19
    case three = 20
    case four = 21
    case five = 23
    case six = 22
    case equal = 24
    case nine = 25
    case seven = 26
    case minus = 27
    case eight = 28
    case zero = 29
    case rightBracket = 30
    case o = 31
    case u = 32
    case leftBracket = 33
    case i = 34
    case p = 35
    case l = 37
    case j = 38
    case quote = 39
    case k = 40
    case semicolon = 41
    case backslash = 42
    case comma = 43
    case slash = 44
    case n = 45
    case m = 46
    case period = 47
    case grave = 50
    case keypaddecimal = 65
    case keypadMultiply = 67
    case keypadPlus = 69
    case keypadClear = 71
    case keypadDivide = 75
    case keypadEnter = 76
    case keypadMinus = 78
    case keypadEquals = 81
    case keypad0 = 82
    case keypad1 = 83
    case keypad2 = 84
    case keypad3 = 85
    case keypad4 = 86
    case keypad5 = 87
    case keypad6 = 88
    case keypad7 = 89
    case keypad8 = 91
    case keypad9 = 92
    case `return` = 36
    case tab = 48
    case space = 49
    case delete = 51
    case escape = 53
    case command = 55
    case shift = 56
    case capsLock = 57
    case option = 58
    case control = 59
    case rightCommand = 54
    case rightShift = 60
    case rightOption = 61
    case rightControl = 62
    case function = 63
    
    var description: String {
        switch self {
        case .c: return "C"
        case .v: return "V"
        case .a: return "A"
        case .x: return "X"
        case .z: return "Z"
        default: return "Key(\(self.rawValue))"
        }
    }
}
