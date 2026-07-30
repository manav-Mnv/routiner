import Foundation

// MARK: - What is this file?
// The ViewModel for the Profile screen. Holds the signed-in user's basic
// info and their activity feed. Since we have no backend, this is just
// hard-coded sample state — swap this out for real network calls later
// without ever touching ProfileView.swift.

class ProfileViewModel: ObservableObject {
    @Published var name: String = "Mert Kahveci"
    @Published var points: Int = 1452
    @Published var activity: [ActivityItem] = ActivityItem.sampleData
}
