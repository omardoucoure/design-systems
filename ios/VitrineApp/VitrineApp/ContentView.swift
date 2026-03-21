import SwiftUI
import DesignSystem

struct ContentView: View {
    @Binding var brand: Brand
    @Binding var style: Style
    @Environment(\.theme) private var theme

    @State private var selectedTab = "components"
    @State private var isMenuOpen = false

    private var menuItems: [DSNavigationMenuItem] {
        [
            DSNavigationMenuItem(id: "components", label: "Components", icon: .cube, isSelected: selectedTab == "components"),
            DSNavigationMenuItem(id: "pages", label: "Pages", icon: .page, isSelected: selectedTab == "pages"),
            DSNavigationMenuItem(id: "colors", label: "Colors", icon: .palette, isSelected: selectedTab == "colors"),
            DSNavigationMenuItem(id: "tokens", label: "Tokens", icon: .settings, isSelected: selectedTab == "tokens"),
            DSNavigationMenuItem(id: "icons", label: "Icons", icon: .star, isSelected: selectedTab == "icons"),
        ]
    }

    var body: some View {
        DSSideMenuLayout(isOpen: $isMenuOpen) {
            sideMenuContent
        } content: {
            TabView(selection: $selectedTab) {
                NavigationStack {
                    ComponentShowcaseView()
                        .toolbar { toolbarContent }
                }
                .tabItem { Label("Components", systemImage: "cube") }
                .tag("components")

                NavigationStack {
                    PagesShowcaseView()
                        .toolbar { toolbarContent }
                }
                .tabItem { Label("Pages", systemImage: "doc.richtext") }
                .tag("pages")

                NavigationStack {
                    ColorPaletteView()
                        .toolbar { toolbarContent }
                }
                .tabItem { Label("Colors", systemImage: "paintpalette") }
                .tag("colors")

                NavigationStack {
                    TokenBrowserView()
                        .toolbar { toolbarContent }
                }
                .tabItem { Label("Tokens", systemImage: "slider.horizontal.3") }
                .tag("tokens")

                NavigationStack {
                    IconBrowserView()
                        .toolbar { toolbarContent }
                }
                .tabItem { Label("Icons", systemImage: "square.grid.3x3") }
                .tag("icons")
            }
        }
        .ignoresSafeArea(.keyboard)
        .preferredColorScheme(style.isDark ? .dark : .light)
    }

    // MARK: - Toolbar

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                withAnimation(.easeInOut(duration: 0.3)) { isMenuOpen.toggle() }
            } label: {
                Image(systemName: "line.3.horizontal")
            }
        }

        ToolbarItem(placement: .topBarTrailing) {
            HStack(spacing: 12) {
                Menu {
                    ForEach(Brand.allCases) { b in
                        Button {
                            brand = b
                        } label: {
                            if b == brand {
                                Label(b.displayName, systemImage: "checkmark")
                            } else {
                                Text(b.displayName)
                            }
                        }
                    }
                } label: {
                    Image(systemName: "paintbrush")
                }

                Menu {
                    Button {
                        style = Style(isDark: !style.isDark, isSharp: style.isSharp)
                    } label: {
                        Label(style.isDark ? "Light Mode" : "Dark Mode",
                              systemImage: style.isDark ? "sun.max.fill" : "moon.fill")
                    }
                    Button {
                        style = Style(isDark: style.isDark, isSharp: !style.isSharp)
                    } label: {
                        Label(style.isSharp ? "Rounded" : "Sharp",
                              systemImage: style.isSharp ? "square.on.circle" : "square")
                    }
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
    }

    // MARK: - Side Menu

    private var sideMenuContent: some View {
        DSNavigationMenu(
            items: menuItems,
            onSelect: { id in
                selectedTab = id
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isMenuOpen = false
                    }
                }
            }
        )
        .padding(.leading, theme.spacing.sm)
        .frame(maxHeight: .infinity, alignment: .center)
        .background(theme.colors.surfaceNeutral0_5)
    }
}

#Preview {
    ContentView(brand: .constant(.coralCamo), style: .constant(.lightRounded))
        .previewThemed()
}
