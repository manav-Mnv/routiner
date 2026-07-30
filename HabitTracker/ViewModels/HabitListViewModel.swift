import Foundation

// MARK: - What is this file?
// This is the "VM" in MVVM — the ViewModel for the Home screen.
// Its job: hold the app's state (the list of habits) and the LOGIC for
// changing that state (toggle done, add a habit). The View (HomeView) just
// calls these functions and displays whatever this class gives it.
//
// Why bother separating this from the View at all?
// - The View file stays small and just describes layout (easy to read).
// - This class can be tested on its own, without launching any UI.
// - If tomorrow you swap SwiftUI for something else, this logic still works.

// `ObservableObject` is a protocol that lets SwiftUI "watch" this class.
// Whenever a `@Published` property below changes, every View that's
// watching this object automatically redraws itself. That's the magic glue
// between ViewModel and View in SwiftUI.
class HabitListViewModel: ObservableObject {

    // @Published = "announce it to SwiftUI whenever this changes".
    // Start with our sample habits from the Model file so the list isn't empty.
    @Published var habits: [Habit] = Habit.sampleData

    // A "computed property" — it has no storage of its own, it just
    // calculates a value on demand from `habits`. This feeds the
    // "Your daily goals almost done! 1 of 4 completed" banner on Home.
    var completedCount: Int {
        habits.filter { $0.isDoneToday }.count
    }

    var progressPercent: Double {
        guard !habits.isEmpty else { return 0 }
        return Double(completedCount) / Double(habits.count)
    }

    // Called when the user taps a habit row's checkbox.
    // We take the habit's `id` (not the habit itself) because arrays don't
    // let us edit a copy in place — we have to find the real one by id first.
    func toggleHabit(id: UUID) {
        // firstIndex(where:) scans the array and returns the position (Int)
        // of the first item whose id matches. `guard let` safely unwraps
        // that position, or exits the function early if none was found.
        guard let index = habits.firstIndex(where: { $0.id == id }) else { return }

        habits[index].toggleDoneToday() // reuse the logic we wrote on Habit itself
    }

    // Called when the user taps one of the "Popular Habits" preset cards.
    func addPreset(_ preset: Habit) {
        // Give it a fresh id/streak so it behaves like a brand-new habit,
        // instead of literally reusing the preset's own id.
        let newHabit = Habit(title: preset.title, subtitle: preset.subtitle, icon: preset.icon,
                              tintColorName: preset.tintColorName, streak: 0, isDoneToday: false)
        habits.append(newHabit)
    }

    // Called when the user types a name and taps "Create Custom Habit".
    func addCustomHabit(title: String) {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        let newHabit = Habit(title: title, subtitle: "0/1 TIMES", icon: "star.fill",
                              tintColorName: "blue", streak: 0, isDoneToday: false)
        habits.append(newHabit)
    }
}
