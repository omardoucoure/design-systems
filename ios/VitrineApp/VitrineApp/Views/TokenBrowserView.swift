import SwiftUI
import DesignSystem

struct TokenBrowserView: View {
    @Environment(\.theme) private var theme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                spacingSection
                radiusSection
                typographySection
                borderSection
                opacitySection
                elevationSection
            }
            .padding()
        }
        .background(theme.colors.surfaceNeutral05)
        .navigationTitle("Token Browser")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Spacing

    private var spacingSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionTitle("Spacing")
            spacingBar("none", theme.spacing.none)
            spacingBar("xxxs (2)", theme.spacing.xxxs)
            spacingBar("xxs (4)", theme.spacing.xxs)
            spacingBar("xs (8)", theme.spacing.xs)
            spacingBar("sm (12)", theme.spacing.sm)
            spacingBar("md (16)", theme.spacing.md)
            spacingBar("lg (24)", theme.spacing.lg)
            spacingBar("xl (32)", theme.spacing.xl)
            spacingBar("xxl (40)", theme.spacing.xxl)
            spacingBar("xxxl (48)", theme.spacing.xxxl)
            spacingBar("xxxxl (64)", theme.spacing.xxxxl)
        }
    }

    // MARK: - Radius

    private var radiusSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionTitle("Radius \(theme.isSharp ? "(Sharp — all zeroed)" : "(Rounded)")")
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 8) {
                radiusRect("none", theme.radius.none)
                radiusRect("xxs \(Int(theme.radius.xxs))", theme.radius.xxs)
                radiusRect("xs \(Int(theme.radius.xs))", theme.radius.xs)
                radiusRect("sm \(Int(theme.radius.sm))", theme.radius.sm)
                radiusRect("md \(Int(theme.radius.md))", theme.radius.md)
                radiusRect("lg \(Int(theme.radius.lg))", theme.radius.lg)
                radiusRect("xl \(Int(theme.radius.xl))", theme.radius.xl)
                radiusRect("xxl \(Int(theme.radius.xxl))", theme.radius.xxl)
                radiusRect("xxxl \(Int(theme.radius.xxxl))", theme.radius.xxxl)
                radiusRect("full \(Int(theme.radius.full))", theme.radius.full)
            }
        }
    }

    // MARK: - Typography

    private var typographySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionTitle("Typography (DM Sans)")
            typographySample("display1 (56pt)", theme.typography.display1)
            typographySample("h1 (40pt)", theme.typography.h1)
            typographySample("h3 (32pt)", theme.typography.h3)
            typographySample("largeSemiBold (18pt)", theme.typography.largeSemiBold)
            typographySample("largeRegular (18pt)", theme.typography.largeRegular)
            typographySample("bodySemiBold (16pt)", theme.typography.bodySemiBold)
            typographySample("body (16pt)", theme.typography.body)
            typographySample("bodyRegular (16pt)", theme.typography.bodyRegular)
            typographySample("label (14pt)", theme.typography.label)
            typographySample("caption (14pt)", theme.typography.caption)
            typographySample("small (12pt)", theme.typography.small)
        }
    }

    // MARK: - Border

    private var borderSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionTitle("Border Widths")
            HStack(spacing: 12) {
                borderSample("none", theme.borders.widthNone)
                borderSample("sm (1)", theme.borders.widthSm)
                borderSample("md (2)", theme.borders.widthMd)
                borderSample("lg (4)", theme.borders.widthLg)
            }
        }
    }

    // MARK: - Opacity

    private var opacitySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionTitle("Opacity Levels")
            HStack(spacing: 8) {
                opacitySample("none", theme.opacity.none)
                opacitySample("sm (25%)", theme.opacity.sm)
                opacitySample("md (50%)", theme.opacity.md)
                opacitySample("lg (75%)", theme.opacity.lg)
                opacitySample("full", theme.opacity.full)
            }
        }
    }

    // MARK: - Elevation

    private var elevationSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionTitle("Elevation")
            HStack(spacing: 24) {
                RoundedRectangle(cornerRadius: theme.radius.md)
                    .fill(theme.colors.surfaceNeutral05)
                    .frame(width: 120, height: 80)
                    .overlay(Text("none").font(theme.typography.caption.font))

                RoundedRectangle(cornerRadius: theme.radius.md)
                    .fill(theme.colors.surfaceNeutral05)
                    .frame(width: 120, height: 80)
                    .elevation(theme.elevation.sm)
                    .overlay(Text("sm").font(theme.typography.caption.font))
            }
        }
    }

    // MARK: - Helpers

    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(theme.typography.largeSemiBold.font)
            .foregroundStyle(theme.colors.textNeutral9)
    }

    private func spacingBar(_ label: String, _ value: CGFloat) -> some View {
        HStack(spacing: 8) {
            Text(label)
                .font(theme.typography.caption.font)
                .foregroundStyle(theme.colors.textNeutral8)
                .frame(width: 90, alignment: .trailing)
            RoundedRectangle(cornerRadius: 2)
                .fill(theme.colors.surfaceSecondary100)
                .frame(width: max(value, 1), height: 16)
        }
    }

    private func radiusRect(_ label: String, _ radius: CGFloat) -> some View {
        VStack(spacing: 4) {
            RoundedRectangle(cornerRadius: radius)
                .fill(theme.colors.surfacePrimary100)
                .frame(height: 56)
            Text(label)
                .font(theme.typography.small.font)
                .foregroundStyle(theme.colors.textNeutral8)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
    }

    private func typographySample(_ label: String, _ style: TypographyStyle) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Aa Bb Cc 123")
                .typographyStyle(style)
                .foregroundStyle(theme.colors.textNeutral9)
            Text(label)
                .font(theme.typography.small.font)
                .foregroundStyle(theme.colors.textNeutral8.opacity(0.6))
        }
    }

    private func borderSample(_ label: String, _ width: CGFloat) -> some View {
        VStack(spacing: 4) {
            RoundedRectangle(cornerRadius: theme.radius.sm)
                .strokeBorder(theme.colors.borderNeutral95, lineWidth: max(width, 0.5))
                .frame(width: 60, height: 60)
            Text(label)
                .font(theme.typography.small.font)
                .foregroundStyle(theme.colors.textNeutral8)
        }
    }

    private func opacitySample(_ label: String, _ opacity: Double) -> some View {
        VStack(spacing: 4) {
            RoundedRectangle(cornerRadius: theme.radius.sm)
                .fill(theme.colors.surfacePrimary100.opacity(opacity))
                .frame(height: 44)
            Text(label)
                .font(theme.typography.small.font)
                .foregroundStyle(theme.colors.textNeutral8)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
    }
}

#Preview("Rounded") {
    TokenBrowserView()
        .previewThemed(brand: .seaLime, style: .lightRounded)
}

#Preview("Sharp") {
    TokenBrowserView()
        .previewThemed(brand: .seaLime, style: .lightSharp)
}
