import SwiftUI

// MARK: - What is this file?
// One row in the Profile screen's activity feed, e.g.
// "112 points earned! · Today, 12:34 PM" with a green up arrow.
// Same idea as HabitRowView: a small, reusable, "dumb" View that just
// displays whatever ActivityItem it's handed.

struct ActivityRowView: View {
    let item: ActivityItem

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.subheadline.bold())
                Text(item.timeAgo)
                    .font(.caption)
                    .foregroundColor(AppTheme.secondaryText)
            }
            Spacer()
            Image(systemName: item.isPositive ? "arrow.up" : "arrow.down")
                .foregroundColor(item.isPositive ? .green : .red)
                .padding(8)
                .background(Circle().stroke(item.isPositive ? .green : .red, lineWidth: 1))
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

#Preview {
    ActivityRowView(item: ActivityItem.sampleData[0])
        .padding()
}
