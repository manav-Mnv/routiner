import SwiftUI

// MARK: - What is this file?
// Draws ONE habit card/row (like one "Drink the water" card in the Figma
// design). Splitting it out of HomeView keeps that file short and lets us
// reuse this exact row anywhere else in the app later.

struct HabitRowView: View {

    // The data this row needs to draw itself. It does NOT own this data —
    // it's just handed a Habit to display ("passed in" from the parent view).
    let habit: Habit

    // A closure (a small chunk of code passed around like a value) that runs
    // when the user taps the checkbox. The parent view decides what actually
    // happens (it will call the ViewModel) — this row just reports "I was tapped".
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 12) { // HStack = lay children out left-to-right

            // Icon in a soft colored circle, matching the Figma cards.
            Image(systemName: habit.icon)
                .foregroundColor(tintColor)
                .frame(width: 44, height: 44)
                .background(Circle().fill(tintColor.opacity(0.15)))

            // VStack = lay children out top-to-bottom.
            VStack(alignment: .leading, spacing: 4) {
                Text(habit.title)
                    .font(.headline)

                Text(habit.subtitle)
                    .font(.caption)
                    .foregroundColor(AppTheme.secondaryText)
            }

            Spacer() // pushes everything after it to the far right

            // Tapping this button calls the closure passed in from the parent.
            // This row NEVER edits `habit` itself — it just asks the parent to.
            Button(action: onToggle) {
                Image(systemName: habit.isDoneToday ? "checkmark.circle.fill" : "plus.circle")
                    .font(.title2)
                    .foregroundColor(habit.isDoneToday ? .green : AppTheme.primary)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }

    // The Model only stores a color NAME ("blue", "purple"...), on purpose —
    // see the comment in Habit.swift. This is where that name finally turns
    // into an actual SwiftUI `Color`, right at the point it's drawn.
    private var tintColor: Color {
        switch habit.tintColorName {
        case "blue": return .blue
        case "purple": return .purple
        case "green": return .green
        case "orange": return .orange
        default: return AppTheme.primary
        }
    }
}

// MARK: - Preview
// This lets Xcode show a live mini-preview of JUST this row, without
// running the whole app — handy while designing a single piece of UI.
#Preview {
    HabitRowView(habit: Habit.sampleData[0], onToggle: {})
        .padding()
}
