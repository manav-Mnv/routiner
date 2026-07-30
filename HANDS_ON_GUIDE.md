# Hands-On Guide: Concept → Real Feature

This is the **format** to use for every lesson instead of teaching theory first: pick one Swift/SwiftUI concept, then build one real screen/feature in the actual app that needs that concept. Below is the worked example — **conditional statements, taught by building the Login page.**

Read this once yourself, then walk the student through it live, having THEM type the code (not you) and press the actual keys.

---

## Lesson 1 — Conditional Statements → the Login Page

### The concept: conditional statements (`if` / `else if` / `else`, `if let`)

Plain-language version to say out loud before touching Xcode:
> "A conditional statement lets code make a decision — 'if this is true, do A, otherwise do B.' We check things top to bottom, and stop at the first one that matches. A login form is a perfect real example: check for empty fields first, then a valid-looking email, then password length — and only if ALL of those pass, let the user in."

---

### Step 1 — Create the file in Xcode

1. In Xcode's left sidebar (the **Project Navigator**), click the `Onboarding` folder/group (inside `Views`) so the new file lands in the right place.
2. Press **⌘N** (Cmd + N) — or menu bar **File → New → File...**
3. In the template picker, under the **iOS** tab, choose **Swift UI View** (not "Swift File" — that template pre-fills the `View` boilerplate for you).
4. Name it exactly **`LoginView`** — Xcode adds the `.swift` automatically. File names should match the `struct` name inside them; this is a Swift convention, not a hard rule, but breaking it makes files hard to find later.
5. In the save dialog, confirm:
   - **Group:** `Views/Onboarding` (should already be selected since you clicked that folder in step 1)
   - **Targets:** the checkbox next to `HabitTracker` must be ✅ checked — if it's unchecked, the file exists on disk but Xcode won't compile it into the app, which is a very common "why isn't my code running" bug.
6. Click **Create**.

Xcode generates a starter file that already has `import SwiftUI` at the top and an empty `struct LoginView: View { ... }` — **every** SwiftUI file needs that import; it's what makes `View`, `Text`, `Button`, etc. available at all. Delete the placeholder `Text("Hello, World!")` before continuing.

---

### Step 2 — State: what does this screen need to remember?

Type this inside `struct LoginView: View`, above `var body: some View`:

```swift
@State private var email = ""
@State private var password = ""
@State private var errorMessage: String?
```

Explain each line as you type it:
- `@State` = "SwiftUI, please redraw this screen whenever this value changes."
- `email`/`password` start as empty strings — they'll fill in as the user types, via `TextField`/`SecureField` in Step 3.
- `errorMessage: String?` — the `?` makes this an **optional**. It means "this might have a value, or might have nothing (`nil`)." Most of the time there's no error, so it starts as `nil` implicitly.

---

### Step 3 — The form UI

```swift
var body: some View {
    VStack(alignment: .leading, spacing: 16) {
        Text("Sign In")
            .font(.largeTitle.bold())

        TextField("Email", text: $email)
            .textFieldStyle(.roundedBorder)

        SecureField("Password", text: $password)
            .textFieldStyle(.roundedBorder)

        if let errorMessage {
            Text(errorMessage)
                .foregroundColor(.red)
        }

        Button("Sign In") {
            handleSignIn()
        }
    }
    .padding(24)
}
```

Pause on `if let errorMessage { ... }` — **this is the conditional statement lesson landing in the UI itself.** Say it plainly:
> "This block only runs — meaning that red text only appears on screen — when `errorMessage` is NOT nil. No error means this whole chunk of UI doesn't exist. We never have to check for a crash; Swift forces us to prove there's a real value before we use it."

---

### Step 4 — The actual conditional logic

Below `body`, add the function the Button calls:

```swift
private func handleSignIn() {
    if email.isEmpty || password.isEmpty {
        errorMessage = "Please fill in both fields."
    } else if !email.contains("@") {
        errorMessage = "That doesn't look like a valid email."
    } else if password.count < 6 {
        errorMessage = "Password must be at least 6 characters."
    } else {
        errorMessage = nil
        // success — see Step 5 for what happens next
    }
}
```

Walk through it condition by condition, and have the student predict the output before running it:
- "What prints if I leave both fields blank and tap Sign In?" → first branch
- "What if I type `mert` with no `@` for email?" → second branch
- "What if email is fine but password is `abc`?" → third branch (`count < 6`)
- "What if everything's valid?" → falls all the way to `else`

This is the core teaching moment: **order matters**, and only one branch ever runs per tap.

---

### Step 5 — Make "success" actually do something

We have no backend, so there's nothing to really log into — but we can still make success feel real by unlocking the rest of the app. Add this property near the top of the struct:

```swift
@AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
```

Then in the `else` branch from Step 4:

```swift
} else {
    errorMessage = nil
    hasCompletedOnboarding = true
}
```

Explain: `@AppStorage` saves this flag to the device itself. `HabitTrackerApp.swift` (the app's entry point) checks this exact same flag to decide whether to show `OnboardingView` or the real app — so flipping it to `true` here is what "logs the user in."

---

### Step 6 — Wire it up to the button that opens this screen

Open `OnboardingView.swift`. Find the "Continue with E-mail" button. It needs a piece of `@State` to control whether `LoginView` is showing:

```swift
@State private var isShowingLogin = false
```

Change the button's action from directly setting the onboarding flag, to instead opening `LoginView`:

```swift
Button {
    isShowingLogin = true
} label: {
    Text("Continue with E-mail")
    // ...same styling as before
}
```

Then, on the outermost `ZStack` in that file, attach:

```swift
.fullScreenCover(isPresented: $isShowingLogin) {
    LoginView()
}
```

Explain `.fullScreenCover` vs `.sheet` here: a sheet leaves a sliver of the previous screen visible underneath (good for quick add-a-thing flows, like `AddHabitSheet`); `.fullScreenCover` takes over the whole screen — the right feel for a sign-in flow.

---

### Step 7 — Run it (⌘R)

Press **⌘R** (Cmd + R) to build and run in the Simulator.
- Tap through onboarding → **Continue with E-mail** → you land on the new Login screen.
- Try each failing case from Step 4's walkthrough and confirm the right red message shows.
- Enter something valid (any `name@anything.com` + 6+ character password) → the whole app should switch straight to the Home tab bar.

If it doesn't build, the two most common first-time mistakes are: (1) forgot to check the target checkbox in Step 1, or (2) a typo in the `@AppStorage` key string — it must be spelled **identically** (`"hasCompletedOnboarding"`) in every file that uses it, since that string is literally how the three files find the same saved value.

---

### Reference: the finished file

Once the student has built their own version and it runs, open the polished, fully-commented version already sitting at [LoginView.swift](HabitTracker/Views/Onboarding/LoginView.swift) side by side with theirs. Diff the two out loud — most differences will be cosmetic (styling, spacing), which is a good sign the core logic (the part that was actually being taught) matches.

---

## Lesson 2 — `for` Loops / `ForEach` → the Habit List on Home

### The concept: repeating UI for each item in a collection

Say out loud before touching Xcode:
> "We never want to hand-write 'card 1, card 2, card 3' — what if there are 20 habits, or 1? `ForEach` takes an array and a recipe for turning ONE item into a View, and repeats that recipe automatically for every item currently in the array."

### Step 1 — Create the row "recipe" file

1. Click the `Home` group inside `Views` in the sidebar.
2. **⌘N** → **iOS → SwiftUI View** → name it exactly **`HabitRowView`** → confirm Group is `Views/Home` and the `HabitTracker` target checkbox is ✅ → **Create**.

### Step 2 — One card, for one habit

```swift
struct HabitRowView: View {
    // This view doesn't own any data — it's just HANDED one Habit to draw.
    let habit: Habit

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: habit.icon)
                .frame(width: 44, height: 44)
                .background(Circle().fill(Color.blue.opacity(0.15)))

            VStack(alignment: .leading, spacing: 4) {
                Text(habit.title).font(.headline)
                Text(habit.subtitle).font(.caption).foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

#Preview {
    HabitRowView(habit: Habit.sampleData[0])
}
```

Press **⌥⌘Return** to open the Preview canvas and check the card looks right — for ONE habit. That's on purpose: get the single "recipe" correct before repeating it.

### Step 3 — The actual loop

Open `HomeView.swift` (or wherever the list lives) and add, inside a `ScrollView { VStack { ... } }`:

```swift
// `ForEach` IS the loop. For every Habit currently in `viewModel.habits`,
// it draws one HabitRowView. It knows how to tell habits apart because
// `Habit` conforms to `Identifiable` (that `id` property from the Model).
ForEach(viewModel.habits) { habit in
    HabitRowView(habit: habit)
}
```

Ask the student to predict: "If `viewModel.habits` has 3 items, how many `HabitRowView`s get drawn? What if it's empty?" (Answer: 3, and zero — `ForEach` over an empty array simply draws nothing, no crash, no special-casing needed.)

### Step 4 — Run it (⌘R)

Temporarily add a 4th sample habit to `Habit.sampleData` in `Habit.swift`, run, and confirm a 4th card appears with **zero changes to the loop code** — that's the whole payoff of `ForEach` over manually writing out each card.

### Reference: [HabitRowView.swift](HabitTracker/Views/Home/HabitRowView.swift), [HomeView.swift](HabitTracker/Views/Home/HomeView.swift)

---

## Lesson 3 — Closures as Callbacks → the Habit Checkbox

### The concept: a function you pass around like a value

Say out loud:
> "A closure is a chunk of code wrapped up so it can be handed to someone else to run later. `HabitRowView` will get handed a closure that says 'when the checkbox is tapped, run THIS' — but `HabitRowView` itself has no idea what that code actually does. That's what lets the same row work for any screen that uses it."

### Step 1 — Add a closure property

In `HabitRowView.swift` (built in Lesson 2), add a second property below `let habit: Habit`:

```swift
// `() -> Void` reads as "a function that takes no input and returns nothing."
// This is a CLOSURE type, not a value — the parent view decides what code
// actually runs here.
let onToggle: () -> Void
```

### Step 2 — Call it from a button

Inside `body`, after the `Spacer()`:

```swift
Button(action: onToggle) {
    Image(systemName: habit.isDoneToday ? "checkmark.circle.fill" : "plus.circle")
}
```

Point out: `HabitRowView` never writes `habit.isDoneToday = true` itself. It only ever *reports upward* that a tap happened — this keeps the row "dumb" and reusable, and keeps the real editing logic in one place (the ViewModel, Lesson 4's territory).

### Step 3 — Supply the closure at the call site

Back where `ForEach` is used (Lesson 2, Step 3), update it:

```swift
ForEach(viewModel.habits) { habit in
    HabitRowView(habit: habit) {
        // THIS is the closure — the actual code that runs on tap.
        // It's written here, at the call site, not inside HabitRowView.
        viewModel.toggleHabit(id: habit.id)
    }
}
```

(`viewModel.toggleHabit(id:)` is built in Lesson 4 — for now you can stub it as `print("tapped \(habit.title)")` and watch the Xcode console.)

### Step 4 — Run it and predict first

Before running, ask: "If I tap the second card's checkbox, which closure runs — does it know it was the SECOND one?" (Answer: yes — `ForEach` creates a fresh closure per loop iteration, each one capturing its own `habit`, so tapping card 2 only ever calls the closure built for card 2.)

### Reference: [HabitRowView.swift](HabitTracker/Views/Home/HabitRowView.swift) (see `onToggle`)

---

## Lesson 4 — Functions with Return Values → the Daily-Goal Ring

### The concept: a function that hands back an answer, and `class` state

Say out loud:
> "So far our functions just DID something. A function with a return type — like `-> Int` or `-> Double` — instead calculates and hands back an answer, which the caller can use however it wants. We'll use this to calculate 'what % of today's habits are done' from the raw habit list, instead of storing that percentage separately and risking it going out of sync."

### Step 1 — Create the ViewModel

1. Click the `ViewModels` group.
2. **⌘N** → **Swift File** (no UI here, so skip the SwiftUI template) → name it **`HabitListViewModel`** → Group `ViewModels` → **Create**.
3. Note it needs `import Foundation`, not `import SwiftUI` — this file has zero layout code in it, on purpose.

### Step 2 — The class and its stored state

```swift
import Foundation

// `ObservableObject` lets SwiftUI "watch" this class. `@Published` means
// "announce it to every screen watching me whenever this changes."
class HabitListViewModel: ObservableObject {
    @Published var habits: [Habit] = Habit.sampleData

    func toggleHabit(id: UUID) {
        guard let index = habits.firstIndex(where: { $0.id == id }) else { return }
        habits[index].toggleDoneToday()
    }
}
```

### Step 3 — A function that returns a value

Add this inside the class:

```swift
// No stored variable for "today's progress" — it's CALCULATED from
// `habits` every time it's asked for, so it can never drift out of sync
// with the real data (there's nothing to forget to update).
func progressPercent() -> Double {
    guard !habits.isEmpty else { return 0 }
    let completed = habits.filter { $0.isDoneToday }.count
    return Double(completed) / Double(habits.count)
}
```

Walk through the return type out loud: `-> Double` in the function signature is a promise — "whoever calls this WILL get a `Double` back." `guard ... else { return 0 }` is the earlier conditionals lesson reappearing: bail out with a safe default before dividing by zero on an empty array.

### Step 4 — Use the returned value in a View

```swift
Text("\(Int(viewModel.progressPercent() * 100))% done")
```

Ask the student to predict the output for: 0 habits, 4 habits with 1 done, 4 habits with all 4 done. Then actually toggle habits in the running app and watch the number update live — because it's recalculated fresh on every redraw, not cached.

### Reference: [HabitListViewModel.swift](HabitTracker/ViewModels/HabitListViewModel.swift) (see `progressPercent`)

---

## Lesson 5 — Enums → the Profile Tab Switcher

### The concept: a fixed, named set of options

Say out loud:
> "The Profile screen has exactly 3 tabs: Activity, Friends, Achievements — never a 4th, never a typo like 'Frends'. If we tracked the selected tab as a plain String, nothing would stop a typo from compiling. An `enum` lists the valid options by name — the compiler itself refuses to let an invalid one exist."

### Step 1 — Define the enum

Inside `ProfileView.swift` (or wherever the tab switcher lives), above `body`:

```swift
// A fixed list of named cases. `CaseIterable` gives us `.allCases` for free,
// which is what lets us loop over "every tab" without listing them twice.
private enum Tab: String, CaseIterable {
    case activity = "Activity"
    case friends = "Friends"
    case achievements = "Achievements"
}
@State private var selectedTab: Tab = .activity
```

### Step 2 — Loop over the cases to draw the pills

```swift
HStack {
    ForEach(Tab.allCases, id: \.self) { tab in
        Text(tab.rawValue)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(selectedTab == tab ? Color.blue : .clear)
            .onTapGesture { selectedTab = tab }
    }
}
```

Point out: this combines Lesson 2's `ForEach` with the new enum — add a 4th case to `Tab` later and a 4th pill appears automatically, still with zero loop changes.

### Step 3 — `switch` on the enum to show different content

```swift
switch selectedTab {
case .activity:
    Text("Activity feed here")
case .friends:
    Text("Friends list here")
case .achievements:
    Text("Achievements here")
}
```

Have the student try deleting one `case` from this `switch` and read the compiler error — Swift requires every enum case to be handled (or an explicit `default:`), which is the enum's real safety payoff.

### Reference: [ProfileView.swift](HabitTracker/Views/Profile/ProfileView.swift) (see `private enum Tab`)

---

## Lesson 6 — `@Binding` → the Calendar Strip's Selected Date

### The concept: a two-way pipe back to the parent's `@State`

Say out loud:
> "`@State` means 'I own this value.' But `CalendarStripView` shouldn't own 'which day is selected' — `HomeView` does, since other parts of Home might care too. `@Binding` lets a child view read AND write a value it doesn't actually own, through a live connection back to the parent."

### Step 1 — Create the child view

**⌘N** → **SwiftUI View** → `CalendarStripView` → Group `Views/Home` → Create.

```swift
struct CalendarStripView: View {
    // NOT @State — this view doesn't own the selected date, it BORROWS
    // read/write access to the parent's own @State via a binding.
    @Binding var selectedDate: Date

    var body: some View {
        HStack {
            ForEach(0..<5) { offset in
                let date = Calendar.current.date(byAdding: .day, value: offset, to: Date())!
                Text(date.formatted(.dateTime.day()))
                    .padding()
                    .background(Calendar.current.isDate(date, inSameDayAs: selectedDate) ? Color.blue.opacity(0.2) : .clear)
                    .onTapGesture { selectedDate = date } // writing back through the binding
            }
        }
    }
}
```

### Step 2 — Connect it from the parent

In `HomeView.swift`:

```swift
@State private var selectedDate = Date()
// ...
CalendarStripView(selectedDate: $selectedDate)
```

The `$` is what turns a plain `@State` value into a binding when passed down — say this explicitly, it's the single most-forgotten symbol for beginners.

### Step 3 — Predict, then verify

Ask: "If I tap a day inside `CalendarStripView`, does `HomeView`'s `selectedDate` change too, or just the child's local copy?" Run it and add a `Text(selectedDate.formatted())` somewhere else in `HomeView` to prove it updates in both places at once — because there's only ever ONE actual value, just two views looking at it.

### Reference: [CalendarStripView.swift](HabitTracker/Views/Home/CalendarStripView.swift)

---

## Lesson 7 — Arrays & `.append()` → Adding a Custom Habit

### The concept: growing a collection at runtime

Say out loud:
> "Every habit on screen so far came from data that existed before the app even launched. Now we let the USER add to that array while the app is running — `.append()` is how you add one more item to the end of an array you already have."

### Step 1 — Add the function

In `HabitListViewModel.swift` (from Lesson 4):

```swift
func addCustomHabit(title: String) {
    // Guard against an empty/whitespace-only title BEFORE it ever reaches
    // the array — this is Lesson 1's conditional-validation idea again,
    // just protecting an array instead of a login form.
    guard !title.trimmingCharacters(in: .whitespaces).isEmpty else { return }

    let newHabit = Habit(title: title, subtitle: "0/1 TIMES", icon: "star.fill",
                          tintColorName: "blue", streak: 0, isDoneToday: false)
    habits.append(newHabit) // grows the array by exactly one
}
```

Because `habits` is `@Published`, appending to it fires SwiftUI's redraw — the new card appears with no extra code.

### Step 2 — Call it from a simple form

```swift
@State private var newTitle = ""
// ...
TextField("Habit name", text: $newTitle)
Button("Add") {
    viewModel.addCustomHabit(title: newTitle)
    newTitle = "" // reset the field for the next entry
}
```

### Step 3 — Predict, then run

Ask: "If I tap Add with an empty text field, does a blank card appear?" (No — the `guard` in Step 1 returns before `.append()` ever runs.) Then type a real title, tap Add, and watch `ForEach` (Lesson 2) automatically draw a new row for the newly-appended item.

### Reference: [HabitListViewModel.swift](HabitTracker/ViewModels/HabitListViewModel.swift) (see `addCustomHabit`), [AddHabitSheet.swift](HabitTracker/Views/Home/AddHabitSheet.swift)

---

## Reusing this format for the next concept

Every future lesson should follow this same shape:

1. **Pick a concept** (structs vs classes, optionals, `TabView`, `NavigationStack`, `.sheet`, `@AppStorage`, etc.)
2. **Pick a real, small feature in the app that needs it** — don't invent a toy example if a real screen already needs the concept
3. **Step 1:** Cmd+N in Xcode, exact template, exact file name, exact folder/group, confirm target checkbox
4. **Step by step:** build the feature, pausing at the line(s) where the day's concept actually appears, and ask the student to predict behavior before running
5. **Cmd+R:** run it for real, try the edge cases together
6. **Compare** against the finished reference file in `HabitTracker/`

Concepts not yet covered this way, for when you're ready to keep going: `struct` vs `class` + optionals (see `Habit.swift`), `.sheet` + `NavigationStack` (see `AddHabitSheet.swift` / `SettingsView.swift`), `TabView` + `@main` + `@AppStorage` persistence (see `RootTabView.swift` / `HabitTrackerApp.swift`). [TEACHING_PLAN.md](TEACHING_PLAN.md) has a week-by-week schedule covering these if you want the slower, lecture-plus-exercise version instead of straight into the next hands-on lesson.
