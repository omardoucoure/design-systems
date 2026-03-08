import SwiftUI
import DesignSystem

// MARK: - Profile4Page

/// Profile screen variant 4 — hero image + social info + photo grid (Figma node 994-50708).
struct Profile4Page: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    /// Overlap between social info card and CTA card (Figma: mb=-58, pb=58).
    private let cardOverlap: CGFloat = 58

    var body: some View {
        VStack(spacing: 0) {
            // Top App Bar — Figma 994:50711
            // bg surfaceNeutral0_5, gap=xs(8), p=sm(12)
            // back: neutral h=40, trailing: more-vert neutral h=40
            // title: h5 (20px medium), centered
            DSTopAppBar(title: "Profile", style: .smallCentered, onBack: { dismiss() }) {
                DSButton(style: .neutral, size: .medium, systemIcon: "ellipsis") {}
            }

            ScrollView {
                // Content — Figma 994:50712: gap=sm(12), px=sm(12), pb=sm(12)
                VStack(spacing: theme.spacing.sm) {
                    // Hero image — Figma 994:50713: h=188, rounded-xl(32), full width
                    Image("profile4-hero")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 188)
                        .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))

                    // Profile Info — Figma 994:50714: overlapping cards
                    VStack(spacing: 0) {
                        socialInfoCard
                            .padding(.bottom, -cardOverlap)
                            .zIndex(2)
                        ctaCard
                            .zIndex(1)
                    }

                    // Photos grid — Figma 994:50737: gap=sm(12)
                    photoGrid
                }
                .padding(.bottom, theme.spacing.sm)
            }
            .padding(.horizontal, theme.spacing.sm)
        }
        .background(theme.colors.surfaceNeutral0_5)
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: - Social Info Card
    // Figma 994:50715: bg surfacePrimary100, rounded-xl(32), px=xl(32), py=xxl(40), gap=lg(24)

    private var socialInfoCard: some View {
        DSCard(background: theme.colors.surfacePrimary100, radius: theme.radius.xl, padding: 0) {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                // Text group — Figma 994:50716: gap=sm(12)
                VStack(alignment: .leading, spacing: theme.spacing.sm) {
                    // Figma 994:50717: h4 (24px medium), textNeutral0_5
                    Text("Hristo Hristov")
                        .font(theme.typography.h4.font)
                        .tracking(theme.typography.h4.tracking)
                        .foregroundStyle(theme.colors.textNeutral0_5)

                    // Figma 994:50718: captionRegular (14px regular), textNeutral0_5
                    Text("Rockstar-in-training. Plays air guitar solos that even virtual fans cheer for.")
                        .font(theme.typography.captionRegular.font)
                        .tracking(theme.typography.captionRegular.tracking)
                        .lineSpacing(theme.typography.captionRegular.lineSpacing)
                        .foregroundStyle(theme.colors.textNeutral0_5)
                }

                // Divider — Figma 994:50719: 1px line inside dark card
                // Using inline divider — DSDivider doesn't support custom colors
                Rectangle()
                    .fill(theme.colors.textNeutral0_5.opacity(0.2))
                    .frame(height: 1)

                // Social stats + message button — Figma 994:50720: gap=0, rounded-md(16)
                socialStatsRow
            }
            .padding(.horizontal, theme.spacing.xl)
            .padding(.vertical, theme.spacing.xxl)
        }
    }

    // MARK: - Social Stats Row
    // Figma 994:50720: HStack gap=0, items left-aligned

    private var socialStatsRow: some View {
        HStack(spacing: 0) {
            // Stat 1 — Figma 994:50721: flex-1, pl=0, pr=xs(8)
            statColumn(value: "1,200", label: "photos")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, theme.spacing.xs)

            // Stat 2 — Figma 994:50724: flex-1, p=0
            statColumn(value: "2,980", label: "followers")
                .frame(maxWidth: .infinity, alignment: .leading)

            // Stat 3 — Figma 994:50727: flex-1, p=0
            statColumn(value: "1,600", label: "following")
                .frame(maxWidth: .infinity, alignment: .leading)

            // Message button — Figma 994:50730: surfaceSecondary100, rounded-full, h=40, px=md(16), py=xs(8)
            DSButton(style: .filledA, size: .medium, assetIcon: "icon_message_text") {}
        }
    }

    private func statColumn(value: String, label: String) -> some View {
        // Figma: flex-1, gap=0, items left-aligned
        VStack(alignment: .leading, spacing: 0) {
            // Figma 994:50722: largeSemiBold (18px semibold), textNeutral0_5
            Text(value)
                .font(theme.typography.largeSemiBold.font)
                .tracking(theme.typography.largeSemiBold.tracking)
                .foregroundStyle(theme.colors.textNeutral0_5)

            // Figma 994:50723: smallRegular (12px regular), textNeutral0_5 opacity 75%
            Text(label)
                .font(theme.typography.smallRegular.font)
                .tracking(theme.typography.smallRegular.tracking)
                .foregroundStyle(theme.colors.textNeutral0_5.opacity(0.75))
        }
    }

    // MARK: - CTA Card
    // Figma 994:50731: bg surfaceSecondary100, rounded-xl(32), px=xl(32), pt=80, pb=lg(24)
    // justify-between, items-end

    private var ctaCard: some View {
        DSCard(background: theme.colors.surfaceSecondary100, radius: theme.radius.xl, padding: 0) {
            HStack(alignment: .bottom) {
                // Follow button — Figma 994:50732: surfacePrimary100, rounded-full, h=40
                // label (14px semibold), textNeutral0_5, icon "plus" on right
                DSButton("Follow", style: .filledB, size: .medium, iconRight: "plus") {}

                Spacer()

                // Social icons — Figma 994:50733: gap=md(16), w=130
                HStack(spacing: theme.spacing.md) {
                    // Figma 994:50734: Instagram, h=40, px=0, py=xs(8)
                    DSButton(style: .text, size: .medium, assetIcon: "icon_instagram") {}
                    // Figma 994:50735: Facebook
                    DSButton(style: .text, size: .medium, assetIcon: "icon_facebook") {}
                    // Figma 994:50736: X (Twitter)
                    DSButton(style: .text, size: .medium, assetIcon: "icon_x") {}
                }
            }
            .padding(.top, 80)
            .padding(.bottom, theme.spacing.lg)
            .padding(.horizontal, theme.spacing.xl)
        }
    }

    // MARK: - Photo Grid
    // Figma 994:50737: gap=sm(12)

    /// Figma: wider image is ~2.3x narrower one (248 vs 107 on 375pt screen).
    private let wideGridWeight: CGFloat = 2.3
    private let gridHeight: CGFloat = 124

    private var photoGrid: some View {
        VStack(spacing: theme.spacing.sm) {
            // Row 1 — Figma 994:50738: gap=12, h=124
            // flex-1 (994:50739) + ~2.3x wider (994:50740)
            HStack(spacing: theme.spacing.sm) {
                gridImage("profile4-grid1")
                    .frame(maxWidth: .infinity)

                gridImage("profile4-grid2")
                    .frame(maxWidth: .infinity)
                    .layoutPriority(wideGridWeight)
            }
            .frame(height: gridHeight)

            // Row 2 — Figma 994:50741: gap=12, h=124
            // ~2.3x wider (994:50742) + flex-1 (994:50743)
            HStack(spacing: theme.spacing.sm) {
                gridImage("profile4-grid3")
                    .frame(maxWidth: .infinity)
                    .layoutPriority(wideGridWeight)

                gridImage("profile4-grid4")
                    .frame(maxWidth: .infinity)
            }
            .frame(height: gridHeight)
        }
    }

    private func gridImage(_ name: String) -> some View {
        Image(name)
            .resizable()
            .scaledToFill()
            .frame(height: gridHeight)
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.lg))
    }
}

#Preview {
    Profile4Page()
        .previewThemed()
}
