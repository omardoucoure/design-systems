import SwiftUI
import DesignSystem

struct ColorPaletteView: View {
    @Environment(\.theme) private var theme

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    activeThemeSection
                    allBrandPrimitivesSection
                }
                .padding()
            }
            .background(theme.colors.surfaceNeutral0_5)
            .navigationTitle("Color Palette")
        }
    }

    // MARK: - Active Theme Resolved Colors

    private var activeThemeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Active Theme: \(theme.brand.displayName) / \(theme.style.displayName)")
                .font(theme.typography.largeSemiBold.font)
                .foregroundStyle(theme.colors.textNeutral9)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 8) {
                colorSwatch("Surface 0.5", theme.colors.surfaceNeutral0_5)
                colorSwatch("Surface 2", theme.colors.surfaceNeutral2)
                colorSwatch("Surface 3", theme.colors.surfaceNeutral3)
                colorSwatch("Surface 9", theme.colors.surfaceNeutral9)
                colorSwatch("Primary", theme.colors.surfacePrimary100)
                colorSwatch("Primary 120", theme.colors.surfacePrimary120)
                colorSwatch("Secondary", theme.colors.surfaceSecondary100)
            }

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 8) {
                colorSwatch("Text 9", theme.colors.textNeutral9)
                colorSwatch("Text 8", theme.colors.textNeutral8)
                colorSwatch("Text 3", theme.colors.textNeutral3)
                colorSwatch("Text 0.5", theme.colors.textNeutral0_5)
                colorSwatch("Text Pri", theme.colors.textPrimary100)
                colorSwatch("Text Sec", theme.colors.textSecondary100)
            }

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 8) {
                colorSwatch("Error", theme.colors.error)
                colorSwatch("Warning", theme.colors.warning)
                colorSwatch("Valid", theme.colors.validated)
                colorSwatch("Info", theme.colors.infoFocus)
            }
        }
    }

    // MARK: - All Brands Side by Side

    private var allBrandPrimitivesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("All Brand Primitives")
                .font(theme.typography.largeSemiBold.font)
                .foregroundStyle(theme.colors.textNeutral9)

            ForEach(Brand.allCases) { brand in
                VStack(alignment: .leading, spacing: 4) {
                    Text(brand.displayName)
                        .font(theme.typography.label.font)
                        .foregroundStyle(theme.colors.textNeutral8)

                    let p = brand.primitives
                    HStack(spacing: 2) {
                        Rectangle().fill(p.primary80).frame(height: 32)
                        Rectangle().fill(p.primary100).frame(height: 32)
                        Rectangle().fill(p.primary120).frame(height: 32)
                        Rectangle().fill(p.secondary10).frame(height: 32)
                        Rectangle().fill(p.secondary40).frame(height: 32)
                        Rectangle().fill(p.secondary100).frame(height: 32)
                        Rectangle().fill(p.secondary120).frame(height: 32)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: theme.radius.sm))

                    HStack(spacing: 1) {
                        neutralBar(p.neutrals.n0)
                        neutralBar(p.neutrals.n0_5)
                        neutralBar(p.neutrals.n1)
                        neutralBar(p.neutrals.n2)
                        neutralBar(p.neutrals.n3)
                        neutralBar(p.neutrals.n4)
                        neutralBar(p.neutrals.n5)
                        neutralBar(p.neutrals.n6)
                        neutralBar(p.neutrals.n7)
                        neutralBar(p.neutrals.n8)
                        neutralBar(p.neutrals.n8_5)
                        neutralBar(p.neutrals.n9)
                        neutralBar(p.neutrals.n9_5)
                        neutralBar(p.neutrals.n10)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: theme.radius.xs))
                }
            }
        }
    }

    // MARK: - Helpers

    private func colorSwatch(_ label: String, _ color: Color) -> some View {
        VStack(spacing: 4) {
            RoundedRectangle(cornerRadius: theme.radius.xs)
                .fill(color)
                .frame(height: 44)
                .overlay(
                    RoundedRectangle(cornerRadius: theme.radius.xs)
                        .stroke(theme.colors.borderNeutral3, lineWidth: 0.5)
                )
            Text(label)
                .font(theme.typography.small.font)
                .foregroundStyle(theme.colors.textNeutral8)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
    }

    private func neutralBar(_ color: Color) -> some View {
        Rectangle().fill(color).frame(height: 20)
    }
}
