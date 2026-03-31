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
            DSTopAppBar(title: "Profile") {
                DSButton {}.buttonStyle(.neutral).buttonSize(.medium).systemIcon("ellipsis.vertical")
            }.appBarStyle(.smallCentered).onBack { dismiss() }

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
        .background(theme.colors.surfaceNeutral05.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .dsTabBarHidden()
    }

    // MARK: - Picture + Info Section

    private var pictureInfoSection: some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom) {
                avatarPhoto
                Spacer()
                DSButton("Follow") {}.buttonStyle(.filledA).buttonSize(.medium).systemIcon("plus", position: .right)
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
        DSCard {
            Image("profile-photo-1")
                .resizable()
                .scaledToFill()
                .frame(width: 108, height: 108)
        }
        .cardRadius(theme.radius.md)
        .cardPadding(0)
    }

    private var profileInfoCard: some View {
        DSCard {
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
        .cardPadding(0)
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
        DSCard {
            HStack(alignment: .center, spacing: 0) {
                VStack(alignment: .leading, spacing: theme.spacing.lg) {
                    VStack(alignment: .leading, spacing: 0) {
                        DSText("560 done", style: theme.typography.largeSemiBold, color: theme.colors.textNeutral05)
                        DSText("268 works in progress", style: theme.typography.small, color: theme.colors.textNeutral05)
                    }
                    miniBarChart
                }

                Spacer()

                DSProgressCircle(progress: 0.5)
                    .circleSize(86)
                    .lineWidth(6)
                    .customLabel("560")
                    .trackColor(theme.colors.textNeutral05.opacity(0.08))
                    .progressColor(theme.colors.textNeutral05)
                    .labelColor(theme.colors.textNeutral05)

                Spacer()

                DSText("March 12, 2030", style: theme.typography.small, color: theme.colors.textNeutral05)
                    .fixedSize()
                    .rotationEffect(.degrees(-90))
                    .frame(width: 18, height: 81)
            }
            .padding(theme.spacing.xl)
        }
        .cardBackground(theme.colors.surfacePrimary100)
        .cardPadding(0)
    }

    private var miniBarChart: some View {
        HStack(alignment: .bottom, spacing: theme.spacing.xs) {
            miniDot(color: theme.colors.surfaceSecondary100)
            miniDot(color: theme.colors.surfaceSecondary100)
            miniBar(color: theme.colors.surfaceSecondary100, height: 23)
            miniDot(color: theme.colors.surfaceNeutral05)
            miniDot(color: theme.colors.surfaceNeutral05)
            miniDot(color: theme.colors.surfaceNeutral05)
            miniDot(color: theme.colors.surfaceNeutral05)
            miniDot(color: theme.colors.surfaceNeutral05)
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
        DSCard {
            VStack(spacing: 0) {
                DSListItem("12,380 reviews") {
                    DSProgressCircle(progress: 0.8).circleSize(40).progressColor(theme.colors.surfaceSecondary100)
                } trailing: {
                    DSButton {}.buttonStyle(.text).buttonSize(.medium).systemIcon("chart.line.uptrend.xyaxis")
                }
                .overline("April, 2030")
                .metadata("12K")

                DSDivider().dividerStyle(.middle)

                DSListItem("560 works done") {
                    DSProgressCircle(progress: 0.5).circleSize(40).progressColor(theme.colors.surfaceSecondary100)
                } trailing: {
                    DSButton {}.buttonStyle(.text).buttonSize(.medium).systemIcon("chart.line.uptrend.xyaxis")
                }
                .overline("March, 2030")
                .metadata("560")

                DSDivider().dividerStyle(.middle)

                DSListItem("28,560 reviews") {
                    DSProgressCircle(progress: 0.9).circleSize(40).progressColor(theme.colors.surfaceSecondary100)
                } trailing: {
                    DSButton {}.buttonStyle(.text).buttonSize(.medium).systemIcon("chart.line.uptrend.xyaxis")
                }
                .overline("February, 2030")
                .metadata("28K")
            }
            .padding(.vertical, theme.spacing.lg)
        }
        .cardPadding(0)
    }
}

#Preview {
    Profile2Page()
        .previewThemed()
}
