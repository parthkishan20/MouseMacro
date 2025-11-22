# MouseMacro

A lightweight macOS menu bar application that remaps mouse buttons 4 and 5 to keyboard shortcuts (⌘+C and ⌘+V), making copy and paste operations faster and more convenient.

## Overview

MouseMacro runs silently in your menu bar and intercepts clicks from your extra mouse buttons, converting them into keyboard shortcuts:

- **Button 4** → **⌘ + C** (Copy)
- **Button 5** → **⌘ + V** (Paste)

The app completely suppresses the original button actions (forward/backward navigation), so you get clean, reliable copy/paste functionality without any interference.

### Key Features

✅ **No Forward/Backward Navigation** - Original mouse button events are suppressed  
✅ **System-Wide** - Works in all applications  
✅ **Lightweight** - Minimal CPU and memory usage  
✅ **Menu Bar Integration** - Easy access to preferences and controls  
✅ **Session Statistics** - Track how many times you've copied and pasted  
✅ **Professional Logging** - Built-in debugging with os.log framework  
✅ **Thread-Safe** - Proper concurrency handling for reliability  

---

## Requirements

- **macOS 11.0 (Big Sur)** or later
- **Xcode 13+** with Command Line Tools
- **A mouse with 5+ buttons** (Button 4 and Button 5)
- **Accessibility permissions** (required for monitoring mouse buttons)

---

## Installation from Scratch

### Step 1: Install Xcode

If you don't have Xcode installed:

1. Open **App Store** on your Mac
2. Search for **"Xcode"**
3. Click **"Get"** or **"Install"** (it's free but large, ~15 GB)
4. Wait for installation to complete

### Step 2: Install Xcode Command Line Tools

Open Terminal and run:

```bash
xcode-select --install
```

Click **"Install"** when prompted. This installs the necessary build tools.

### Step 3: Clone the Repository

```bash
# Navigate to where you want to store the project
cd ~/Desktop

# Clone the repository
git clone https://github.com/parthkishan20/MouseMacro.git

# Enter the project directory
cd MouseMacro
```

### Step 4: Verify Project Structure

```bash
# List the contents
ls -la

# You should see:
# - MouseMacro/ (source code folder)
# - MouseMacro.xcodeproj/ (Xcode project)
# - README.md
```

---

## Building the Application

### Clean Build from Terminal

```bash
# Navigate to project directory
cd ~/Desktop/MouseMacro

# Clean any previous builds
rm -rf ~/Library/Developer/Xcode/DerivedData/MouseMacro-*

# Build the application
xcodebuild -scheme MouseMacro -configuration Debug build
```

**Wait for:** `** BUILD SUCCEEDED **`

The built application will be located at:
```
~/Library/Developer/Xcode/DerivedData/MouseMacro-*/Build/Products/Debug/MouseMacro.app
```

---

## Granting Accessibility Permissions

**IMPORTANT:** This step is required for the app to work!

### Step 1: Open System Settings

```bash
# Open Accessibility settings directly
open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
```

Or manually:
1. Click Apple menu → **System Settings**
2. Go to **Privacy & Security**
3. Click **Accessibility** in the left sidebar

### Step 2: Grant Permission

1. Click the **🔒 lock icon** at the bottom and enter your password
2. Click the **+** button to add an app
3. Navigate to:
   ```
   ~/Library/Developer/Xcode/DerivedData/MouseMacro-<hash>/Build/Products/Debug/
   ```
4. Select **MouseMacro.app** and click **"Open"**
5. Make sure the toggle next to **MouseMacro** is **ON** (blue)
6. Click the lock icon again to prevent further changes

**Alternative:** The app will prompt you automatically on first launch. Click **"Open Settings"** and enable it.

---

## Running the Application

### Start the App

```bash
# Run the application
open ~/Library/Developer/Xcode/DerivedData/MouseMacro-*/Build/Products/Debug/MouseMacro.app
```

### Verify It's Running

```bash
# Check if the app is running
pgrep -fl MouseMacro
```

You should see output like:
```
12345 /Users/yourname/Library/Developer/Xcode/DerivedData/MouseMacro-.../MouseMacro
```

### Look for the Menu Bar Icon

A **⚡️ bolt icon** will appear in your menu bar (top-right corner of your screen).

---

## Testing the Application

### Test 1: Open Preferences

1. Click the **⚡️ bolt icon** in your menu bar
2. Select **"Preferences..."**
3. A window should open showing:
   - Current button mappings
   - Session statistics (copies/pastes count)
   - Last triggered action

### Test 2: Test Copy Function (Button 4)

1. Open any text editor (TextEdit, Notes, Safari, etc.)
2. Type some text: `Hello, World!`
3. Select the text
4. Press **Button 4** on your mouse
5. **Expected:** Text is copied (same as ⌘+C)
6. Check the Preferences window - the copy counter should increase

### Test 3: Test Paste Function (Button 5)

1. Click somewhere else in the document
2. Press **Button 5** on your mouse
3. **Expected:** Text is pasted (same as ⌘+V)
4. Check the Preferences window - the paste counter should increase

### Test 4: Verify No Browser Navigation

1. Open Safari or Chrome
2. Navigate through a few web pages (go forward and backward normally)
3. Now press **Button 4** and **Button 5**
4. **Expected:** Should ONLY copy/paste, NOT navigate forward/backward

✅ **If all tests pass, your MouseMacro is working perfectly!**

---

## Stopping the Application

### From Menu Bar

1. Click the **⚡️ bolt icon**
2. Select **"Quit MouseMacro"**

### From Terminal

```bash
# Kill the running app
pkill -f MouseMacro
```

---

## Auto-Start on Login (Optional)

To make MouseMacro launch automatically when you log in:

### Option 1: Using System Settings

1. Copy the app to your Applications folder:
   ```bash
   cp -r ~/Library/Developer/Xcode/DerivedData/MouseMacro-*/Build/Products/Debug/MouseMacro.app /Applications/
   ```

2. Open System Settings → General → Login Items
3. Click **+** button
4. Select **MouseMacro** from Applications
5. Click **"Open"**

### Option 2: Using Terminal

```bash
# First copy to Applications
cp -r ~/Library/Developer/Xcode/DerivedData/MouseMacro-*/Build/Products/Debug/MouseMacro.app /Applications/

# Add to login items
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/MouseMacro.app", hidden:false}'
```

---

## Troubleshooting

### App Doesn't Appear in Menu Bar

**Solution:**
```bash
# Stop any running instances
pkill -f MouseMacro

# Restart the app
open ~/Library/Developer/Xcode/DerivedData/MouseMacro-*/Build/Products/Debug/MouseMacro.app
```

### Buttons Don't Work

**Check Accessibility Permissions:**
```bash
# Open accessibility settings
open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
```

Make sure **MouseMacro** is in the list and **enabled**.

**Restart the app:**
```bash
pkill -f MouseMacro
open ~/Library/Developer/Xcode/DerivedData/MouseMacro-*/Build/Products/Debug/MouseMacro.app
```

### Build Errors

**Clean and rebuild:**
```bash
cd ~/Desktop/MouseMacro
rm -rf ~/Library/Developer/Xcode/DerivedData/MouseMacro-*
xcodebuild -scheme MouseMacro -configuration Debug clean build
```

**Verify Xcode installation:**
```bash
xcode-select -p
```

Should output: `/Applications/Xcode.app/Contents/Developer`

If not, install Command Line Tools:
```bash
xcode-select --install
```

### Preferences Window Doesn't Open

**Restart Xcode and the app:**
```bash
pkill -f Xcode
pkill -f MouseMacro
open ~/Desktop/MouseMacro/MouseMacro.xcodeproj
```

Then rebuild and run.

### Check Logs for Errors

**View real-time logs:**
```bash
log stream --predicate 'subsystem == "com.skybolt.MouseMacro"' --level debug
```

**View recent logs:**
```bash
log show --predicate 'subsystem == "com.skybolt.MouseMacro"' --last 5m
```

---

## Development

### Open in Xcode

```bash
open ~/Desktop/MouseMacro/MouseMacro.xcodeproj
```

### Project Structure

```
MouseMacro/
├── MouseMacro/
│   ├── MouseMacroApp.swift        # App entry point
│   ├── AppDelegate.swift          # Menu bar, event tap setup
│   ├── MouseMacroHandler.swift    # Event handling logic
│   ├── PreferencesView.swift      # Preferences UI
│   ├── ContentView.swift          # Unused (template file)
│   ├── Info.plist                 # App metadata
│   ├── MouseMacro.entitlements    # Security entitlements
│   └── Assets.xcassets/           # App icons
├── MouseMacro.xcodeproj/          # Xcode project files
└── README.md                      # This file
```

### Key Files Explained

- **MouseMacroHandler.swift** - The core logic that:
  - Intercepts mouse button clicks
  - Returns `nil` to suppress original events (prevents forward/backward navigation)
  - Sends keyboard shortcuts (⌘+C, ⌘+V)

- **AppDelegate.swift** - Manages:
  - Menu bar icon and menu
  - Event tap creation and cleanup
  - Accessibility permission checks
  - Preferences window

- **PreferencesView.swift** - SwiftUI interface showing:
  - Current button mappings
  - Session statistics
  - Last triggered action

### Build from Xcode

1. Open the project in Xcode
2. Press **⌘ + R** to build and run
3. Or press **⌘ + B** to build only

---

## Useful Terminal Commands

### Check if App is Running
```bash
pgrep -fl MouseMacro
```

### View App Info
```bash
plutil -p ~/Library/Developer/Xcode/DerivedData/MouseMacro-*/Build/Products/Debug/MouseMacro.app/Contents/Info.plist
```

### Find Built App Location
```bash
find ~/Library/Developer/Xcode/DerivedData -name "MouseMacro.app" -type d 2>/dev/null
```

### Monitor System Events
```bash
log stream --level debug | grep -i "mouse\|button"
```

### Clean All Builds
```bash
rm -rf ~/Library/Developer/Xcode/DerivedData/MouseMacro-*
```

---

## Customization Guide

### Change Button Shortcuts

Want Button 4 to trigger **⌘+P** instead of **⌘+C**? Or **⌘+Shift+4** for screenshots? Here's how:

#### Step 1: Open the Handler File

```bash
# Open in your text editor or Xcode
open MouseMacro/MouseMacroHandler.swift
```

#### Step 2: Modify the Button Actions

Find the `handleMouseEvent` function around **line 21-37**:

```swift
switch buttonNumber {
case 3: // Button 4 on the mouse
    logger.info("Button 4 pressed - triggering ⌘+C")
    sendShortcut(key: .c, modifier: .maskCommand)
    Task { @MainActor in
        PreferencesState.shared.recordCopy()
    }
    return nil
    
case 4: // Button 5 on the mouse
    logger.info("Button 5 pressed - triggering ⌘+V")
    sendShortcut(key: .v, modifier: .maskCommand)
    Task { @MainActor in
        PreferencesState.shared.recordPaste()
    }
    return nil
```

### Common Customization Examples

#### Example 1: Change Button 4 to ⌘+P (Print)

Replace:
```swift
case 3: // Button 4 on the mouse
    logger.info("Button 4 pressed - triggering ⌘+C")
    sendShortcut(key: .c, modifier: .maskCommand)
```

With:
```swift
case 3: // Button 4 on the mouse
    logger.info("Button 4 pressed - triggering ⌘+P")
    sendShortcut(key: .p, modifier: .maskCommand)
```

#### Example 2: Change Button 5 to ⌘+Shift+4 (Screenshot)

Replace:
```swift
case 4: // Button 5 on the mouse
    logger.info("Button 5 pressed - triggering ⌘+V")
    sendShortcut(key: .v, modifier: .maskCommand)
```

With:
```swift
case 4: // Button 5 on the mouse
    logger.info("Button 5 pressed - triggering ⌘+Shift+4")
    sendShortcut(key: .four, modifier: [.maskCommand, .maskShift])
```

#### Example 3: ⌘+Option+Esc (Force Quit)

```swift
case 3: // Button 4
    logger.info("Button 4 pressed - triggering ⌘+Option+Esc")
    sendShortcut(key: .escape, modifier: [.maskCommand, .maskAlternate])
```

#### Example 4: ⌘+Z (Undo)

```swift
case 3: // Button 4
    logger.info("Button 4 pressed - triggering ⌘+Z")
    sendShortcut(key: .z, modifier: .maskCommand)
```

#### Example 5: ⌘+Tab (Switch Apps)

```swift
case 3: // Button 4
    logger.info("Button 4 pressed - triggering ⌘+Tab")
    sendShortcut(key: .tab, modifier: .maskCommand)
```

### Available Modifier Keys

You can combine multiple modifiers:

```swift
.maskCommand        // ⌘ Command key
.maskShift          // ⇧ Shift key
.maskAlternate      // ⌥ Option/Alt key
.maskControl        // ⌃ Control key

// Combine multiple modifiers with array:
[.maskCommand, .maskShift]              // ⌘ + Shift
[.maskCommand, .maskAlternate]          // ⌘ + Option
[.maskCommand, .maskShift, .maskAlternate]  // ⌘ + Shift + Option
```

### Available Keys

All keys are defined in the `VirtualKey` enum (lines 82-176 in MouseMacroHandler.swift):

**Letters:**
```swift
.a, .b, .c, .d, .e, .f, .g, .h, .i, .j, .k, .l, .m, 
.n, .o, .p, .q, .r, .s, .t, .u, .v, .w, .x, .y, .z
```

**Numbers:**
```swift
.zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine
```

**Special Keys:**
```swift
.return       // Enter
.tab          // Tab
.space        // Space
.delete       // Backspace
.escape       // Esc
.command      // ⌘
.shift        // ⇧
.option       // ⌥
.control      // ⌃
```

**Punctuation:**
```swift
.comma        // ,
.period       // .
.slash        // /
.semicolon    // ;
.quote        // '
.leftBracket  // [
.rightBracket // ]
.backslash    // \
.grave        // `
.minus        // -
.equal        // =
```

**Keypad:**
```swift
.keypad0, .keypad1, .keypad2, ..., .keypad9
.keypadPlus, .keypadMinus, .keypadMultiply, .keypadDivide
```

### Step 3: Update PreferencesView (Optional)

If you want the Preferences window to show your new shortcuts, edit `MouseMacro/PreferencesView.swift` around **line 53-73**:

Find:
```swift
HStack {
    Text("Button 4")
        .fontWeight(.medium)
        .frame(width: 80, alignment: .leading)
    Text("→")
        .foregroundColor(.secondary)
    Text("⌘ + C")
        .fontWeight(.semibold)
        .foregroundColor(.blue)
    Text("(Copy)")
        .foregroundColor(.secondary)
        .font(.caption)
}
```

Change to match your new shortcut, for example for ⌘+P:
```swift
HStack {
    Text("Button 4")
        .fontWeight(.medium)
        .frame(width: 80, alignment: .leading)
    Text("→")
        .foregroundColor(.secondary)
    Text("⌘ + P")
        .fontWeight(.semibold)
        .foregroundColor(.blue)
    Text("(Print)")
        .foregroundColor(.secondary)
        .font(.caption)
}
```

Also update the `recordCopy()` and `recordPaste()` methods in PreferencesView.swift (lines 18-26) to reflect your new actions:

```swift
func recordPrint() {  // Rename from recordCopy
    copyCount += 1
    lastAction = "Button 4 → ⌘ + P (Total: \(copyCount))"
}
```

And update the calls in MouseMacroHandler.swift:
```swift
Task { @MainActor in
    PreferencesState.shared.recordPrint()  // Change from recordCopy
}
```

### Step 4: Rebuild and Test

```bash
# Navigate to project
cd ~/Desktop/MouseMacro

# Stop running app
pkill -f MouseMacro

# Rebuild
xcodebuild -scheme MouseMacro -configuration Debug build

# Run
open ~/Library/Developer/Xcode/DerivedData/MouseMacro-*/Build/Products/Debug/MouseMacro.app
```

Test your new shortcuts!

### Advanced: Add More Mouse Buttons

Want to use Button 6, 7, or 8?

Add more cases in the switch statement:

```swift
switch buttonNumber {
case 3: // Button 4
    sendShortcut(key: .c, modifier: .maskCommand)
    return nil
    
case 4: // Button 5
    sendShortcut(key: .v, modifier: .maskCommand)
    return nil
    
case 5: // Button 6 - NEW!
    sendShortcut(key: .x, modifier: .maskCommand)  // ⌘+X (Cut)
    return nil
    
case 6: // Button 7 - NEW!
    sendShortcut(key: .a, modifier: .maskCommand)  // ⌘+A (Select All)
    return nil
    
default:
    return Unmanaged.passUnretained(event)
}
```

### Quick Reference Table

| Shortcut | Key | Modifier | Example |
|----------|-----|----------|---------|
| ⌘+C | `.c` | `.maskCommand` | Copy |
| ⌘+V | `.v` | `.maskCommand` | Paste |
| ⌘+X | `.x` | `.maskCommand` | Cut |
| ⌘+Z | `.z` | `.maskCommand` | Undo |
| ⌘+Shift+Z | `.z` | `[.maskCommand, .maskShift]` | Redo |
| ⌘+S | `.s` | `.maskCommand` | Save |
| ⌘+P | `.p` | `.maskCommand` | Print |
| ⌘+F | `.f` | `.maskCommand` | Find |
| ⌘+Tab | `.tab` | `.maskCommand` | Switch Apps |
| ⌘+Space | `.space` | `.maskCommand` | Spotlight |
| ⌘+Shift+3 | `.three` | `[.maskCommand, .maskShift]` | Screenshot |
| ⌘+Shift+4 | `.four` | `[.maskCommand, .maskShift]` | Area Screenshot |
| ⌘+Option+Esc | `.escape` | `[.maskCommand, .maskAlternate]` | Force Quit |
| ⌘+Q | `.q` | `.maskCommand` | Quit App |
| ⌘+W | `.w` | `.maskCommand` | Close Window |
| ⌘+T | `.t` | `.maskCommand` | New Tab |
| ⌘+N | `.n` | `.maskCommand` | New Window |

---

### Change Menu Bar Icon

Edit `MouseMacro/AppDelegate.swift`:

```swift
// Find this line around line 67:
button.image = NSImage(systemSymbolName: "bolt.circle", accessibilityDescription: "MouseMacro")

// Change "bolt.circle" to any SF Symbol name:
// "computer.mouse", "hand.point.up.fill", "star.fill", etc.
```

Browse SF Symbols: [https://developer.apple.com/sf-symbols/](https://developer.apple.com/sf-symbols/)

---

## FAQ

### Q: Does this work with trackpads?
**A:** No, you need a physical mouse with extra buttons.

### Q: Can I use different buttons?
**A:** Yes! Edit the button numbers in `MouseMacroHandler.swift`. Button numbers:
- 0 = Left click
- 1 = Right click
- 2 = Middle click
- 3 = Button 4 (usually side button)
- 4 = Button 5 (usually other side button)

### Q: Will this work on older macOS versions?
**A:** The minimum supported version is macOS 11.0 (Big Sur). Some features may work on older versions but are not tested.

### Q: Does this affect battery life?
**A:** No, the app uses minimal CPU and only processes mouse events when buttons are clicked.

### Q: Can I run multiple instances?
**A:** No, only one instance should run at a time to avoid conflicts.

### Q: Is my data collected?
**A:** No, this app does not collect, store, or transmit any data. Everything runs locally on your Mac.

---

## Technical Details

### Event Tap Implementation

The app uses `CGEvent.tapCreate` with:
- **Tap location:** `.cgSessionEventTap` (session level)
- **Placement:** `.headInsertEventTap` (before other event handlers)
- **Options:** `.defaultTap` (allows event suppression)
- **Event mask:** Only `otherMouseDown` events (buttons 3+)

### Event Suppression

When Button 4 or 5 is pressed, the handler returns `nil` instead of passing the event through. This completely suppresses the original mouse button action, preventing forward/backward navigation in browsers.

### Keyboard Event Synthesis

Uses `CGEvent(keyboardEventSource:virtualKey:keyDown:)` to create synthetic keyboard events with proper modifier flags (⌘).

### Thread Safety

- UI updates use `@MainActor` to ensure main thread execution
- Event tap callback runs on a dedicated thread
- Logging uses `os.log` for thread-safe structured logging

---

## Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest features
- Submit pull requests

---

## License

This project is open source. Feel free to use, modify, and distribute as needed.

---

## Support

If you encounter any issues not covered in the troubleshooting section:

1. Check the logs: `log show --predicate 'subsystem == "com.skybolt.MouseMacro"' --last 5m`
2. Verify accessibility permissions are granted
3. Ensure you're running macOS 11.0 or later
4. Make sure Xcode Command Line Tools are installed

---

## Acknowledgments

Built with Swift and SwiftUI for macOS.

---

**Enjoy faster copy & paste with MouseMacro! 🖱️✨**
