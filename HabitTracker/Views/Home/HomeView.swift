import SwiftUI

// MARK: - What is this file?
// The main screen — the "Hi, Mert" screen with the calendar strip, the
// daily-goal progress banner, and the habit list. This file should mostly
// describe LAYOUT ("what goes where"); the actual logic (toggling habits,
// calculating progress) lives in HabitListViewModel, which this screen just
// displays.

struct HomeView: View {

    // @StateObject creates and owns ONE instance of the ViewModel for as
    // long as this screen exists. (Use @StateObject when YOU create the
    // object; use @ObservedObject — as AddHabitSheet does — when it's
    // handed to you from elsewhere.)
    @StateObject private var viewModel = HabitListViewModel()

    @State private var selectedDate = Date()

    // Controls whether the AddHabitSheet is currently showing. Toggled to
    // true by the "+" tab in RootTabView via the binding below.
    @Binding var isShowingAddHabit: Bool

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header

                    CalendarStripView(selectedDate: $selectedDate)

                    progressBanner

                    Text("Habits")
                        .font(.title3.bold())

                    // ForEach loops over the ViewModel's habits array and
                    // creates one HabitRowView per habit. Habit conforms to
                    // Identifiable, so SwiftUI can tell rows apart automatically.
                    ForEach(viewModel.habits) { habit in
                        HabitRowView(habit: habit) {
                            // This closure runs when the row's checkbox is tapped.
                            // Notice: the View doesn't change the habit itself,
                            // it just tells the ViewModel to do it.
                            viewModel.toggleHabit(id: habit.id)
                        }
                    }
                }
                .padding()
            }
            .background(AppTheme.groupedBackground)
            .navigationBarHidden(true)
            // .sheet presents AddHabitSheet as a card sliding up from the
            // bottom whenever `isShowingAddHabit` is true.
            .sheet(isPresented: $isShowingAddHabit) {
                AddHabitSheet(viewModel: viewModel)
            }
        }
    }

    // Small pieces of the layout pulled into computed properties. This is a
    // common SwiftUI trick: it keeps `body` readable by giving each chunk a
    // descriptive name, without creating a whole separate file for it.
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Hi, Mert 👋")
                    .font(.title2.bold())
                Text("Let's make habits together!")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.secondaryText)
            }
            Spacer()
            Image(systemName: "bell.fill")
                .foregroundColor(.primary)
        }
    }

    private var progressBanner: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Your daily goals almost done! 🔥")
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                Text("\(viewModel.completedCount) of \(viewModel.habits.count) completed")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            Spacer()
            // A simple ring built from two overlapping circles: a light
            // background track, and a foreground arc trimmed to the
            // current progress percentage.
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 5)
                Circle()
                    // trim(from:to:) only draws part of the circle's outline —
                    // "to: 0.25" draws just the first quarter of it, for example.
                    .trim(from: 0, to: viewModel.progressPercent)
                    .stroke(Color.white, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    .rotationEffect(.degrees(-90)) // start the arc from the top
                Text("\(Int(viewModel.progressPercent * 100))%")
                    .font(.caption2.bold())
                    .foregroundColor(.white)
            }
            .frame(width: 44, height: 44)
        }
        .padding()
        .background(
            LinearGradient(colors: [AppTheme.gradientTop, AppTheme.gradientBottom],
                           startPoint: .leading, endPoint: .trailing)
        )
        .cornerRadius(16)
    }
}

#Preview {
    HomeView(isShowingAddHabit: .constant(false))
}
