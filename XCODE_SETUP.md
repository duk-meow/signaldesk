# How to Run in Xcode

## Quick Steps:

1. **Open the project:**
   - Navigate to: `d:\Pratyush\AppDev\swift\signaldesk\app\`
   - Double-click: `signaldesk.xcodeproj`

2. **Once Xcode opens:**
   - Look at the top toolbar
   - Next to the Play button (▶️), you'll see a device selector
   - Click it and choose:
     - **"My Mac"** (to run on your Mac)
     - **"iPhone 15"** or any simulator (to run on iOS)

3. **Click the Play button (▶️)** or press **Cmd + R**

## Troubleshooting:

### "No scheme" or "No run button"
- Go to: **Product → Scheme → signaldesk**
- Make sure "signaldesk" is checked

### "Cannot run on this device"
- Click the device selector (next to Play button)
- Choose "My Mac (Designed for iPad)" or any iOS Simulator

### Build errors about missing files
- Close Xcode
- Delete: `~/Library/Developer/Xcode/DerivedData/signaldesk-*`
- Reopen and try again

### Platform-specific:
The code works on:
- ✅ macOS (native Mac app)
- ✅ iOS (iPhone/iPad)
- ✅ iPadOS

## What to do after it runs:

1. The app will show a login screen
2. First, make sure you've updated [Config.swift](app/MyApp/Utils/Config.swift) with your API URLs
3. Then you can signup/login

## If Play button is still missing:

Press **Cmd + <** (or go to Product → Scheme → Edit Scheme) and verify:
- Run is enabled
- Build Configuration is set to "Debug"
