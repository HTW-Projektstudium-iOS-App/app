import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "person.crop.rectangle")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .clipShape(Circle())

            Text("John Doe")
                .font(.headline)

            Text("iOS Developer")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Divider()

            VStack(alignment: .leading, spacing: 4) {
                Label("+1 (555) 123-4567", systemImage: "phone.fill")
                Label("john.doe@example.com", systemImage: "envelope.fill")
                Label("johndoe.dev", systemImage: "link")
            }
            .font(.footnote)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
                .shadow(radius: 2)
        )
        .padding()
    }
}
