# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

iOS pilot logbook app built with SwiftUI, targeting iOS 26.4. Created with Xcode 26.4.1. No external dependencies yet.

Core features:
- Browse flight log entries
- Create new log entries
- Sync logs with a remote web server

## Build & Run

Build from the command line:
```bash
xcodebuild -project weblogbook-app.xcodeproj -scheme weblogbook-app -destination 'platform=iOS Simulator,name=iPhone 16' build
```

Run tests (once added):
```bash
xcodebuild -project weblogbook-app.xcodeproj -scheme weblogbook-app -destination 'platform=iOS Simulator,name=iPhone 16' test
```

The primary way to build and run is via Xcode — open `weblogbook-app.xcodeproj`.

## Architecture

- `weblogbook_appApp.swift` — app entry point (`@main`), sets up the `WindowGroup` with `ContentView`
- `ContentView.swift` — root SwiftUI view
- `Assets.xcassets` — image and color assets

The project uses Xcode's file system synchronized groups (no manual file references in the `.pbxproj`), so new `.swift` files added to the `weblogbook-app/` directory are automatically included in the build.
