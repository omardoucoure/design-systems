import SwiftUI
import DesignSystem

// MARK: - Navigation3Page

/// Figma: [Navigation] 3 (node 946:244993)
///
/// Same side drawer pattern as Navigation 8, but the menu uses a
/// vertical icon-only sidebar (`DSIconSidebar`) instead of `DSNavigationMenu`.
struct Navigation3Page: View {
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
        DSIconSidebar(sections: [
                DSIconSidebarSection(items: [
                    DSIconSidebarItem(id: "cart", icon: .cart),
                    DSIconSidebarItem(id: "activity", icon: .activity),
                    DSIconSidebarItem(id: "mapPin", icon: .mapPin),
                    DSIconSidebarItem(id: "gallery", icon: .mediaImageList, isSelected: true),
                    DSIconSidebarItem(id: "notifications", icon: .bellNotification),
                    DSIconSidebarItem(id: "people", icon: .group),
                ]),
                DSIconSidebarSection(items: [
                    DSIconSidebarItem(id: "search", icon: .search),
                    DSIconSidebarItem(id: "settings", icon: .settings),
                ]),
                DSIconSidebarSection(items: [
                    DSIconSidebarItem(id: "logout", icon: .logOut),
                ]),
            ])
            .avatar(Image("nav3_avatar"))
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
    Navigation3Page()
        .previewThemed()
}
