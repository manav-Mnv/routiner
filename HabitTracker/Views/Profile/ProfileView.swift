import SwiftUI

// MARK: - What is this file?
// The "Your Profile" screen: avatar + name + points, a pill-shaped
// Activity/Friends/Achievements switcher, and (for the Activity tab) the
// activity feed. Friends/Achievements are left as simple placeholders —
// wiring them up fully would mean more Models/ViewModels than this
// learning app needs, but the tab-switching pattern is fully real.

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()

    // Which of the 3 pill tabs is selected. An `enum` (a fixed list of named
    // options) is a much safer choice here than a raw Int or String — the
    // compiler won't let you accidentally write a 4th, nonexistent tab.
    private enum Tab: String, CaseIterable {
        case activity = "Activity"
        case friends = "Friends"
        case achievements = "Achievements"
    }
    @State private var selectedTab: Tab = .activity

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    profileHeader
                    tabSwitcher

                    switch selectedTab {
                    case .activity:
                        ForEach(viewModel.activity) { item in
                            ActivityRowView(item: item)
                        }
                    case .friends, .achievements:
                        // A simple "nothing here yet" placeholder — this is
                        // where you'd add a Friends/Achievements Model + list
                        // later, following the exact same pattern as Activity.
                        Text("Coming soon.")
                            .foregroundColor(AppTheme.secondaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 40)
                    }
                }
                .padding()
            }
            .background(AppTheme.groupedBackground)
            .navigationTitle("Your Profile")
            .toolbar {
                // A gear icon in the top-right corner that pushes to Settings.
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }

    private var profileHeader: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(AppTheme.primary.opacity(0.2))
                .frame(width: 56, height: 56)
                .overlay(
                    Text(String(viewModel.name.prefix(1))) // just the first letter, as a stand-in avatar
                        .font(.title2.bold())
                        .foregroundColor(AppTheme.primary)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.name)
                    .font(.headline)
                HStack(spacing: 4) {
                    Image(systemName: "medal.fill")
                        .foregroundColor(.orange)
                    Text("\(viewModel.points) Points")
                        .font(.caption)
                        .foregroundColor(AppTheme.secondaryText)
                }
            }
            Spacer()
        }
    }

    // The pill-shaped Activity / Friends / Achievements switcher.
    private var tabSwitcher: some View {
        HStack(spacing: 4) {
            ForEach(Tab.allCases, id: \.self) { tab in
                Text(tab.rawValue)
                    .font(.subheadline.bold())
                    .foregroundColor(selectedTab == tab ? .white : .primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(selectedTab == tab ? AppTheme.primary : .clear)
                    .clipShape(Capsule())
                    .onTapGesture {
                        selectedTab = tab
                    }
            }
        }
        .padding(4)
        .background(Color(.secondarySystemBackground))
        .clipShape(Capsule())
    }
}

#Preview {
    ProfileView()
}
