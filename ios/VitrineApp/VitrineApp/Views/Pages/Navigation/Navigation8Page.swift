import SwiftUI
import DesignSystem

// MARK: - Navigation8Page

/// Figma: [Navigation] 8 (node 481:14196)
///
/// Demonstrates `DSSideMenuLayout` — a side drawer menu that reveals
/// when the user taps the menu button in the top app bar.
/// The current page content becomes the front card in a stacked
/// carousel effect, with ghost cards appearing behind it.
struct Navigation8Page: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    @State private var isMenuOpen = false

    var body: some View {
        DSSideMenuLayout(isOpen: $isMenuOpen) {
            menuContent
        } content: {
            galleryContent
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .dsTabBarHidden()
    }

    // MARK: - Menu Content

    private var menuContent: some View {
        DSNavigationMenu(items: [
                DSNavigationMenuItem(id: "messages", label: "Messages", icon: .replyToMessage),
                DSNavigationMenuItem(id: "trending", label: "Trending", icon: .activity),
                DSNavigationMenuItem(id: "bookmarks", label: "Bookmarks", icon: .bookmark),
                DSNavigationMenuItem(id: "gallery", label: "Gallery", icon: .mediaImageList, isSelected: true),
                DSNavigationMenuItem(id: "settings", label: "Settings", icon: .settings),
                DSNavigationMenuItem(id: "notifications", label: "Notifications", icon: .bellNotification),
                DSNavigationMenuItem(id: "people", label: "People", icon: .group),
                DSNavigationMenuItem(id: "places", label: "Places", icon: .mapPin)
            ])
            .profile(DSNavigationMenuProfile(
                image: "nav8_profile",
                name: "Hristo Hristov",
                subtitle: "Visual Designer"
            ))
        .padding(.leading, theme.spacing.sm)
        .frame(maxHeight: .infinity, alignment: .center)
        .background(theme.colors.surfaceNeutral05.ignoresSafeArea())
    }

    // MARK: - Gallery Content (the "front card")

    private var galleryContent: some View {
        VStack(spacing: 0) {
            DSTopAppBar(title: "Gallery") {
                DSButton {}.buttonStyle(.neutral).buttonSize(.medium).icon(.search)
            }.appBarStyle(.smallCentered).onBack { dismiss() }
            .overlay(alignment: .leading) {
                DSButton {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isMenuOpen.toggle()
                    }
                }.buttonStyle(.neutral).buttonSize(.medium).icon(.menuScale)
                .padding(.leading, theme.spacing.sm)
            }

            // Gallery grid placeholder
            ScrollView {
                LazyVGrid(
                    columns: [GridItem(.flexible(), spacing: theme.spacing.sm),
                              GridItem(.flexible(), spacing: theme.spacing.sm)],
                    spacing: theme.spacing.sm
                ) {
                    ForEach(0..<6, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: theme.radius.md)
                            .fill(theme.colors.surfaceNeutral2)
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
                .padding(.horizontal, theme.spacing.sm)
                .padding(.top, theme.spacing.sm)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.colors.surfaceNeutral05.ignoresSafeArea())
    }
}

#Preview {
    Navigation8Page()
        .previewThemed()
}
