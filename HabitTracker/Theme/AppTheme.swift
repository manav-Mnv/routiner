import SwiftUI

// MARK: - What is this file?
// A single place that holds the app's colors. Pulled straight from the
// Figma design (Routiner - Habit Tracker App).
//
// Why bother with a "theme" file instead of typing colors everywhere?
// If the designer changes the brand purple next month, you edit ONE line
// here instead of hunting through every screen. It also means every screen
// automatically stays visually consistent.

enum AppTheme {
    // The deep indigo/purple used for the primary button, progress rings,
    // and the onboarding background gradient.
    static let primary = Color(hex: "4F46E5")

    // The two ends of the diagonal gradient behind the onboarding screens.
    static let gradientTop = Color(hex: "7B7FF6")
    static let gradientBottom = Color(hex: "4338CA")

    // Soft gray card background used behind grouped lists (e.g. Settings).
    static let groupedBackground = Color(hex: "F5F6FA")

    // Text colors.
    static let secondaryText = Color(hex: "8B8D97")
}

// MARK: - Color(hex:)
// SwiftUI's `Color` only ships initializers for named colors (.blue, .red)
// or RGB values from 0...1 (Color(red: 0.3, green: 0.5, blue: 0.9)).
// Designers hand us hex codes instead (like "4F46E5"), so this extension
// teaches `Color` a new initializer that understands hex strings.
extension Color {
    init(hex: String) {
        // Strip out anything that isn't a hex digit, just in case a "#" sneaks in.
        let cleanHex = hex.trimmingCharacters(in: .alphanumerics.inverted)

        // Scanner reads the hex string as one big integer, e.g. "4F46E5" -> 0x4F46E5.
        var rgbValue: UInt64 = 0
        Scanner(string: cleanHex).scanHexInt64(&rgbValue)

        // Bit-shifting pulls out each color channel from that single integer.
        // Example: 0x4F46E5 -> red = 0x4F, green = 0x46, blue = 0xE5.
        let red = Double((rgbValue >> 16) & 0xFF) / 255
        let green = Double((rgbValue >> 8) & 0xFF) / 255
        let blue = Double(rgbValue & 0xFF) / 255

        self.init(red: red, green: green, blue: blue)
    }
}
