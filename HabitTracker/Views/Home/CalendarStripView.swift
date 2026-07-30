import SwiftUI

// MARK: - What is this file?
// The horizontally-scrolling row of day boxes at the top of Home
// ("3 SAT", "4 SUN", "5 MON"...). It's a small, self-contained View so
// HomeView.swift doesn't get cluttered with date-formatting code.

struct CalendarStripView: View {
    // A binding, not a plain value: this View doesn't own "which day is
    // selected", HomeView does. The `$` lets this child View read AND write
    // the parent's @State directly, so tapping a day here updates HomeView too.
    @Binding var selectedDate: Date

    // Build a simple array of the 7 days centered on today. `range` is a
    // Swift feature for looping over a sequence of numbers.
    private var week: [Date] {
        let calendar = Calendar.current
        return (-1...5).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: Date())
        }
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(week, id: \.self) { date in
                    dayBox(for: date)
                }
            }
        }
    }

    // A small helper function that builds ONE day box. Pulling repeated
    // layout code into a function like this (instead of copy-pasting it in
    // the ForEach) keeps `body` easy to scan.
    @ViewBuilder
    private func dayBox(for date: Date) -> some View {
        let isSelected = Calendar.current.isDate(date, inSameDayAs: selectedDate)

        VStack(spacing: 4) {
            Text(date.formatted(.dateTime.day()))
                .font(.headline)
            Text(date.formatted(.dateTime.weekday(.abbreviated)))
                .font(.caption2)
        }
        .foregroundColor(isSelected ? AppTheme.primary : .primary)
        .frame(width: 48, height: 56)
        .background(Color(.secondarySystemBackground))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? AppTheme.primary : .clear, lineWidth: 2)
        )
        .cornerRadius(12)
        .onTapGesture {
            selectedDate = date
        }
    }
}

#Preview {
    CalendarStripView(selectedDate: .constant(Date()))
        .padding()
}
