# WebLogbook iOS

A work-in-progress iOS companion app for [web-logbook](https://github.com/vsimakhin/web-logbook) — a self-hosted pilot logbook web application created and maintained by [vsimakhin](https://github.com/vsimakhin). This app connects to your own web-logbook instance and lets you browse, view, and create flight log entries from your iPhone.

## Requirements

- iOS 26.4+
- A running instance of [web-logbook](https://github.com/vsimakhin/web-logbook)

## Setup

1. Open `weblogbook-app.xcodeproj` in Xcode 26.4.1+
2. Copy `weblogbook-app/Config/Secrets.xcconfig.template` to `weblogbook-app/Config/Secrets.xcconfig` — this file is gitignored
3. Build and run on a simulator or device
4. Open **Settings** in the app, enter your web-logbook server URL and log in with your credentials

## Features

- Browse flight log entries with offline caching
- View full log detail (route, times, aircraft, landings, simulator)
- Create new log entries
- Persistent login via secure token storage (Keychain)
- Offline banner when viewing cached data

## To-do

- [ ] Edit existing log entries
- [ ] Delete log entries
- [ ] Totals view (total flight hours per category)
- [ ] Aircraft list
- [ ] Persons / crew list
- [ ] View flight track on map
- [ ] Attachments support
- [ ] Tags support
- [ ] Token expiry handling and automatic re-login

## Credits

Web-logbook backend by [vsimakhin](https://github.com/vsimakhin) — [github.com/vsimakhin/web-logbook](https://github.com/vsimakhin/web-logbook).
