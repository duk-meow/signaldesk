# SignalDesk iOS App

A complete Swift/SwiftUI clone of the SignalDesk TypeScript application with real-time chat, project management, and WebSocket communication.

## 📋 Prerequisites

- **macOS** with Xcode 15.0 or later
- **iOS 17.0+** target device or simulator
- **Backend Server** running (your TypeScript SignalDesk API)
- **Network Access** to your backend API

## 🚀 Quick Start

### 1. Configure API Endpoints

Before running the app, you **MUST** update the API URLs:

1. Open `signaldesk/sigdesk/Utils/Config.swift`
2. Replace the placeholder URLs with your actual backend URLs:

```swift
struct Config {
    // Replace these with your actual URLs
    static let apiURL = "http://your-backend-ip:3000"  // Your API server
    static let socketURL = "ws://your-backend-ip:3000" // Your WebSocket server
    static let aiServiceURL = "http://your-ai-service-ip:8000" // Your AI service
}
```

**Example for local development:**
```swift
static let apiURL = "http://localhost:3000"
static let socketURL = "ws://localhost:3000"
static let aiServiceURL = "http://localhost:8000"
```

**Example for network testing (iPhone on same WiFi):**
```swift
static let apiURL = "http://192.168.1.100:3000"
static let socketURL = "ws://192.168.1.100:3000"
static let aiServiceURL = "http://192.168.1.100:8000"
```

> **Note:** Find your computer's IP address:
> - Windows: Run `ipconfig` in Command Prompt, look for IPv4 Address
> - Mac: System Preferences → Network → Your connection → IP Address

### 2. Open in Xcode

1. Navigate to the project folder in Finder:
   ```
   D:\Pratyush\AppDev\swift\signaldesk\
   ```

2. Double-click `signaldesk.xcodeproj` to open in Xcode

### 3. Select Target Device

1. In Xcode, click the device dropdown (top-left, next to Play/Stop buttons)
2. Choose either:
   - **iPhone Simulator** (recommended for first run): `iPhone 15 Pro`
   - **Your Physical Device** (if connected via USB)

### 4. Build and Run

1. Press the **Play button** (▶️) or press `Cmd + R`
2. Wait for the app to build and launch
3. The simulator/device will open with the app running

## 🔧 Backend Requirements

Your TypeScript backend **MUST** be running with these endpoints available:

### Authentication Endpoints
- `POST /api/auth/signup` - Create new account
- `POST /api/auth/login` - Login with credentials
- `GET /api/auth/verify` - Verify JWT token

### Project Endpoints
- `GET /api/projects` - Get all projects
- `POST /api/projects` - Create new project

### Group/Channel Endpoints
- `GET /api/groups?projectId=xxx` - Get groups for a project
- `POST /api/groups` - Create new group

### Message Endpoints
- `GET /api/messages?groupId=xxx` - Get messages for a group
- `POST /api/messages` - Send a message

### WebSocket Events
The app listens for and emits these socket events:
- `authenticate` - Authenticate WebSocket connection
- `join-group` - Join a chat group
- `leave-group` - Leave a chat group
- `send-message` - Send a message
- `typing` - Send typing indicator
- `new-message` - Receive new messages
- `user-typing` - Receive typing notifications
- `ai-status` - Receive AI status updates
- `signals-updated` - Receive signal notifications

## 📁 Project Structure

```
signaldesk/sigdesk/
├── Models/               # Data models
│   ├── User.swift       # User model with auth responses
│   ├── Project.swift    # Project model
│   ├── Group.swift      # Group/Channel model
│   └── Message.swift    # Message model
│
├── Services/            # API and network layer
│   ├── APIClient.swift  # Generic HTTP client
│   ├── AuthService.swift      # Authentication APIs
│   ├── ProjectService.swift   # Project CRUD
│   ├── GroupService.swift     # Group CRUD
│   ├── MessageService.swift   # Message APIs
│   └── SocketService.swift    # WebSocket connection
│
├── ViewModels/          # State management (ObservableObject)
│   ├── AuthStore.swift  # Auth state (user, token, login/logout)
│   ├── ProjectStore.swift     # Projects state
│   ├── GroupStore.swift       # Groups state
│   └── ChatStore.swift        # Messages & real-time chat
│
├── Views/               # UI Components
│   ├── Auth/           # Login & Signup screens
│   ├── Dashboard/      # Main app layout with sidebars
│   ├── Chat/          # Message list, input, typing indicators
│   └── Modals/        # Create project/group modals
│
├── Utils/              # Helper utilities
│   ├── Config.swift    # ⚠️ API URLs (UPDATE THIS!)
│   └── Extensions.swift # Color extensions, etc.
│
├── ContentView.swift   # Root navigation
└── sigdeskApp.swift   # App entry point with stores
```

## 🎯 App Flow

1. **Launch** → `ContentView` checks for saved auth token
2. **Not Logged In** → Shows Login/Signup screen
3. **Login Success** → Saves token, loads `DashboardView`
4. **Dashboard** → Three columns:
   - Left: Project list with create button
   - Middle: Group/Channel list for selected project
   - Right: Chat area for selected group
5. **Real-time Chat** → WebSocket connects, messages sync automatically

## 🐛 Troubleshooting

### "No Projects Showing"
- Check that your backend is running
- Verify `Config.swift` has correct API URL
- Check Xcode console for network errors
- Try creating a project using the "+" button

### "Cannot Connect to WebSocket"
- Ensure WebSocket URL in `Config.swift` starts with `ws://` (not `http://`)
- Check backend WebSocket server is running
- Verify firewall allows connections on that port

### "Login Failed"
- Check backend is running and accessible
- Verify API URL in `Config.swift` is correct
- Check Xcode console for error messages
- Try signup to create a new account first

### "App Crashes on Launch"
1. In Xcode, open **Product → Scheme → Edit Scheme**
2. Go to **Run → Diagnostics**
3. Enable **Thread Sanitizer** to find issues
4. Check console output for error messages

### "Cannot Run on Simulator"
- Ensure you selected iOS 17.0+ simulator
- Try **Product → Clean Build Folder** (`Cmd + Shift + K`)
- Restart Xcode

### "Network Request Failed"
- If testing on physical device, use your computer's IP address (not `localhost`)
- Ensure iPhone and computer are on same WiFi network
- Disable VPN if active
- Check firewall settings allow incoming connections

## 📱 Testing on Physical iPhone

1. Connect iPhone via USB
2. In Xcode, select your iPhone from device dropdown
3. If prompted, trust the computer on your iPhone
4. Update `Config.swift` with your computer's IP address:
   ```swift
   static let apiURL = "http://192.168.1.XXX:3000"  // Your computer's IP
   ```
5. Click Run (▶️)
6. On iPhone, go to Settings → General → VPN & Device Management
7. Trust your developer certificate
8. Run the app again

## 🔑 Key Features Implemented

✅ **Authentication** - JWT-based login/signup with token storage  
✅ **Projects** - Create and select projects (workspaces)  
✅ **Groups/Channels** - Create and select chat groups  
✅ **Real-time Chat** - Send/receive messages via WebSocket  
✅ **Typing Indicators** - See when others are typing  
✅ **Auto-reconnect** - WebSocket reconnects if connection drops  
✅ **Persistent Sessions** - Stay logged in across app restarts  
✅ **Clean UI** - Native SwiftUI with smooth animations  

## 📚 Learn More

- **SwiftUI Tutorial:** [Apple's SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- **Xcode Guide:** [Xcode Documentation](https://developer.apple.com/documentation/xcode)
- **Debugging:** Check Xcode console (bottom panel) for logs and errors

## 💡 Tips for First-Time Users

1. **Always check the console** - Xcode's console shows network requests, errors, and print statements
2. **Use breakpoints** - Click line numbers in Xcode to pause execution and inspect variables
3. **Simulator vs Device** - Simulator is faster for development, but test on device for real performance
4. **Hot Reload** - Press `Cmd + R` to rebuild and see changes
5. **Clean Build** - If things act weird, try `Cmd + Shift + K` then `Cmd + R`

## 🆘 Need Help?

1. Check Xcode console output for error messages
2. Verify backend server is running and accessible
3. Ensure `Config.swift` URLs are correct
4. Try running the TypeScript app first to confirm backend works
5. Check your network connection (WiFi, firewall, VPN)

---

**Ready to build?** Open `signaldesk.xcodeproj` and press ▶️
