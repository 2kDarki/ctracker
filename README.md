# Change Tracker

Change Tracker is a lightweight, offline-first mobile app built for tuckshops and small businesses to record and manage customer change owed.

When exact change isn’t available, businesses often write it down in a book — which is slow, unreliable, and hard to search. Change Tracker replaces that with a fast, simple digital ledger.

> No accounts. No cloud. No bloat. Just what’s needed.

---

## Problem It Solves

In many small retail environments:

- Exact change is frequently unavailable
- Change owed is written in notebooks
- Finding old entries is slow or impossible
- Records are forgotten or lost
- Disputes happen due to missing proof

Change Tracker provides a structured, searchable, digital alternative.

---

## Core Features

- Record customer name, change amount, and timestamp
- Instantly search and filter outstanding change
- Mark records as Paid
- Automatic cleanup: paid records deleted after 30 days
- Fully offline — no internet required
- Minimal UI optimized for speed

---

## Design Philosophy

Change Tracker is intentionally simple:
- No transaction history
- No notes
- No accounts
- No sync
- No cloud

Each record contains only:
- Customer name
- Change amount
- Timestamp
- Paid status

> This keeps the app fast, focused, and resistant to data bloat.

---

## Tech Stack

Framework: Flutter
Platform: Android
Storage: Local (offline)
Architecture: Lightweight local state + persistence
Network: None (offline-first by design)

---

## Installation

APK (Recommended for End Users)

1. Download the latest apk from the Releases page, or download from Orion Store
2. Enable Install from Unknown Sources on your Android device
3. Install and run

---

## Development Setup

```bash
git clone https://github.com/<your-username>/change-tracker.git
cd change-tracker
flutter pub get
flutter run
```

---

## Data Retention Logic

- Unpaid records remain until marked as paid
- Paid records are automatically deleted after 30 days

> This prevents long-term data bloat and keeps the app lightweight

---

## Intended Users

1. Tuckshops
2. Small retailers
3. Informal shops
4. Any business that regularly runs out of small change

---

## Why This Exists

This app is built for real-world retail conditions — not theoretical POS systems.

It prioritizes:
1. Speed
2. Simplicity
3. Reliability

> Zero dependency on internet or accounts

---

## Roadmap

1. UI polish
2. Optional export (CSV)
3. Optional PIN lock for privacy

---

## License

MIT License
