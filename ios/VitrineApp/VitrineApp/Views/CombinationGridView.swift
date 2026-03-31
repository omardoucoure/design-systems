import SwiftUI
import DesignSystem

struct CombinationGridView: View {
    @Environment(\.theme) private var theme

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 4)

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("4 Brands x 4 Styles = 16 Combinations")
                    .font(theme.typography.largeSemiBold.font)
                    .foregroundStyle(theme.colors.textNeutral9)
                    .padding(.horizontal)

                // Column headers
                HStack(spacing: 8) {
                    Color.clear.frame(width: 0)
                    ForEach(Brand.allCases) { brand in
                        Text(brand.displayName)
                            .font(theme.typography.small.font)
                            .foregroundStyle(theme.colors.textNeutral8)
                            .frame(maxWidth: .infinity)
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                    }
                }
                .padding(.horizontal)

                // Grid rows
                ForEach(Style.allCases) { style in
                    HStack(alignment: .top, spacing: 8) {
                        Text(style.displayName)
                            .font(theme.typography.small.font)
                            .foregroundStyle(theme.colors.textNeutral8)
                            .frame(width: 50)
                            .lineLimit(2)
                            .minimumScaleFactor(0.6)

                        ForEach(Brand.allCases) { brand in
                            miniPreviewCard(brand: brand, style: style)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .background(theme.colors.surfaceNeutral05)
        .navigationTitle("Combination Grid")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func miniPreviewCard(brand: Brand, style: Style) -> some View {
        let config = ThemeConfiguration(brand: brand, style: style)

        return VStack(spacing: 4) {
            // Surface preview
            RoundedRectangle(cornerRadius: config.radius.sm)
                .fill(config.colors.surfaceNeutral2)
                .frame(height: 50)
                .overlay(
                    VStack(spacing: 2) {
                        RoundedRectangle(cornerRadius: config.radius.xs)
                            .fill(config.colors.surfacePrimary100)
                            .frame(width: 40, height: 12)
                        RoundedRectangle(cornerRadius: config.radius.xs)
                            .fill(config.colors.surfaceSecondary100)
                            .frame(width: 40, height: 12)
                    }
                )

            // Text preview
            HStack(spacing: 2) {
                Circle()
                    .fill(config.colors.surfacePrimary100)
                    .frame(width: 8, height: 8)
                Circle()
                    .fill(config.colors.surfaceSecondary100)
                    .frame(width: 8, height: 8)
                Spacer()
            }
        }
        .padding(6)
        .background(
            RoundedRectangle(cornerRadius: config.radius.md)
                .fill(config.colors.surfaceNeutral05)
                .shadow(color: .black.opacity(0.08), radius: 2, y: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: config.radius.md)
                .stroke(config.colors.borderNeutral3, lineWidth: 0.5)
        )
    }
}

#Preview {
    CombinationGridView()
        .previewThemed()
}
