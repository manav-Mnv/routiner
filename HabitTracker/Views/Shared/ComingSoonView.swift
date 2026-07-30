import SwiftUI

// MARK: - What is this file?
// A tiny reusable placeholder screen. The Figma design has 5 tabs (Home,
// Explore, Add, Activity, Profile) but this learning app only fully builds
// Home and Profile. Rather than skip the tab bar entirely, we show a
// friendly placeholder for Explore/Activity — so the navigation structure
// still matches the real design, and it's obvious where you'd plug in a
// real screen later (just swap this View out in RootTabView.swift).

struct ComingSoonView: View {
    let title: String
    let systemImage: String

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Image(systemName: systemImage)
                    .font(.system(size: 40))
                    .foregroundColor(AppTheme.secondaryText)
                Text("\(title) is coming soon")
                    .font(.headline)
                    .foregroundColor(AppTheme.secondaryText)
            }
            .navigationTitle(title)
        }
    }
}

#Preview {
    ComingSoonView(title: "Explore", systemImage: "safari")
}
