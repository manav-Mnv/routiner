import SwiftUI

// MARK: - What is this file?
// The bottom tab bar that wraps the whole app once onboarding is done —
// Home / Explore / Add / Activity / Profile, matching the 5-icon bar in
// the Figma design. This is the "shell" screen: it doesn't draw any real
// content itself, it just decides which full screen is currently visible.

struct RootTabView: View {
    // Tracks which tab is selected. Tagging each screen below with a number
    // (.tag(0), .tag(1)...) is what lets this @State control the selection.
    @State private var selectedTab = 0

    // The center "+" tab is special: instead of switching to a new screen,
    // tapping it should pop open the AddHabitSheet on TOP of Home. We do
    // that by handing HomeView a binding it can open a sheet with — see
    // the `onChange` below.
    @State private var isShowingAddHabit = false

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(isShowingAddHabit: $isShowingAddHabit)
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(0)

            ComingSoonView(title: "Explore", systemImage: "safari")
                .tabItem { Label("Explore", systemImage: "safari") }
                .tag(1)

            // A blank placeholder tab just to reserve the middle tab-bar
            // slot visually — see `onChange` below for why tapping it
            // never actually "selects" it.
            Color.clear
                .tabItem { Label("Add", systemImage: "plus.circle.fill") }
                .tag(2)

            ComingSoonView(title: "Activity", systemImage: "chart.line.uptrend.xyaxis")
                .tabItem { Label("Activity", systemImage: "chart.line.uptrend.xyaxis") }
                .tag(3)

            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.fill") }
                .tag(4)
        }
        .tint(AppTheme.primary)
        // Watches `selectedTab` for changes. If the user tapped the "Add"
        // tab (tag 2), we open the sheet instead and immediately snap the
        // selection back to whichever tab it was on before — so "Add"
        // behaves like a button, not a real destination.
        .onChange(of: selectedTab) { oldValue, newValue in
            if newValue == 2 {
                isShowingAddHabit = true
                selectedTab = oldValue
            }
        }
    }
}

#Preview {
    RootTabView()
}
