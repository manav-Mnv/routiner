# Teaching Plan — Swift & SwiftUI via the HabitTracker App

**Format:** Weekly, every Thursday, 10:00 AM – 4:00 PM (6 hrs/session, includes breaks + lunch)
**Student profile:** Comfortable programming already (another language) — never touched Swift or SwiftUI.
**Method:** Each week, the student builds a *simplified version* of one part of the app themselves during the hands-on block, then you compare it against the real, fully-commented file in `HabitTracker/` as the "answer key" / reference implementation. By Week 6 they've effectively rebuilt the whole app with understanding, not copy-pasting.

**Requirement:** A Mac with Xcode installed (free from the Mac App Store) — SwiftUI cannot run on Windows. Get this sorted *before* Week 1 if possible.

---

## Overview

| Week | Topic | Builds Toward |
|---|---|---|
| 1 | Swift language fundamentals + Xcode setup | — (Playground exercises) |
| 2 | SwiftUI basics: views, modifiers, `@State` | A standalone practice screen |
| 3 | MVVM & data flow: Models, ViewModels, lists | `Habit.swift`, `HabitListViewModel.swift`, `HabitRowView.swift` |
| 4 | Composing a full screen + reusable components + theming | `HomeView.swift`, `CalendarStripView.swift`, `AppTheme.swift` |
| 5 | Sheets, forms, navigation | `AddHabitSheet.swift`, `ProfileView.swift`, `SettingsView.swift` |
| 6 | Tabs, app entry, persistence, capstone review | `RootTabView.swift`, `OnboardingView.swift`, `HabitTrackerApp.swift` |

---

## Week 1 — Swift Language Fundamentals + Setup

**Goal:** Get comfortable with Swift's syntax and its two biggest departures from most other languages: **optionals** and **structs-as-value-types**.

**Schedule**
- 10:00–10:30 — Install/verify Xcode, create a blank "Playground" file (a scratchpad for running Swift without building a full app)
- 10:30–12:00 — Core syntax: `let` vs `var`, type inference, functions, closures, control flow (`if`/`switch`/`for`), collections (`Array`, `Dictionary`)
- 12:00–12:15 — Break
- 12:15–1:00 — Optionals (`String?`, `if let`, `guard let`, `??`) — frame this explicitly as "Swift's answer to null/None, but the compiler forces you to handle the missing case"
- 1:00–1:45 — Lunch
- 1:45–2:45 — `struct` vs `class`: value types vs reference types (this trips up everyone coming from Python/JS/Java, where almost everything is a reference type) — use `Habit` from `Habit.swift` as the live example
- 2:45–3:00 — Break
- 3:00–3:45 — Protocols as "contracts" (`Identifiable`, `Equatable`) — conceptually compare to interfaces in Java/TS if that's the student's background
- 3:45–4:00 — Checkpoint (see below)

**Concepts to teach**
- Type inference & strong typing
- Optionals: `?`, `!`, `if let`, `guard let`, `??`
- `struct` (value type, copied on assignment) vs `class` (reference type, shared)
- Functions, closures (`{ }` syntax), trailing closure syntax
- Protocols (`Identifiable`, `CaseIterable`) as a Swift take on interfaces
- `enum` as a safer alternative to raw strings/ints for fixed option sets

**Reference file:** [Habit.swift](HabitTracker/Models/Habit.swift) — point out `struct`, `mutating func`, and `Identifiable` conformance, but don't build the full app logic yet.

**Hands-on exercise:** In a Playground, have the student define their own `struct` (e.g. `Book` with `title`, `author`, `isRead`), write a `mutating func markAsRead()`, make it conform to `Identifiable`, and create an array of 3 sample books. No UI yet — just data modeling.

**Checkpoint (before moving to Week 2):** Can they explain, in their own words, why editing a `struct` inside a function without `mutating` fails to compile? Can they explain the difference between `if let` and `guard let`?

---

## Week 2 — SwiftUI Basics: Views, Modifiers, State

**Goal:** Understand that SwiftUI views are just functions of state — "describe what the screen looks like for the current data, and let the framework redraw it."

**Schedule**
- 10:00–11:00 — The `View` protocol, `body`, basic views: `Text`, `Image`, `Button`
- 11:00–11:15 — Break
- 11:15–12:30 — Layout: `VStack`/`HStack`/`ZStack`, `Spacer`, modifiers (`.padding()`, `.background()`, `.cornerRadius()`) and **modifier order matters** — demo this live, it's a classic gotcha
- 12:30–1:15 — Lunch
- 1:15–2:15 — `@State` and why it triggers re-renders; build a simple counter app from scratch together
- 2:15–2:30 — Break
- 2:30–3:45 — Hands-on exercise (below)
- 3:45–4:00 — Checkpoint

**Concepts to teach**
- Declarative UI mindset (SwiftUI) vs imperative UI (if they've done UIKit/Android View/DOM manipulation before, contrast explicitly)
- `View` protocol + `some View` return type
- Stack layouts, `Spacer()`, alignment
- Modifier chaining and order-sensitivity
- `@State` for local, view-owned data
- `#Preview` — Xcode's live preview canvas, so they don't need the simulator for every tweak

**Reference file:** [HabitRowView.swift](HabitTracker/Views/Home/HabitRowView.swift) — good example of `HStack`, `VStack`, modifiers, and a `#Preview` block, without any ViewModel complexity yet.

**Hands-on exercise:** Build a standalone "profile card" view from scratch: circular avatar placeholder, name, a `Button` that toggles between "Follow" / "Following" text using local `@State`. No Model/ViewModel — just a View and `@State`.

**Checkpoint:** Can they explain why a `Text` doesn't update on screen if the variable behind it isn't marked `@State`? Can they read/predict layout from a stack of `VStack { HStack { ... } }`?

---

## Week 3 — MVVM & Data Flow: Models, ViewModels, Lists

**Goal:** Learn *why* MVVM exists (separating data/logic from layout) and the SwiftUI property wrappers that wire it together.

**Schedule**
- 10:00–10:45 — What is MVVM and why bother? (Model = data, ViewModel = state + logic, View = layout only) — whiteboard the triangle before writing code
- 10:45–11:45 — `ObservableObject`, `@Published`, `@StateObject` vs `@ObservedObject` — this distinction (who *owns* vs who *borrows* the object) is the #1 point of confusion, spend real time here
- 11:45–12:00 — Break
- 12:00–1:00 — `List`/`ForEach`, `Identifiable` in practice, closures passed into child views as callbacks (the "child reports up, doesn't mutate directly" pattern)
- 1:00–1:45 — Lunch
- 1:45–3:15 — Hands-on exercise (below)
- 3:15–3:45 — Walk through [HabitListViewModel.swift](HabitTracker/ViewModels/HabitListViewModel.swift) and [HabitRowView.swift](HabitTracker/Views/Home/HabitRowView.swift) together line-by-line, comparing to what they just built
- 3:45–4:00 — Checkpoint

**Concepts to teach**
- Model vs ViewModel vs View responsibilities
- `ObservableObject` + `@Published`
- `@StateObject` (I own this) vs `@ObservedObject` (someone handed this to me)
- Passing closures down instead of letting a child View mutate a parent's data directly
- `ForEach` over an `Identifiable` array

**Reference files:** [Habit.swift](HabitTracker/Models/Habit.swift), [HabitListViewModel.swift](HabitTracker/ViewModels/HabitListViewModel.swift), [HabitRowView.swift](HabitTracker/Views/Home/HabitRowView.swift)

**Hands-on exercise:** From the `Book` struct built in Week 1, build: a `BookListViewModel: ObservableObject` with a `@Published var books` array and a `toggleRead(id:)` function, a `BookRowView` (View), and a screen that lists them with `ForEach`, tapping a row toggles read/unread. This is structurally identical to the real Habit list — that's the point.

**Checkpoint:** Can they explain, without looking, why the row View calls a closure instead of just setting `book.isRead = true` itself? Can they say what breaks if `@StateObject` is swapped for `@ObservedObject` at the screen's top level?

---

## Week 4 — Composing a Full Screen + Reusable Components + Theming

**Goal:** Go from "one list" to a real, multi-section screen, and learn to break big screens into small named pieces.

**Schedule**
- 10:00–11:00 — `ScrollView`, computed properties inside a View (breaking `body` into named chunks like `private var header: some View`)
- 11:00–11:15 — Break
- 11:15–12:15 — Building small reusable subviews (`CalendarStripView`) that take a `@Binding` — explain `@Binding` as "a two-way pipe back to the parent's `@State`"
- 12:15–1:00 — Lunch
- 1:00–2:00 — A theme/design-tokens file (`AppTheme.swift`), `Color(hex:)` extension, `LinearGradient`, why centralizing colors matters
- 2:00–2:15 — Break
- 2:15–3:30 — Hands-on: assemble the student's own list + header + a small custom "date strip" component into one full screen
- 3:30–4:00 — Compare against [HomeView.swift](HabitTracker/Views/Home/HomeView.swift) + [CalendarStripView.swift](HabitTracker/Views/Home/CalendarStripView.swift), checkpoint

**Concepts to teach**
- `ScrollView` vs `List` (when to use which)
- Splitting `body` into computed properties for readability
- `@Binding` and the `$` prefix
- Extending built-in types (`extension Color { init(hex:) }`)
- `LinearGradient`, `ZStack` for layered effects (progress rings)
- Centralizing colors/spacing instead of hardcoding everywhere

**Reference files:** [HomeView.swift](HabitTracker/Views/Home/HomeView.swift), [CalendarStripView.swift](HabitTracker/Views/Home/CalendarStripView.swift), [AppTheme.swift](HabitTracker/Theme/AppTheme.swift)

**Hands-on exercise:** Add a horizontally-scrolling "filter chip" row (e.g. genre filters: All/Fiction/Nonfiction) above the book list from Week 3, built as its own `FilterStripView` taking a `@Binding<String> selectedFilter` — mirrors `CalendarStripView` exactly.

**Checkpoint:** Can they explain what would happen (and why) if `CalendarStripView` used `@State` instead of `@Binding` for `selectedDate`? Can they point to where in `AppTheme.swift` they'd change one color to re-theme the entire app?

---

## Week 5 — Sheets, Forms, and Navigation

**Goal:** Learn the main ways screens present other screens: pushing (`NavigationLink`) and presenting (`.sheet`), plus basic form input.

**Schedule**
- 10:00–11:00 — `NavigationStack` + `NavigationLink`, `.navigationTitle`, toolbar items
- 11:00–11:15 — Break
- 11:15–12:15 — `.sheet(isPresented:)`, `@Environment(\.dismiss)`, `TextField` + `@State` two-way binding for form input
- 12:15–1:00 — Lunch
- 1:00–2:00 — Passing a *shared* ViewModel into a sheet (`@ObservedObject` again) so data added in the sheet shows up on the screen behind it — this is the "aha" moment tying Week 3's concept back in
- 2:00–2:15 — Break
- 2:15–3:30 — Hands-on: build an "Add Book" sheet + a simple "Book Detail" pushed screen
- 3:30–4:00 — Compare against [AddHabitSheet.swift](HabitTracker/Views/Home/AddHabitSheet.swift), [ProfileView.swift](HabitTracker/Views/Profile/ProfileView.swift), [SettingsView.swift](HabitTracker/Views/Settings/SettingsView.swift); checkpoint

**Concepts to teach**
- `NavigationStack` / `NavigationLink` (pushing)
- `.sheet` (modal presenting) and dismissing it programmatically
- `TextField` + form-style input, `Toggle`
- Sharing one ViewModel instance across multiple screens instead of duplicating state
- `enum`-driven segmented tab switching (as in `ProfileView`'s Activity/Friends/Achievements pills)

**Reference files:** [AddHabitSheet.swift](HabitTracker/Views/Home/AddHabitSheet.swift), [ProfileView.swift](HabitTracker/Views/Profile/ProfileView.swift), [SettingsView.swift](HabitTracker/Views/Settings/SettingsView.swift)

**Hands-on exercise:** Add an "Add Book" `+` button that opens a sheet with a `TextField` for the title and an "Add" button that appends to the *same* `BookListViewModel` and dismisses. Then add a `NavigationLink` from each row to a simple detail screen showing the book's info.

**Checkpoint:** Can they explain why the sheet needs `@ObservedObject var viewModel: BookListViewModel` (passed in) rather than creating its own `@StateObject`? What would go wrong if it created its own?

---

## Week 6 — Tabs, App Entry, Persistence, Capstone Review

**Goal:** Tie everything together: the app's entry point, a tab bar shell, and simple on-device persistence — then review the whole app end to end.

**Schedule**
- 10:00–11:00 — `TabView`, `.tabItem`, handling a "fake" tab (the center `+` button pattern from `RootTabView`)
- 11:00–11:15 — Break
- 11:15–12:15 — `@main`, the `App` protocol, `WindowGroup`, and conditionally showing one root view vs another
- 12:15–1:00 — Lunch
- 1:00–2:00 — `@AppStorage` for lightweight persistence (onboarding-seen flag, settings toggles) — explain this is UserDefaults under the hood, and where you'd reach for `SwiftData`/Core Data instead if the data got more complex (i.e., the actual habits list, if this were shipping for real)
- 2:00–2:15 — Break
- 2:15–3:15 — Hands-on: wire the student's Book app into a `TabView` + onboarding flow using `@AppStorage`
- 3:15–4:00 — **Capstone walkthrough:** open the full `HabitTracker/` project together, trace one complete user action from tap to screen update across all the MVVM layers (e.g. "user taps a habit's checkbox" → `HabitRowView` → closure → `HabitListViewModel.toggleHabit` → `@Published` fires → `HomeView` redraws). Q&A, wrap-up, discuss stretch goals below.

**Concepts to teach**
- `TabView` + `.tabItem`
- `@main` / `App` protocol / `Scene` / `WindowGroup`
- Conditional root view switching based on persisted state
- `@AppStorage` and when it's (not) enough — contrast with a real database for larger datasets

**Reference files:** [RootTabView.swift](HabitTracker/Views/Root/RootTabView.swift), [OnboardingView.swift](HabitTracker/Views/Onboarding/OnboardingView.swift), [HabitTrackerApp.swift](HabitTracker/App/HabitTrackerApp.swift), [SettingsView.swift](HabitTracker/Views/Settings/SettingsView.swift)

**Hands-on exercise:** Wrap the Book app's list + detail screens in a `TabView` with a second placeholder tab, add a one-time onboarding screen gated by `@AppStorage`, and add one real settings toggle.

**Checkpoint / graduation criteria:** Student can, unaided, add a brand-new feature to `HabitTracker` following the existing pattern (e.g., a "delete habit" swipe action) — Model needs no change, ViewModel gets a new function, View calls it. If they can do this without you pointing to a specific file, the MVVM pattern has actually stuck.

---

## Stretch goals (only if time allows / a Week 7 gets added)

- Swap `@AppStorage` for `SwiftData` so the habit list itself survives app restarts
- Build out the "Friends" and "Achievements" placeholder tabs in `ProfileView.swift`, following the exact same Model → ViewModel → View pattern as Activity
- Local notifications (`UserNotifications`) for habit reminders
- Basic unit tests on `HabitListViewModel` (this is where separating logic from the View really pays off — it's testable without launching the UI at all)

## Notes for the teacher

- Every file in `HabitTracker/` already has "why", not just "what", comments — use them as the answer key, but resist showing the file until *after* the student has attempted the exercise. Struggling first is where the learning happens.
- If a session runs long on one topic, Weeks 4–5 are the safest to compress (they build on 2–3 already, less new conceptual ground) — don't compress Week 3, it's the conceptual foundation everything else depends on.
- If the student stalls on optionals or value-vs-reference-types in Week 1, don't move on — those two misunderstandings cause 90% of confusing bugs in every later week.
