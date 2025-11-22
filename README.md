# MouseMacro - Beginner's Guide 🖱️

## What is This Project?

MouseMacro is a macOS application that lets you use extra mouse buttons (Button 4 and Button 5) to perform keyboard shortcuts. Specifically:
- **Button 4** → Triggers **⌘ + C** (Copy)
- **Button 5** → Triggers **⌘ + V** (Paste)

This app runs in your Mac's menu bar (the top-right corner of your screen) and works everywhere on your Mac!

---

## Prerequisites (What You Need)

Before you start, make sure you have:

1. **A Mac computer** running macOS (this won't work on Windows or Linux)
2. **Xcode installed** - This is Apple's free development tool
   - Open the **App Store** on your Mac
   - Search for "Xcode"
   - Click "Get" or "Install" (it's a large download, ~10-15 GB)
   - Wait for it to install completely

3. **A mouse with extra buttons** (Button 4 and Button 5)

---

## Project Structure - What Each File Does

Here's a breakdown of what each file does in this project:

### 📁 **MouseMacro/** (Main Folder)
This folder contains all the Swift code files:

1. **MouseMacroApp.swift** - The Entry Point
   - This is where the app starts
   - Think of it as the "main door" to your application
   - It sets up the app and connects to the AppDelegate

2. **AppDelegate.swift** - The Brain
   - Creates the menu bar icon (the little icon in your top-right corner)
   - Manages permissions for accessibility access
   - Sets up the "event tap" that listens for mouse button clicks
   - Creates the Preferences window

3. **MouseMacroHandler.swift** - The Action Handler
   - This is where the magic happens!
   - Listens for Button 4 and Button 5 clicks
   - Sends the keyboard shortcuts (⌘+C or ⌘+V) when buttons are pressed
   - Contains a mapping of keyboard keys to their codes

4. **PreferencesView.swift** - The Settings Window
   - Shows which buttons do what
   - Displays the last action you triggered
   - This is what you see when you click "Preferences" in the menu bar

5. **ContentView.swift** - Unused View
   - This file isn't currently being used in the app
   - It was created by default when the project was made

6. **Info.plist** - App Information
   - Contains metadata about your app (like its name and identifier)
   - Explains why the app needs certain permissions

7. **MouseMacro.entitlements** - Security Settings
   - Tells macOS what special permissions this app needs
   - Required for the app to run in Apple's sandbox environment

8. **Assets.xcassets/** - Images and Icons
   - Stores the app's icon and any images
   - Currently uses default assets

### 📁 **MouseMacro.xcodeproj/**
This is the Xcode project file - it contains all the settings and configurations for building your app. You'll open this to work on the project.

---

## How to Open and Run the Project

### Step 1: Open the Project in Xcode

1. Open **Finder** on your Mac
2. Navigate to `/Users/parthkumarpatel/Desktop/MouseMacro/`
3. Look for the file named **MouseMacro.xcodeproj** (it has a blue icon)
4. **Double-click** on `MouseMacro.xcodeproj`
5. Xcode will open with your project loaded

### Step 2: Understanding the Xcode Interface

When Xcode opens, you'll see several areas:

- **Left Panel (Navigator)**: Shows all your project files
- **Center Area (Editor)**: Where you view and edit code
- **Right Panel (Utilities)**: Shows properties and settings (can be hidden)
- **Top Toolbar**: Contains the Run button and other tools
- **Bottom Area (Debug)**: Shows logs and errors when running

### Step 3: Build and Run the App

1. In the **top toolbar**, you'll see a scheme selector (it might say "MouseMacro" and "My Mac")
2. Make sure it says **"My Mac"** or your computer's name (not "Any Mac")
3. Click the **Play button** (▶️) in the top-left corner of Xcode
   - OR press **⌘ + R** on your keyboard
4. Xcode will compile (build) the code - this might take a few seconds the first time
5. If everything works, you should see a **bolt icon** appear in your menu bar (top-right corner)

### Step 4: Grant Permissions

The first time you run the app, you'll see a pop-up asking for **Accessibility permissions**:

1. Click **"Open Settings"**
2. You'll be taken to **System Settings → Privacy & Security → Accessibility**
3. Find **MouseMacro** in the list
4. Toggle the switch to **ON** (you may need to click the lock icon and enter your password first)
5. Close System Settings and restart the app from Xcode

### Step 5: Test the App

1. Look for the **bolt icon** in your menu bar (top-right)
2. Click it to see the menu with "Preferences" and "Quit"
3. Open any text editor (like Notes or TextEdit)
4. Type some text
5. Press **Button 4** on your mouse - it should copy the text
6. Press **Button 5** on your mouse - it should paste the text
7. Click on "Preferences" in the menu to see which button you last pressed

---

## How the Code Works - A Simple Explanation

### The Flow from Start to Finish:

1. **App Launches** (`MouseMacroApp.swift`)
   - When you run the app, it starts here
   - It immediately connects to the `AppDelegate`

2. **AppDelegate Sets Up Everything** (`AppDelegate.swift`)
   - Creates the menu bar icon
   - Checks if you've granted accessibility permissions
   - Creates an "event tap" - this is like a listener that watches for mouse button clicks
   - The event tap specifically watches for "otherMouseDown" events (Buttons 3, 4, 5, etc.)

3. **Listening for Mouse Clicks** (`MouseMacroHandler.swift`)
   - When you click Button 4 or Button 5, the event tap catches it
   - The `handleMouseEvent` function is called
   - It checks which button was pressed (3 = Button 4, 4 = Button 5)
   - If Button 4: calls `sendShortcut` with "c" and Command modifier
   - If Button 5: calls `sendShortcut` with "v" and Command modifier

4. **Sending Keyboard Shortcuts** (`MouseMacroHandler.swift`)
   - The `sendShortcut` function converts the letter to a key code
   - It creates a fake keyboard event (as if you pressed ⌘+C or ⌘+V)
   - Posts the event to the system
   - Your Mac thinks you actually pressed those keys!

5. **Updating the UI** (`PreferencesView.swift`)
   - After each button press, the `lastAction` text updates
   - If you have the Preferences window open, you'll see it change in real-time

---

## Common Beginner Questions

### Q: Why do I need accessibility permissions?
**A:** macOS protects your privacy. Apps can't see your keyboard or mouse input without permission. This app needs to watch for mouse button clicks and send keyboard shortcuts, so it needs accessibility access.

### Q: What is Swift?
**A:** Swift is Apple's programming language for making apps for iPhone, iPad, Mac, Apple Watch, etc. The files ending in `.swift` are written in this language.

### Q: What is SwiftUI?
**A:** SwiftUI is a modern way to create user interfaces (the visual parts of apps) using Swift. The `PreferencesView.swift` file uses SwiftUI.

### Q: Can I change which buttons do what?
**A:** Yes! In `MouseMacroHandler.swift`, look for these lines:
```swift
if buttonNumber == 3 {  // This is Button 4
    sendShortcut(key: "c", modifier: .maskCommand)
```
You can change `"c"` to any letter in the `keyMapping` dictionary.

### Q: Can I add more buttons?
**A:** Yes! Just add more `else if` statements for different button numbers.

### Q: The app crashes or doesn't work. What do I do?
**A:** 
1. Check the **Debug area** in Xcode (bottom panel) for error messages
2. Make sure you granted accessibility permissions
3. Make sure your mouse actually has Button 4 and Button 5
4. Try quitting and restarting the app

### Q: How do I stop the app?
**A:** Click the bolt icon in the menu bar and choose "Quit", or press the **Stop button** (⏹️) in Xcode.

---

## How to Customize the App

### Change the Menu Bar Icon

In `AppDelegate.swift`, find this line:
```swift
statusItem.button?.image = NSImage(systemSymbolName: "bolt.circle", accessibilityDescription: "MouseMacro")
```

Change `"bolt.circle"` to any SF Symbol name, like:
- `"computer.mouse"`
- `"hand.point.up.fill"`
- `"star.fill"`

### Add More Keyboard Shortcuts

In `MouseMacroHandler.swift`, you can add more key mappings:
```swift
let keyMapping: [String: CGKeyCode] = [
    "a": 0, "b": 11, "c": 8, "d": 2, "e": 14,
    // Add more letters, numbers, or special keys here
]
```

Then modify the `handleMouseEvent` function to use them.

---

## Troubleshooting

### "Failed to create event tap"
- Make sure you've granted Accessibility permissions
- Restart your Mac if permissions still don't work

### Xcode says "Build Failed"
- Read the error messages in the bottom panel
- Make sure you're running macOS 11.0 or later
- Try cleaning the build: Go to **Product → Clean Build Folder**

### The app doesn't appear in the menu bar
- Check if it's hidden behind other icons (try holding ⌘ and dragging icons around)
- Check if there are any crash logs in Xcode's debug area

---

## Next Steps - Learning More

If you want to learn more about Swift and macOS development:

1. **Apple's Swift Documentation**: https://swift.org/documentation/
2. **SwiftUI Tutorials**: https://developer.apple.com/tutorials/swiftui
3. **Xcode Help**: In Xcode, go to **Help → Xcode Help**

---

## Summary - The Big Picture

This app is a **menu bar utility** that:
1. Runs invisibly in the background
2. Watches for specific mouse button clicks
3. Converts those clicks into keyboard shortcuts
4. Shows up as an icon in your menu bar
5. Has a preferences window to show you what it's doing

It's a small but complete macOS app that demonstrates:
- Menu bar apps
- Event handling
- Accessibility APIs
- SwiftUI for interfaces
- App permissions

Congratulations on exploring your first Swift/macOS project! 🎉
