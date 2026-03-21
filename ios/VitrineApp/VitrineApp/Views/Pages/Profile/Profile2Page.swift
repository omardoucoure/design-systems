import SwiftUI
import DesignSystem

// MARK: - Profile2Page

/// Profile screen variant 2 — avatar + stats + list (Figma node 321-12363).
struct Profile2Page: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    /// Overlap between the image/CTA row and the profile info card, and between
    /// the profile info card and the stats card.
    private let cardOverlap: CGFloat = 24

    var body: some View {
        VStack(spacing: 0) {
            DSTopAppBar(title: "Profile", style: .smallCentered, onBack: { dismiss() }) {
                DSButton(style: .neutral, size: .medium, systemIcon: "ellipsis.vertical") {}
            }

            ScrollView {
                VStack(spacing: theme.spacing.sm) {
                    pictureInfoSection
                    statsCard
                        .padding(.top, -cardOverlap)
                    listCard
                }
                .padding(.horizontal, theme.spacing.sm)
                .padding(.bottom, theme.spacing.sm)
            }
        }
        .background(theme.colors.surfaceNeutral0_5.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .dsTabBarHidden()
    }

    // MARK: - Picture + Info Section

    private var pictureInfoSection: some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom) {
                avatarPhoto
                Spacer()
                DSButton("Follow", style: .filledA, size: .medium, iconRight: "plus") {}
            }
            .padding(.horizontal, theme.spacing.xl)
            .zIndex(2)

            profileInfoCard
                .padding(.top, -cardOverlap)
                .zIndex(1)
        }
        .padding(.bottom, cardOverlap)
    }

    private var avatarPhoto: some View {
        DSCard(background: theme.colors.surfaceNeutral2, radius: theme.radius.md, padding: 0) {
            Image("profile-photo-1")
                .resizable()
                .scaledToFill()
                .frame(width: 108, height: 108)
        }
    }

    private var profileInfoCard: some View {
        DSCard(background: theme.colors.surfaceNeutral2, radius: theme.radius.xl, padding: 0) {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                VStack(alignment: .leading, spacing: theme.spacing.sm) {
                    DSText("Hristo Hristov", style: theme.typography.h4, color: theme.colors.textNeutral9)

                    (
                        Text("Sports superhero. Training for the office chair Olympics and holds the world record in sock throwing... ")
                            .font(theme.typography.caption.font)
                        + Text("read more")
                            .font(theme.typography.label.font)
                    )
                    .tracking(theme.typography.caption.tracking)
                    .foregroundStyle(theme.colors.textNeutral9)
                }

                socialStatsRow
            }
            .padding(.top, theme.spacing.xxxl)
            .padding(.bottom, theme.spacing.xl)
            .padding(.horizontal, theme.spacing.xl)
        }
    }

    // MARK: - Social Stats Row

    private var socialStatsRow: some View {
        HStack(spacing: 0) {
            statColumn(value: "1,200", label: "photos", showDivider: true)
            statColumn(value: "2,980", label: "followers", showDivider: true)
            statColumn(value: "1,600", label: "following", showDivider: false)
        }
        .foregroundStyle(theme.colors.textNeutral9)
    }

    private func statColumn(value: String, label: String, showDivider: Bool) -> some View {
        VStack(alignment: .center, spacing: 0) {
            DSText(value, style: theme.typography.largeSemiBold, color: theme.colors.textNeutral9)
            DSText(label, style: theme.typography.small, color: theme.colors.textNeutral9.opacity(theme.colors.textOpacity50))
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, theme.spacing.md)
        .padding(.vertical, theme.spacing.xs)
        .overlay(alignment: .trailing) {
            if showDivider {
                Rectangle()
                    .fill(theme.colors.textNeutral9)
                    .frame(width: 1)
            }
        }
    }

    // MARK: - Stats Card

    private var statsCard: some View {
        DSCard(background: theme.colors.surfacePrimary100, radius: theme.radius.xl, padding: 0) {
            HStack(alignment: .center, spacing: 0) {
                VStack(alignment: .leading, spacing: theme.spacing.lg) {
                    VStack(alignment: .leading, spacing: 0) {
                        DSText("560 done", style: theme.typography.largeSemiBold, color: theme.colors.textNeutral0_5)
                        DSText("268 works in progress", style: theme.typography.small, color: theme.colors.textNeutral0_5)
                    }
                    miniBarChart
                }

                Spacer()

                DSProgressCircle(
                    progress: 0.5, size: 86, lineWidth: 6, customLabel: "560",
                    trackColor: theme.colors.textNeutral0_5.opacity(0.08),
                    progressColor: theme.colors.textNeutral0_5,
                    labelColor: theme.colors.textNeutral0_5
                )

                Spacer()

                DSText("March 12, 2030", style: theme.typography.small, color: theme.colors.textNeutral0_5)
                    .fixedSize()
                    .rotationEffect(.degrees(-90))
                    .frame(width: 18, height: 81)
            }
            .padding(theme.spacing.xl)
        }
    }

    private var miniBarChart: some View {
        HStack(alignment: .bottom, spacing: theme.spacing.xs) {
            miniDot(color: theme.colors.surfaceSecondary100)
            miniDot(color: theme.colors.surfaceSecondary100)
            miniBar(color: theme.colors.surfaceSecondary100, height: 23)
            miniDot(color: theme.colors.surfaceNeutral0_5)
            miniDot(color: theme.colors.surfaceNeutral0_5)
            miniDot(color: theme.colors.surfaceNeutral0_5)
            miniDot(color: theme.colors.surfaceNeutral0_5)
            miniDot(color: theme.colors.surfaceNeutral0_5)
        }
    }

    private func miniDot(color: Color) -> some View {
        Capsule().fill(color).frame(width: 4, height: 4)
    }

    private func miniBar(color: Color, height: CGFloat) -> some View {
        Capsule().fill(color).frame(width: 4, height: height)
    }

    // MARK: - List Card

    private var listCard: some View {
        DSCard(background: theme.colors.surfaceNeutral2, radius: theme.radius.xl, padding: 0) {
            VStack(spacing: 0) {
                DSListItem(overline: "April, 2030", headline: "12,380 reviews", metadata: "12K") {
                    DSProgressCircle(progress: 0.8, size: 40, progressColor: theme.colors.surfaceSecondary100)
                } trailing: {
                    DSButton(style: .text, size: .medium, systemIcon: "chart.line.uptrend.xyaxis") {}
                }

                DSDivider(style: .middle)

                DSListItem(overline: "March, 2030", headline: "560 works done", metadata: "560") {
                    DSProgressCircle(progress: 0.5, size: 40, progressColor: theme.colors.surfaceSecondary100)
                } trailing: {
                    DSButton(style: .text, size: .medium, systemIcon: "chart.line.uptrend.xyaxis") {}
                }

                DSDivider(style: .middle)

                DSListItem(overline: "February, 2030", headline: "28,560 reviews", metadata: "28K") {
                    DSProgressCircle(progress: 0.9, size: 40, progressColor: theme.colors.surfaceSecondary100)
                } trailing: {
                    DSButton(style: .text, size: .medium, systemIcon: "chart.line.uptrend.xyaxis") {}
                }
            }
            .padding(.vertical, theme.spacing.lg)
        }
    }
}

#Preview {
    Profile2Page()
        .previewThemed()
}
