import SwiftUI

// MARK: - What is this file?
// The screen that slides up from the bottom (a "sheet") when the user taps
// the big "+" tab, matching the "New Good Habit" card in the Figma design.
// It offers a few ready-made presets, or a text field to create a custom one.

struct AddHabitSheet: View {
    // The ViewModel that actually owns the habits array. This sheet doesn't
    // keep its own copy of the data — it just calls functions on the same
    // shared ViewModel that HomeView is watching, so adding a habit here
    // instantly shows up in the Home list too.
    @ObservedObject var viewModel: HabitListViewModel

    // dismiss lets this View close itself, e.g. after successfully adding
    // a custom habit. It's provided automatically by SwiftUI's environment.
    @Environment(\.dismiss) private var dismiss

    @State private var customTitle = ""

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Popular Habits")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.secondaryText)

                // A horizontal row of preset cards, e.g. Walk / Swim / Read.
                HStack(spacing: 12) {
                    ForEach(Habit.popularPresets) { preset in
                        presetCard(preset)
                    }
                }

                Divider().padding(.vertical, 8)

                Text("Or create your own")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.secondaryText)

                HStack {
                    TextField("Habit name", text: $customTitle)
                        .textFieldStyle(.roundedBorder)

                    Button("Add") {
                        viewModel.addCustomHabit(title: customTitle)
                        dismiss() // close the sheet once the habit is added
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(AppTheme.primary)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("New Good Habit")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // One tappable preset card. Tapping it adds the habit immediately and
    // closes the sheet — no extra typing needed for the quick-add path.
    @ViewBuilder
    private func presetCard(_ preset: Habit) -> some View {
        Button {
            viewModel.addPreset(preset)
            dismiss()
        } label: {
            VStack(spacing: 8) {
                Image(systemName: preset.icon)
                    .font(.title2)
                Text(preset.title)
                    .font(.caption).bold()
                Text(preset.subtitle)
                    .font(.caption2)
                    .foregroundColor(AppTheme.secondaryText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(16)
            .foregroundColor(.primary)
        }
    }
}

#Preview {
    AddHabitSheet(viewModel: HabitListViewModel())
}
