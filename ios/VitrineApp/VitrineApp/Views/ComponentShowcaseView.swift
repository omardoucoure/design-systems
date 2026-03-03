import SwiftUI
import DesignSystem

struct ComponentShowcaseView: View {
    @Environment(\.theme) private var theme

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                Image(systemName: "cube.transparent")
                    .font(.system(size: 48))
                    .foregroundStyle(theme.colors.textNeutral3)

                Text("Components coming in Phase 2")
                    .font(theme.typography.body.font)
                    .foregroundStyle(theme.colors.textNeutral8)

                Text("DSTextField, DSDropdown, DSTextArea, DSDatePicker, DSButton")
                    .font(theme.typography.caption.font)
                    .foregroundStyle(theme.colors.textNeutral3)
                    .multilineTextAlignment(.center)

                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(theme.colors.surfaceNeutral0_5)
            .navigationTitle("Components")
        }
    }
}
