import SwiftUI

// MARK: - What is this file?
// The Settings screen, styled like the native iOS Settings app (which is
// exactly what the Figma design is going for). `List` with `.insetGrouped`
// style gives us those rounded white sections for free — no manual card
// drawing needed like on Home/Profile.

struct SettingsView: View {
    // @AppStorage automatically saves these to the device (UserDefaults)
    // and restores them next launch, so a toggle here actually "sticks" —
    // a nice tiny example of real persistence without a database.
    @AppStorage("darkModeEnabled") private var darkModeEnabled = false
    @AppStorage("soundsEnabled") private var soundsEnabled = true
    @State private var vacationModeEnabled = false

    var body: some View {
        List {
            Section("General") {
                NavigationLink("General") { Text("General settings go here.") }

                Toggle(isOn: $darkModeEnabled) {
                    Label("Dark Mode", systemImage: "moon.fill")
                }

                NavigationLink("Security") { Text("Security settings go here.") }
                NavigationLink("Notifications") { Text("Notification settings go here.") }

                Toggle(isOn: $soundsEnabled) {
                    Label("Sounds", systemImage: "speaker.wave.2.fill")
                }

                Toggle(isOn: $vacationModeEnabled) {
                    Label("Vacation Mode", systemImage: "play.circle.fill")
                }
            }

            Section("About Us") {
                NavigationLink("Rate Routiner") { Text("App Store rating flow goes here.") }
                NavigationLink("Share with Friends") { Text("Share sheet goes here.") }
                NavigationLink("About Us") { Text("About screen goes here.") }
                NavigationLink("Support") { Text("Support/contact screen goes here.") }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
