import SwiftUI

// MARK: - What is this file?
// The sign-in screen shown after tapping "Continue with E-mail" on
// Onboarding. We have no backend (per an earlier decision — this app is
// frontend-only), so there's nothing real to authenticate against. Instead,
// this screen exists as a clean, real-world example of CONDITIONAL
// STATEMENTS: checking form input step by step and reacting differently
// depending on what the user typed.

struct LoginView: View {
    // Two-way bound to the TextFields below — typing updates these,
    // and these could update the TextFields if we changed them in code.
    @State private var email = ""
    @State private var password = ""

    // Optional because most of the time there IS no error — nil means
    // "nothing to show". We only give it a value when validation fails.
    @State private var errorMessage: String?

    // Same flag OnboardingView reads. Setting it to true here is our
    // "successful login" — it makes HabitTrackerApp.swift switch the
    // whole app over to RootTabView.
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    // Lets this screen close itself (used by the "back" button below).
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .foregroundColor(.primary)
            }
            .padding(.top, 8)

            Text("Sign In")
                .font(.largeTitle.bold())

            Text("Enter your details to continue.")
                .foregroundColor(AppTheme.secondaryText)

            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)

            SecureField("Password", text: $password) // dots-out the text, same as a normal password field
                .textFieldStyle(.roundedBorder)

            // MARK: - The conditional statement in action
            // `if let errorMessage { ... }` is Swift's "optional binding":
            // this block ONLY runs when `errorMessage` is not nil. No crash,
            // no need to force-unwrap — if there's no error, this whole
            // View simply isn't drawn at all.
            if let errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
            }

            Button {
                handleSignIn()
            } label: {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppTheme.primary)
                    .clipShape(Capsule())
            }
            .padding(.top, 8)

            Spacer()
        }
        .padding(24)
    }

    // MARK: - Validation logic
    // This is the actual "if / else if / else" chain the lesson is about.
    // Swift checks each condition TOP TO BOTTOM and stops at the first one
    // that's true — so order matters. We check the most basic problem
    // (empty fields) first, then more specific problems, and only fall
    // through to "else" (success) if every check above was false.
    private func handleSignIn() {
        if email.isEmpty || password.isEmpty {
            // `||` means "or" — true if EITHER field is empty.
            errorMessage = "Please fill in both fields."
        } else if !email.contains("@") {
            // `!` negates a condition — this reads as "if email does NOT contain @".
            errorMessage = "That doesn't look like a valid email."
        } else if password.count < 6 {
            errorMessage = "Password must be at least 6 characters."
        } else {
            // Every check above failed to match, so the input is valid.
            errorMessage = nil
            hasCompletedOnboarding = true // our "fake" successful login
        }
    }
}

#Preview {
    LoginView()
}
