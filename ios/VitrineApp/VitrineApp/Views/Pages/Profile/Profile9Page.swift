import SwiftUI
import DesignSystem

// MARK: - Profile9Page

/// Figma: [Profile] 9 (node 319:27467)
///
/// Hero image offset to the right (pr=64), info card offset to the left (pl=64)
/// overlapping the image by 80pt. Icon tab bar + photo grid below.
struct Profile9Page: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss
    @State private var isMenuOpen = false
    @State private var selectedTab = 0
    @State private var zoomedPhoto: String? = nil

    private let tabs: [DSIcon] = [.table2Columns, .movie, .play, .sparks, .hashtag]

    var body: some View {
        DSSideMenuLayout(isOpen: $isMenuOpen) {
            sideMenuContent
        } content: {
            mainContent
        }
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

    private var sideMenuContent: some View {
        DSNavigationMenu(
            items: [
                DSNavigationMenuItem(id: "profile", label: "Profile", icon: .user, isSelected: true),
                DSNavigationMenuItem(id: "messages", label: "Messages", icon: .replyToMessage),
                DSNavigationMenuItem(id: "bookmarks", label: "Bookmarks", icon: .bookmark),
                DSNavigationMenuItem(id: "settings", label: "Settings", icon: .settings),
                DSNavigationMenuItem(id: "notifications", label: "Notifications", icon: .bellNotification),
                DSNavigationMenuItem(id: "people", label: "People", icon: .group),
            ],
            profile: DSNavigationMenuProfile(
                image: "p9_hero",
                name: "Hristo Hristov",
                subtitle: "Rockstar-in-training"
            )
        )
        .padding(.leading, theme.spacing.sm)
        .frame(maxHeight: .infinity, alignment: .center)
        .background(theme.colors.surfaceNeutral0_5)
    }

    private var mainContent: some View {
        VStack(spacing: theme.spacing.sm) {
            DSTopAppBar(title: "Profile", style: .small, onBack: { dismiss() }) {
                DSButton(style: .text, size: .medium, icon: .menuScale) {
                    withAnimation(.easeInOut(duration: 0.3)) { isMenuOpen.toggle() }
                }
            }

            ScrollView {
                VStack(spacing: theme.spacing.sm) {
                    heroAndInfo
                    iconTabBar
                    tabContent
                }
                .padding(.horizontal, theme.spacing.sm)
                .padding(.bottom, theme.spacing.sm)
            }
        }
        .background(theme.colors.surfaceNeutral0_5)
    }

    // MARK: - Hero + Info overlap

    private var heroAndInfo: some View {
        // Hero image: right edge flush, pr=64 inset on left → offset left by 64
        // Info card: left edge flush, pl=64 inset on right → offset right by 64
        // Info card overlaps hero by 80pt (mb=[-80] on hero in Figma)
        VStack(spacing: 0) {
            // Hero image — pr=64 in Figma → inset on the RIGHT, image sits on the LEFT
            Color.clear
                .frame(maxWidth: .infinity)
                .frame(height: 267)
                .overlay(
                    Image("p9_hero")
                        .resizable()
                        .scaledToFill()
                )
                .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))
                .padding(.trailing, theme.spacing.xxxxl) // 64pt inset on right

            // Info card — pl=64 in Figma → inset on the LEFT, card sits on the RIGHT
            DSCard(background: theme.colors.surfaceNeutral2, radius: theme.radius.xl, padding: 0) {
                VStack(alignment: .leading, spacing: theme.spacing.lg) {
                    VStack(alignment: .leading, spacing: theme.spacing.sm) {
                        DSText("Hristo Hristov",
                               style: theme.typography.h4,
                               color: theme.colors.textNeutral9)
                        DSText("Rockstar-in-training. Plays air guitar solos that even virtual fans cheer for.",
                               style: theme.typography.captionRegular,
                               color: theme.colors.textNeutral9)
                    }
                    statsRow
                    ctaRow
                }
                .padding(theme.spacing.xl)
            }
            .padding(.leading, theme.spacing.xxxxl) // 64pt inset on left
            .padding(.top, -theme.spacing.xxxxl - theme.spacing.md) // overlap 80pt up
        }
    }

    // MARK: - Stats

    private var statsRow: some View {
        HStack(spacing: 0) {
            statCol("1,200", label: "photos", divider: true)
            statCol("2,980", label: "followers", divider: true)
            statCol("1,600", label: "following", divider: false)
        }
        .overlay(
            RoundedRectangle(cornerRadius: theme.radius.md)
                .stroke(theme.colors.borderNeutral2, lineWidth: 1)
        )
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

    // MARK: - CTAs

    private var ctaRow: some View {
        HStack {
            DSButton("Follow", style: .filledB, size: .medium, icon: .plus, iconPosition: .right) {}
                .fixedSize()
            Spacer()
            DSButton("Message", style: .text, size: .medium, assetIcon: "icon_message_text", iconPosition: .right) {}
                .fixedSize()
        }
    }

    // MARK: - Icon Tab Bar

    private var iconTabBar: some View {
        HStack(spacing: 0) {
            ForEach(tabs.indices, id: \.self) { i in
                DSIconImage(tabs[i], size: 24, color: theme.colors.textNeutral9)
                    .opacity(selectedTab == i ? 1.0 : 0.5)
                    .padding(.vertical, theme.spacing.xs)
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) { selectedTab = i }
                    }
            }
        }
    }

    // MARK: - Tab Content

    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case 0:
            DSPhotoGrid(
                photos: ["p9_photo1", "p9_photo2", "p9_photo3",
                         "p9_photo4", "p9_photo5", "p9_photo6",
                         "p9_photo7", "p9_photo8"],
                style: .compact(columns: 4),
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
    Profile9Page()
        .previewThemed()
}
