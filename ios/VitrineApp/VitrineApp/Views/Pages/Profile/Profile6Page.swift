import SwiftUI
import DesignSystem

// MARK: - Profile6Page

/// Figma: [Profile] 6 (node 328:12548)
///
/// Full-width hero image overlapping a single profile info card with name, bio,
/// divider, social stats, Follow + social icon CTAs, and a scrollable photo strip
/// that overflows the card's right edge.
struct Profile6Page: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: theme.spacing.sm) {
            DSTopAppBar(title: "Profile") {
                DSButton {}.buttonStyle(.text).buttonSize(.medium).icon(.moreVert)
            }.onBack { dismiss() }

            ScrollView {
                ZStack(alignment: .top) {
                    // Hero image — 280pt tall, overlaps card below by 91pt
                    Color.clear
                        .frame(maxWidth: .infinity)
                        .frame(height: 280)
                        .overlay(
                            Image("profile6_hero")
                                .resizable()
                                .scaledToFill()
                        )
                        .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))

                    // Single card — clipsContent: false so the photo scroll overflows right edge
                    DSCard {
                        VStack(alignment: .leading, spacing: theme.spacing.xl) {
                            // Name + bio + divider + stats
                            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                                VStack(alignment: .leading, spacing: theme.spacing.sm) {
                                    DSText("Hristo Hristov",
                                           style: theme.typography.h4, color: theme.colors.textNeutral9)
                                    DSText("Rockstar-in-training. Plays air guitar solos that even virtual fans cheer for.",
                                           style: theme.typography.bodyRegular, color: theme.colors.textNeutral9)
                                }
                                DSDivider()
                                HStack(spacing: 0) {
                                    statCol("1,200", label: "photos")
                                    statCol("2,980", label: "followers")
                                    statCol("1,600", label: "following")
                                }
                            }
                            .padding(.horizontal, theme.spacing.xl)

                            // CTAs — Follow + social icons in a nested white card
                            DSCard {
                                HStack {
                                    DSButton("Follow") {}.buttonStyle(.filledA).buttonSize(.medium).icon(.plus, position: .right)
                                        .fixedSize()
                                    Spacer()
                                    HStack(spacing: theme.spacing.lg) {
                                        DSButton {}.buttonStyle(.text).buttonSize(.medium).assetIcon("icon_instagram")
                                        DSButton {}.buttonStyle(.text).buttonSize(.medium).assetIcon("icon_facebook")
                                        DSButton {}.buttonStyle(.text).buttonSize(.medium).assetIcon("icon_x")
                                    }
                                }
                            }
                            .cardBackground(theme.colors.surfaceNeutral05)
                            .cardRadius(theme.radius.lg)
                            .cardPadding(theme.spacing.lg)
                            .padding(.horizontal, theme.spacing.xl)

                            // Photo strip — no right padding so scroll bleeds past card edge
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: theme.spacing.sm) {
                                    ForEach(["profile6_photo1", "profile6_photo2", "profile6_photo3",
                                             "profile6_photo4", "profile6_photo5"], id: \.self) { name in
                                        Image(name)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 88, height: 88)
                                            .clipShape(RoundedRectangle(cornerRadius: theme.radius.md))
                                    }
                                }
                                .padding(.leading, theme.spacing.xl)
                                .padding(.trailing, theme.spacing.xl)
                            }
                            .padding(.bottom, theme.spacing.xl)
                        }
                        .padding(.top, theme.spacing.xl)
                    }
                    .cardPadding(0)
                    .clipsContent(false)
                    .padding(.top, 189) // 280 hero - 91 overlap
                }
                .padding(.horizontal, theme.spacing.sm)
                .padding(.bottom, theme.spacing.sm)
            }
        }
        .background(theme.colors.surfaceNeutral05.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .dsTabBarHidden()
    }

    private func statCol(_ value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            DSText(value, style: theme.typography.largeSemiBold, color: theme.colors.textNeutral9)
            DSText(label, style: theme.typography.smallRegular, color: theme.colors.textNeutral9)
                .opacity(0.75)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    Profile6Page()
        .previewThemed()
}
