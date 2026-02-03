# SignalDesk Swift App

This is a Swift/SwiftUI conversion of the TypeScript SignalDesk application. It maintains the same functionality as the original with minimal UI design.

## Architecture

The app follows the same structure as the TypeScript version:

### Models
- **User.swift** - User model with authentication data
- **Project.swift** - Workspace/project model
- **Group.swift** - Chat channels and DM groups
- **Message.swift** - Chat messages with file metadata
- **Task.swift** - Task items (placeholder for future)

### Services
- **APIClient.swift** - Base HTTP client with token authentication
- **AuthService.swift** - Login, signup, token verification
- **ProjectService.swift** - Project CRUD operations
- **ChatService.swift** - Group and message operations
- **SocketService.swift** - WebSocket real-time communication
- **TaskService.swift** - Task operations (placeholder)

### ViewModels (Stores)
- **AuthStore** - Authentication state management
- **ProjectStore** - Projects state and operations
- **GroupStore** - Groups/channels state management
- **ChatStore** - Messages and real-time chat
- **UIStore** - UI state (modals, dialogs)

### Views
- **Auth/** - Login and signup screens
- **Dashboard/** - Main app layout with sidebar
- **Chat/** - Message list and input

## Configuration

### Step 1: Update API URLs

Open `app/MyApp/Utils/Config.swift` and paste your actual URLs:

```swift
struct Config {
    static let apiURL = "YOUR_API_URL_HERE"
    static let socketURL = "YOUR_SOCKET_URL_HERE"
    static let aiServiceURL = "YOUR_AI_SERVICE_URL_HERE"
}
```

Example from your .env file:
- `NEXT_PUBLIC_API_URL` → `Config.apiURL`
- `NEXT_PUBLIC_SOCKET_URL` → `Config.socketURL`
- AI service URL → `Config.aiServiceURL`

### Step 2: Build and Run

1. Open `signaldesk.xcodeproj` in Xcode
2. Select your target device (iPhone, iPad, or Mac)
3. Press Cmd+R to build and run

## Features Implemented

✅ **Authentication**
- Login with email/password
- Signup with name/email/password
- Token-based authentication
- Automatic token verification on app launch

✅ **Projects**
- List all user projects
- Create new projects
- Switch between projects
- Join projects by ID

✅ **Groups/Channels**
- List groups per project
- Create new groups
- Switch between groups
- Join/leave groups via WebSocket

✅ **Real-time Chat**
- Send and receive messages
- WebSocket connection
- Typing indicators
- Message history loading

✅ **WebSocket Integration**
- Real-time message delivery
- Join/leave group events
- Typing status broadcasting
- Connection management

## API Endpoints Used

Same as TypeScript version:
- `POST /api/auth/login`
- `POST /api/auth/signup`
- `GET /api/auth/verify`
- `GET /api/projects`
- `POST /api/projects`
- `POST /api/projects/join`
- `GET /api/projects/:id/groups`
- `GET /api/groups/:id/messages`
- WebSocket events: `join-group`, `leave-group`, `send-message`, `typing`

## Minimal UI Design

As requested, the UI is intentionally minimal:
- Standard iOS/macOS native components
- No custom styling or colors
- Simple list-based navigation
- Basic text fields and buttons
- Focus on functionality over design

## Notes

1. **WebSocket Implementation**: Uses native `URLSessionWebSocketTask` instead of Socket.IO library for simplicity
2. **Data Persistence**: Uses `UserDefaults` for token storage
3. **Async/Await**: Uses modern Swift concurrency throughout
4. **ObservableObject**: State management with Combine framework
5. **Cross-Platform**: Works on iOS, iPadOS, and macOS

## Troubleshooting

### Connection Issues
- Verify API URLs in `Config.swift`
- Check that backend services are running
- Ensure WebSocket URL uses correct protocol (ws:// or wss://)

### Build Errors
- Make sure you have Xcode 15+ installed
- Set minimum deployment target to iOS 16+ or macOS 13+
- Clean build folder (Shift+Cmd+K) and rebuild

### Authentication Issues
- Check API endpoint format (should include `/api` prefix)
- Verify backend is accepting requests
- Check token format in APIClient

## Future Enhancements

The following features are stubbed but not fully implemented:
- Task management
- AI summaries
- File uploads
- User invitations
- Channel settings
- Project editing
