import SwiftUI
import DesignSystem

// MARK: - Profile8Page

/// Figma: [Profile] 8 (node 994:50937)
struct Profile8Page: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab = 0
    @State private var zoomedPhoto: String? = nil

    private let tabs: [DSIcon] = [.table2Columns, .movie, .play, .sparks, .hashtag]

    var body: some View {
        VStack(spacing: theme.spacing.sm) {
            DSTopAppBar(title: "Profile", style: .small, onBack: { dismiss() }) {
                DSButton(style: .text, size: .medium, icon: .moreVert) {}
            }
            ScrollView {
                VStack(spacing: theme.spacing.sm) {
                    heroImage
                    infoCard
                    iconTabBar
                    tabContent
                }
                .padding(.horizontal, theme.spacing.sm)
                .padding(.bottom, theme.spacing.sm)
            }
        }
        .background(theme.colors.surfaceNeutral0_5)
        .navigationBarBackButtonHidden(true)
        .dsTabBarHidden()
        .overlay {
            if let photo = zoomedPhoto {
                Color.black.opacity(0.85)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) { zoomedPhoto = nil }
                    }
                Image(photo)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding(theme.spacing.lg)
                    .transition(.scale(scale: 0.85).combined(with: .opacity))
                    .onTapGesture {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) { zoomedPhoto = nil }
                    }
            }
        }
    }

    // MARK: - Hero Image

    private var heroImage: some View {
        Color.clear
            .frame(maxWidth: .infinity)
            .frame(height: 170)
            .overlay(
                Image("p8_hero")
                    .resizable()
                    .scaledToFill()
            )
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))
    }

    // MARK: - Info Card

    private var infoCard: some View {
        DSCard(background: theme.colors.surfaceSecondary100, radius: theme.radius.xl, padding: 0) {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                VStack(alignment: .leading, spacing: theme.spacing.sm) {
                    DSText("Hristo Hristov",
                           style: theme.typography.h4,
                           color: theme.colors.textNeutral9)
                    DSText("Rockstar-in-training. Plays air guitar solos that even virtual fans cheer for.",
                           style: theme.typography.captionRegular,
                           color: theme.colors.textNeutral9)
                }
                HStack(spacing: 0) {
                    statCol("1,200", label: "photos", divider: true)
                    statCol("2,980", label: "followers", divider: true)
                    statCol("1,600", label: "following", divider: false)
                }
                HStack {
                    DSButton("Follow", style: .filledB, size: .medium, icon: .plus, iconPosition: .right) {}
                        .fixedSize()
                    Spacer()
                    DSButton("Message", style: .text, size: .medium, assetIcon: "icon_message_text", iconPosition: .right) {}
                        .fixedSize()
                }
            }
            .padding(theme.spacing.xl)
        }
    }

    private func statCol(_ value: String, label: String, divider: Bool) -> some View {
        VStack(alignment: .center, spacing: 0) {
            DSText(value,
                   style: theme.typography.largeSemiBold,
                   color: theme.colors.textNeutral9)
            DSText(label,
                   style: theme.typography.tiny,
                   color: theme.colors.textNeutral9)
                .opacity(0.5)
        }
        .frame(maxWidth: .infinity)
        .padding(theme.spacing.md)
        .overlay(alignment: .trailing) {
            if divider {
                Rectangle()
                    .fill(theme.colors.textNeutral9)
                    .frame(width: 1)
            }
        }
    }

    // MARK: - Icon Tab Bar

    private var iconTabBar: some View {
        HStack(spacing: 0) {
            ForEach(tabs.indices, id: \.self) { i in
                DSIconImage(tabs[i], size: 24, color: theme.colors.textNeutral0_5)
                    .opacity(selectedTab == i ? 1.0 : 0.5)
                    .padding(.vertical, theme.spacing.sm)
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) { selectedTab = i }
                    }
            }
        }
        .padding(.horizontal, theme.spacing.xl)
        .background(Capsule().fill(theme.colors.surfacePrimary100))
    }

    // MARK: - Tab Content

    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case 0:
            DSPhotoGrid(
                photos: ["p8_photo1", "p8_photo2", "p8_photo3",
                         "p8_photo4", "p8_photo5", "p8_photo6"],
                onTap: { photo in
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) { zoomedPhoto = photo }
                }
            )
        default:
            DSIconImage(tabs[selectedTab], size: 40, color: theme.colors.textNeutral9)
                .opacity(0.3)
                .frame(maxWidth: .infinity)
                .padding(.vertical, theme.spacing.xxl)
        }
    }
}

#Preview {
    Profile8Page()
        .previewThemed()
}
