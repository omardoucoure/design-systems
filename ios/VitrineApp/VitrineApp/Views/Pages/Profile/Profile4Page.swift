import SwiftUI
import DesignSystem

// MARK: - Profile4Page

/// Profile screen variant 4 — hero image + social info + photo grid (Figma node 994-50708).
struct Profile4Page: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    private let cardOverlap: CGFloat = 58

    var body: some View {
        VStack(spacing: 0) {
            DSTopAppBar(title: "Profile", style: .smallCentered, onBack: { dismiss() }) {
                DSButton(style: .neutral, size: .medium, systemIcon: "ellipsis") {}
            }

            ScrollView {
                VStack(spacing: theme.spacing.sm) {
                    Image("profile4-hero")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 188)
                        .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))

                    VStack(spacing: 0) {
                        socialInfoCard
                            .padding(.bottom, -cardOverlap)
                            .zIndex(2)
                        ctaCard
                            .zIndex(1)
                    }

                    photoGrid
                }
                .padding(.bottom, theme.spacing.sm)
            }
            .padding(.horizontal, theme.spacing.sm)
        }
        .background(theme.colors.surfaceNeutral0_5)
        .navigationBarBackButtonHidden(true)
        .dsTabBarHidden()
    }

    // MARK: - Social Info Card

    private var socialInfoCard: some View {
        DSCard(background: theme.colors.surfacePrimary100, radius: theme.radius.xl, padding: 0) {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                VStack(alignment: .leading, spacing: theme.spacing.sm) {
                    DSText("Hristo Hristov", style: theme.typography.h4, color: theme.colors.textNeutral0_5)
                    DSText("Rockstar-in-training. Plays air guitar solos that even virtual fans cheer for.",
                           style: theme.typography.captionRegular, color: theme.colors.textNeutral0_5)
                }

                Rectangle()
                    .fill(theme.colors.textNeutral0_5.opacity(0.2))
                    .frame(height: 1)

                socialStatsRow
            }
            .padding(.horizontal, theme.spacing.xl)
            .padding(.vertical, theme.spacing.xxl)
        }
    }

    // MARK: - Social Stats Row

    private var socialStatsRow: some View {
        HStack(spacing: 0) {
            statColumn(value: "1,200", label: "photos")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, theme.spacing.xs)
            statColumn(value: "2,980", label: "followers")
                .frame(maxWidth: .infinity, alignment: .leading)
            statColumn(value: "1,600", label: "following")
                .frame(maxWidth: .infinity, alignment: .leading)
            DSButton(style: .filledA, size: .medium, icon: .messageText) {}
        }
    }

    private func statColumn(value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            DSText(value, style: theme.typography.largeSemiBold, color: theme.colors.textNeutral0_5)
            DSText(label, style: theme.typography.smallRegular, color: theme.colors.textNeutral0_5.opacity(0.75))
        }
    }

    // MARK: - CTA Card

    private var ctaCard: some View {
        DSCard(background: theme.colors.surfaceSecondary100, radius: theme.radius.xl, padding: 0) {
            HStack(alignment: .bottom) {
                DSButton("Follow", style: .filledB, size: .medium, iconRight: "plus") {}
                Spacer()
                HStack(spacing: theme.spacing.md) {
                    DSButton(style: .text, size: .medium, icon: .instagram) {}
                    DSButton(style: .text, size: .medium, icon: .facebook) {}
                    DSButton(style: .text, size: .medium, icon: .x) {}
                }
            }
            .padding(.top, 80)
            .padding(.bottom, theme.spacing.lg)
            .padding(.horizontal, theme.spacing.xl)
        }
    }

    // MARK: - Photo Grid

    private let wideGridWeight: CGFloat = 2.3
    private let gridHeight: CGFloat = 124

    private var photoGrid: some View {
        VStack(spacing: theme.spacing.sm) {
            HStack(spacing: theme.spacing.sm) {
                gridImage("profile4-grid1").frame(maxWidth: .infinity)
                gridImage("profile4-grid2").frame(maxWidth: .infinity).layoutPriority(wideGridWeight)
            }
            .frame(height: gridHeight)

            HStack(spacing: theme.spacing.sm) {
                gridImage("profile4-grid3").frame(maxWidth: .infinity).layoutPriority(wideGridWeight)
                gridImage("profile4-grid4").frame(maxWidth: .infinity)
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
