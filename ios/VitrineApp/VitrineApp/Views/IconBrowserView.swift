import SwiftUI
import DesignSystem

struct IconBrowserView: View {
    @Environment(\.theme) private var theme
    @State private var searchText = ""

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)

    private var filteredIcons: [DSIcon] {
        if searchText.isEmpty {
            return DSIcon.allCases
        }
        let query = searchText.lowercased()
        return DSIcon.allCases.filter { icon in
            icon.rawValue.lowercased().contains(query)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            DSSearchField(text: $searchText, placeholder: "Search 1364 icons...")
                .padding(.horizontal, theme.spacing.sm)
                .padding(.vertical, theme.spacing.xs)

            ScrollView {
                LazyVGrid(columns: columns, spacing: theme.spacing.sm) {
                    ForEach(filteredIcons, id: \.rawValue) { icon in
                        iconCell(icon)
                    }
                }
                .padding(.horizontal, theme.spacing.sm)
                .padding(.bottom, theme.spacing.xl)
            }
            .scrollIndicators(.hidden)
        }
        .background(theme.colors.surfaceNeutral0_5)
        .navigationTitle("Icons (\(filteredIcons.count))")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func iconCell(_ icon: DSIcon) -> some View {
        VStack(spacing: theme.spacing.xs) {
            DSIconImage(icon, size: 28, color: theme.colors.textNeutral9)
                .frame(width: 48, height: 48)
                .background(theme.colors.surfaceNeutral2)
                .clipShape(RoundedRectangle(cornerRadius: theme.radius.lg))

            Text(iconLabel(icon))
                .font(theme.typography.small.font)
                .tracking(theme.typography.small.tracking)
                .foregroundStyle(theme.colors.textNeutral8)
                .lineLimit(2)
                .minimumScaleFactor(0.7)
                .multilineTextAlignment(.center)
        }
    }

    private func iconLabel(_ icon: DSIcon) -> String {
        // Convert rawValue "icon_bell_notification" → "bell notification"
        icon.rawValue
            .replacingOccurrences(of: "icon_", with: "")
            .replacingOccurrences(of: "_", with: " ")
    }
}

#Preview {
    NavigationStack {
        IconBrowserView()
    }
    .previewThemed()
}
