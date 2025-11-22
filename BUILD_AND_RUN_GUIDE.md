# How to Build and Run MouseMacro

## Quick Start Guide

### Option 1: Run from Xcode (Recommended for Testing)

1. **Open the Project**
   ```bash
   open /Users/parthkumarpatel/Desktop/MouseMacro/MouseMacro.xcodeproj
   ```
   Or double-click `MouseMacro.xcodeproj` in Finder

2. **Build and Run**
   - Click the **Play button** (▶️) in the top-left corner of Xcode
   - Or press **⌘ + R** on your keyboard
   - The app will compile and launch automatically

3. **Look for the Menu Bar Icon**
   - A **bolt icon** (⚡️) will appear in your menu bar (top-right)
   - If you don't see it, check Activity Monitor to confirm it's running

4. **Grant Permissions**
   - On first run, you'll see a permission dialog
   - Click **"Open Settings"**
   - Enable **MouseMacro** in Accessibility settings
   - Restart the app from Xcode

### Option 2: Build from Terminal

1. **Navigate to Project Directory**
   ```bash
   cd /Users/parthkumarpatel/Desktop/MouseMacro
   ```

2. **Build the App**
   ```bash
   xcodebuild -scheme MouseMacro -configuration Debug build
   ```
   
   This creates the app at:
   ```
   ~/Library/Developer/Xcode/DerivedData/MouseMacro-*/Build/Products/Debug/MouseMacro.app
   ```

3. **Run the Built App**
   ```bash
   open ~/Library/Developer/Xcode/DerivedData/MouseMacro-*/Build/Products/Debug/MouseMacro.app
   ```

### Option 3: Build and Copy to Applications

1. **Build Release Version**
   ```bash
   cd /Users/parthkumarpatel/Desktop/MouseMacro
   xcodebuild -scheme MouseMacro -configuration Release build
   ```

2. **Find the Built App**
   ```bash
   open ~/Library/Developer/Xcode/DerivedData/MouseMacro-*/Build/Products/Release/
   ```

3. **Copy to Applications**
   - Drag `MouseMacro.app` to your Applications folder
   - Or use terminal:
   ```bash
   cp -r ~/Library/Developer/Xcode/DerivedData/MouseMacro-*/Build/Products/Release/MouseMacro.app /Applications/
   ```

4. **Launch It**
   ```bash
   open /Applications/MouseMacro.app
   ```

---

## Granting Accessibility Permissions

MouseMacro requires accessibility permissions to monitor mouse buttons and send keyboard shortcuts.

### Step-by-Step

1. **Open System Settings**
   - Click Apple menu → System Settings
   - Or click "Open Settings" when prompted by the app

2. **Navigate to Accessibility**
   - Go to **Privacy & Security** → **Accessibility**

3. **Enable MouseMacro**
   - Click the lock icon (🔒) and enter your password
   - Find **MouseMacro** in the list
   - Toggle it **ON**

4. **Restart the App**
   - Quit MouseMacro (click menu bar icon → Quit)
   - Launch it again

---

## Verifying It Works

1. **Check Menu Bar**
   - Look for the bolt icon (⚡️) in your menu bar

2. **Open Preferences**
   - Click the bolt icon
   - Select "Preferences..."
   - You should see the configuration window

3. **Test the Buttons**
   - Open any app (like TextEdit or Notes)
   - Type some text and select it
   - Press **Button 4** on your mouse → Text should be copied
   - Press **Button 5** → Text should be pasted
   - Check Preferences window to see the counter increase

4. **Check Console Logs** (Optional)
   ```bash
   log stream --predicate 'subsystem == "com.skybolt.MouseMacro"' --level debug
   ```
   This shows real-time logging when you click buttons

---

## Stopping the App

### From Menu Bar
- Click the bolt icon (⚡️)
- Select **"Quit MouseMacro"**

### From Activity Monitor
- Open Activity Monitor (⌘ + Space, type "Activity Monitor")
- Find "MouseMacro"
- Click Stop (×) button

### From Terminal
```bash
pkill -f MouseMacro
```

---

## Troubleshooting

### App Doesn't Appear in Menu Bar

**Check if it's running:**
```bash
ps aux | grep MouseMacro
```

**Kill and restart:**
```bash
pkill -f MouseMacro
open /Applications/MouseMacro.app  # or run from Xcode
```

### Buttons Don't Work

1. **Check Accessibility Permissions**
   - System Settings → Privacy & Security → Accessibility
   - Make sure MouseMacro is enabled

2. **Check Event Tap**
   - Look at console logs:
   ```bash
   log show --predicate 'subsystem == "com.skybolt.MouseMacro"' --last 5m
   ```
   - Look for "Event tap created successfully"

3. **Verify Mouse Buttons**
   - Make sure your mouse actually has Button 4 and Button 5
   - Test in another app to confirm they work

### Build Errors

**Clean Build Folder:**
```bash
cd /Users/parthkumarpatel/Desktop/MouseMacro
xcodebuild clean -scheme MouseMacro
```

**Delete Derived Data:**
```bash
rm -rf ~/Library/Developer/Xcode/DerivedData/MouseMacro-*
```

**Then rebuild:**
```bash
xcodebuild -scheme MouseMacro -configuration Debug build
```

### Code Signing Warning

The warning about code signing is normal for local development. The app will still work fine on your Mac.

To sign it properly (optional):
1. Open project in Xcode
2. Select project in navigator
3. Select "MouseMacro" target
4. Go to "Signing & Capabilities"
5. Check "Automatically manage signing"
6. Select your Apple ID team

---

## Making It Launch at Login (Optional)

### Manually

1. Copy app to Applications:
   ```bash
   cp -r ~/Library/Developer/Xcode/DerivedData/MouseMacro-*/Build/Products/Release/MouseMacro.app /Applications/
   ```

2. System Settings → General → Login Items

3. Click **+** button

4. Select **MouseMacro** from Applications

### Using Terminal

```bash
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/MouseMacro.app", hidden:false}'
```

---

## Development Workflow

### Edit Code
1. Open project in Xcode
2. Make changes to `.swift` files
3. Press **⌘ + B** to build
4. Press **⌘ + R** to run

### View Logs
```bash
# Real-time logs
log stream --predicate 'subsystem == "com.skybolt.MouseMacro"' --level debug

# Recent logs
log show --predicate 'subsystem == "com.skybolt.MouseMacro"' --last 1h
```

### Debug in Xcode
1. Set breakpoints by clicking line numbers
2. Run with **⌘ + R**
3. When breakpoint hits, inspect variables in Debug area
4. Use Console at bottom to print values

---

## Useful Commands

```bash
# Check if app is running
pgrep -fl MouseMacro

# View app info
plutil -p ~/Library/Developer/Xcode/DerivedData/MouseMacro-*/Build/Products/Debug/MouseMacro.app/Contents/Info.plist

# Check entitlements
codesign -d --entitlements - ~/Library/Developer/Xcode/DerivedData/MouseMacro-*/Build/Products/Debug/MouseMacro.app

# Monitor system logs
log stream --level debug | grep -i mouse

# Check accessibility permissions programmatically
sqlite3 '/Library/Application Support/com.apple.TCC/TCC.db' 'SELECT * FROM access WHERE service="kTCCServiceAccessibility"'
```

---

## Next Steps

1. **Customize Button Mappings**
   - Edit `MouseMacro/MouseMacroHandler.swift`
   - Change the key codes in the switch statement

2. **Change Menu Bar Icon**
   - Edit `MouseMacro/AppDelegate.swift`
   - Change `"bolt.circle"` to any SF Symbol name

3. **Add More Features**
   - Check `TECHNICAL_IMPROVEMENTS.md` for enhancement ideas
   - Follow Swift and macOS best practices

---

## Support

If you encounter issues:

1. Check Console logs for errors
2. Verify accessibility permissions
3. Ensure Xcode Command Line Tools are installed:
   ```bash
   xcode-select --install
   ```
4. Make sure you're on macOS 11.0 or later

Happy coding! 🎉
