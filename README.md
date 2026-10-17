<div align="center">

# Routiner: HabitTracker

**A SwiftUI habit tracker built as a 6-week teaching course for learning Swift by building a real app.**

![Status](https://img.shields.io/badge/status-learning%20project-6e7781?style=flat-square)
![Swift](https://img.shields.io/badge/Swift-F05138?style=flat-square&logo=swift&logoColor=white)
![SwiftUI](https://img.shields.io/badge/SwiftUI-0A84FF?style=flat-square&logo=swift&logoColor=white)
![MVVM](https://img.shields.io/badge/architecture-MVVM-555?style=flat-square)

</div>

---

## About

HabitTracker recreates the *Routiner* habit-tracker design in SwiftUI. Every file is heavily commented, so it works as the answer key for a teaching plan: each week the student builds a simplified version of one part of the app, then compares it with the real file.

The app is frontend-only on purpose (no backend), so the lessons stay focused on Swift and SwiftUI.

## Features

- Three-page onboarding with a gradient background, shown only once (`@AppStorage`)
- Sign-in screen with step-by-step form validation (the worked example for teaching conditionals)
- Home screen with a week calendar strip, a daily-goal progress banner and a checkable habit list
- Add-habit sheet
- Profile with an Activity / Friends / Achievements switcher and an activity feed
- Settings screen, tab navigation and a shared colour theme

## Teaching material

| File | What it is |
| --- | --- |
| [`TEACHING_PLAN.md`](TEACHING_PLAN.md) | Six weekly 6-hour sessions, from Swift fundamentals to a full capstone review, with checkpoints and exercises |
| [`HANDS_ON_GUIDE.md`](HANDS_ON_GUIDE.md) | The lesson format: one concept, one real feature. Worked example: conditional statements, taught by building the login page |

| Week | Topic | Builds toward |
| --- | --- | --- |
| 1 | Swift fundamentals and Xcode setup | Playground exercises |
| 2 | SwiftUI basics: views, modifiers, `@State` | A practice screen |
| 3 | MVVM and data flow | `Habit`, `HabitListViewModel`, `HabitRowView` |
| 4 | Composing screens, reusable components, theming | `HomeView`, `CalendarStripView`, `AppTheme` |
| 5 | Sheets, forms, navigation | `AddHabitSheet`, `ProfileView`, `SettingsView` |
| 6 | Tabs, app entry, persistence, capstone | `RootTabView`, `OnboardingView`, `HabitTrackerApp` |

## Getting started

The repo holds the source files only (no `.xcodeproj`).

1. In Xcode, create a new **iOS App** project named `HabitTracker` (Interface: SwiftUI).
2. Delete the generated `ContentView.swift` and app file.
3. Drag the `HabitTracker/` folder into the project and tick **Copy items if needed** and the `HabitTracker` target.
4. Build and run on an iPhone simulator.

## Project structure

```
HabitTracker/
├── App/          HabitTrackerApp (entry point, onboarding gate)
├── Models/       Habit, ActivityItem
├── ViewModels/   HabitListViewModel, ProfileViewModel
├── Theme/        AppTheme + Color(hex:)
└── Views/        Onboarding · Home · Profile · Settings · Root · Shared
```

## Author

Built by **[Manav](https://github.com/manav-Mnv)**.
