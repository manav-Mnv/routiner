import SwiftUI

// MARK: - What is this file?
// The very first screen a new user sees — matches the purple/indigo
// gradient "Create Good Habits" screens in the Figma file. It's 3 swipeable
// pages, then a "Continue with E-mail" button that finishes onboarding.
//
// There's no real Model/ViewModel needed here — this screen has no
// business logic, just some text per page and "have we onboarded yet?"
// state, so it's fine for a simple screen like this to keep its own @State.
// Not every screen in MVVM needs its own ViewModel class.

// A tiny local model just for the 3 pages of marketing copy.
private struct OnboardingPage {
    let headline: String
    let subtext: String
}

private let pages: [OnboardingPage] = [
    OnboardingPage(headline: "Create\nGood Habits",
                   subtext: "Change your life by slowly adding new healthy habits and sticking to them."),
    OnboardingPage(headline: "Track\nYour Progress",
                   subtext: "See your streaks and daily goals at a glance, right from the home screen."),
    OnboardingPage(headline: "Stay Together\nand Strong",
                   subtext: "Invite friends, join challenges, and keep each other accountable.")
]

struct OnboardingView: View {
    // Which page (0, 1, or 2) is currently showing.
    @State private var currentPage = 0

    // @AppStorage saves this value to the device automatically (UserDefaults
    // under the hood) and reads it back next launch — a beginner-friendly
    // way to persist one small flag without setting up a database.
    // When this flips to true, HabitTrackerApp.swift switches away from
    // this screen for good, so onboarding only shows once.
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    // Controls whether LoginView is currently covering the screen.
    // Toggled to true by the "Continue with E-mail" button below.
    @State private var isShowingLogin = false

    var body: some View {
        ZStack {
            // The diagonal purple-to-indigo background from the design.
            LinearGradient(colors: [AppTheme.gradientTop, AppTheme.gradientBottom],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                // TabView with .page style gives us free swipeable pages
                // AND the little dot indicator at the bottom, no extra code needed.
                TabView(selection: $currentPage) {
                    ForEach(pages.indices, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 12) {
                            Spacer()
                            Text(pages[index].headline)
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.white)

                            Text(pages[index].subtext)
                                .font(.body)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.horizontal, 24)
                        .tag(index) // tag() links this page to `currentPage`'s value
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                // Without this, page dots default to a dark color that's
                // invisible against our dark gradient background.
                .onAppear {
                    UIPageControl.appearance().currentPageIndicatorTintColor = .white
                    UIPageControl.appearance().pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.3)
                }

                // "Continue with E-mail" opens LoginView on top of this
                // screen. LoginView itself is what eventually sets
                // hasCompletedOnboarding = true once the (fake) sign-in
                // passes validation.
                Button {
                    isShowingLogin = true
                } label: {
                    Text("Continue with E-mail")
                        .font(.headline)
                        .foregroundColor(AppTheme.primary)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 24)

                Text("By continuing you agree to our Terms of Service and Privacy Policy")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 24)
            }
        }
        // .fullScreenCover slides LoginView up to cover the ENTIRE screen
        // (unlike .sheet, which leaves a peek of what's behind it) —
        // the right choice for an auth screen like this one.
        .fullScreenCover(isPresented: $isShowingLogin) {
            LoginView()
        }
    }
}

#Preview {
    OnboardingView()
}
