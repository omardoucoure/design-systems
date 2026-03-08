import SwiftUI
import DesignSystem

// MARK: - Profile3Page

/// Profile screen variant 3 — photo carousel + social info + CTA (Figma node 994-52153).
struct Profile3Page: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    @State private var currentPage = 0

    private let photos = ["profile-photo-1", "profile-photo-2", "profile-photo-1", "profile-photo-2", "profile-photo-1"]
    private let socialCtaOverlap: CGFloat = 58

    var body: some View {
        VStack(spacing: 0) {
            DSTopAppBar(title: "Profile", style: .smallCentered, onBack: { dismiss() }) {
                HStack(spacing: theme.spacing.xs) {
                    DSButton(style: .neutral, size: .medium, systemIcon: "plus.circle") {}
                    DSButton(style: .neutral, size: .medium, systemIcon: "ellipsis.vertical") {}
                }
            }

            ScrollView {
                VStack(spacing: theme.spacing.lg) {
                    VStack(spacing: theme.spacing.md) {
                        carouselSection
                    }

                    VStack(spacing: 0) {
                        socialInfoCard
                            .padding(.bottom, -socialCtaOverlap)
                            .zIndex(2)
                        ctaCard
                            .zIndex(1)
                    }
                    .padding(.horizontal, theme.spacing.sm)
                }
                .padding(.bottom, theme.spacing.lg)
            }
        }
        .background(theme.colors.surfaceNeutral0_5)
        .navigationBarBackButtonHidden(true)
        .dsTabBarHidden()
    }

    // MARK: - Carousel Section

    private var carouselSection: some View {
        VStack(spacing: theme.spacing.md) {
            DSCarouselDeck(images: photos, currentIndex: $currentPage)
            pageDots
        }
    }

    private var pageDots: some View {
        HStack(spacing: theme.spacing.xs) {
            ForEach(photos.indices, id: \.self) { index in
                if index == currentPage {
                    Capsule()
                        .fill(theme.colors.surfacePrimary120)
                        .frame(width: 32, height: 8)
                } else {
                    Circle()
                        .fill(theme.colors.surfaceNeutral3)
                        .frame(width: 8, height: 8)
                }
            }
        }
    }

    // MARK: - Social Info Card

    private var socialInfoCard: some View {
        DSCard(background: theme.colors.surfacePrimary100, radius: theme.radius.xl, padding: 0) {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                DSText("Hristo Hristov", style: theme.typography.h4, color: theme.colors.textNeutral0_5)
                DSText("Rockstar-in-training. Plays air guitar solos that even virtual fans cheer for.",
                       style: theme.typography.captionRegular, color: theme.colors.textNeutral0_5)
                socialStatsRow
            }
            .padding(.horizontal, theme.spacing.xl)
            .padding(.vertical, theme.spacing.xxl)
        }
    }

    private var socialStatsRow: some View {
        HStack(spacing: 0) {
            statColumn(value: "1,200", label: "photos", showDivider: true)
            statColumn(value: "2,980", label: "followers", showDivider: true)
            statColumn(value: "1,600", label: "following", showDivider: false)
        }
    }

    private func statColumn(value: String, label: String, showDivider: Bool) -> some View {
        VStack(alignment: .center, spacing: theme.spacing.xxs) {
            DSText(value, style: theme.typography.largeSemiBold, color: theme.colors.textNeutral0_5)
            DSText(label, style: theme.typography.tiny, color: theme.colors.textNeutral0_5.opacity(theme.colors.textOpacity50))
        }
        .frame(maxWidth: .infinity)
        .overlay(alignment: .trailing) {
            if showDivider {
                Rectangle()
                    .fill(theme.colors.textNeutral0_5.opacity(0.2))
                    .frame(width: 1)
            }
        }
    }

    // MARK: - CTA Card

    private var ctaCard: some View {
        DSCard(background: theme.colors.surfaceSecondary100, radius: theme.radius.xl, padding: 0) {
            HStack {
                DSButton("Follow", style: .filledB, size: .big, iconLeft: "plus") {}
                Spacer()
                DSButton("Message", style: .text, size: .big, iconLeft: "message") {}
            }
            .padding(.top, 80)
            .padding(.bottom, theme.spacing.lg)
            .padding(.horizontal, theme.spacing.xl)
        }
    }
}

#Preview {
    Profile3Page()
        .previewThemed()
}
