import SwiftUI

// MARK: - What is this file?
// This is the entry point of the whole app — the very first thing that runs.
// Every SwiftUI app needs exactly one type marked `@main` conforming to `App`.
// Its job here: decide whether to show Onboarding or the main app, and show
// it inside a window.

@main
struct HabitTrackerApp: App {
    // Reads the same flag that OnboardingView.swift writes to. Because it's
    // @AppStorage (backed by UserDefaults), this value survives the app
    // being closed and reopened — so a returning user skips onboarding.
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some Scene {
        // WindowGroup represents the app's window (on iPhone, effectively
        // just "the screen").
        WindowGroup {
            if hasCompletedOnboarding {
                RootTabView()
            } else {
                OnboardingView()
            }
        }
    }
}
