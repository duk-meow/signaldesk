# Quick Start: Paste Your Environment Variables

## Step 1: Open Config.swift

File location: `app/MyApp/Utils/Config.swift`

## Step 2: Replace with Your URLs

Find your TypeScript project's `.env` file and copy the values to Swift:

```swift
struct Config {
    // FROM: NEXT_PUBLIC_API_URL in .env
    static let apiURL = "PASTE_HERE"
    
    // FROM: NEXT_PUBLIC_SOCKET_URL in .env  
    static let socketURL = "PASTE_HERE"
    
    // FROM: AI service URL (if you have one)
    static let aiServiceURL = "PASTE_HERE"
}
```

## Example

If your `.env` looks like this:
```
NEXT_PUBLIC_API_URL=http://localhost:3000
NEXT_PUBLIC_SOCKET_URL=http://localhost:3001
```

Your `Config.swift` should be:
```swift
struct Config {
    static let apiURL = "http://localhost:3000"
    static let socketURL = "http://localhost:3001"
    static let aiServiceURL = "http://localhost:8000"
}
```

## Step 3: Run the App

1. Open `signaldesk.xcodeproj` in Xcode
2. Select your device/simulator
3. Press Cmd + R to run

That's it! The app will connect to your backend services.
