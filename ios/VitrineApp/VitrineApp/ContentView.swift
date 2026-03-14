import SwiftUI
import DesignSystem

struct ContentView: View {
    @Binding var brand: Brand
    @Binding var style: Style
    @Environment(\.theme) private var theme

    @State private var selectedTab = "components"
    @State private var barStyle: DSBottomAppBarStyle = .labeled
    @State private var isMenuOpen = false

    private let tabs: [DSBottomBarItem] = [
        DSBottomBarItem(id: "components", label: "Components", systemIcon: "cube"),
        DSBottomBarItem(id: "pages", label: "Pages", systemIcon: "doc.richtext"),
        DSBottomBarItem(id: "colors", label: "Colors", systemIcon: "paintpalette"),
        DSBottomBarItem(id: "tokens", label: "Tokens", systemIcon: "slider.horizontal.3"),
        DSBottomBarItem(id: "grid", label: "Grid", systemIcon: "square.grid.4x3.fill"),
    ]

    private var menuItems: [DSNavigationMenuItem] {
        [
            DSNavigationMenuItem(id: "components", label: "Components", icon: .cube, isSelected: selectedTab == "components"),
            DSNavigationMenuItem(id: "pages", label: "Pages", icon: .page, isSelected: selectedTab == "pages"),
            DSNavigationMenuItem(id: "colors", label: "Colors", icon: .palette, isSelected: selectedTab == "colors"),
            DSNavigationMenuItem(id: "tokens", label: "Tokens", icon: .settings, isSelected: selectedTab == "tokens"),
            DSNavigationMenuItem(id: "grid", label: "Grid", icon: .viewGrid, isSelected: selectedTab == "grid"),
        ]
    }

    var body: some View {
        DSSideMenuLayout(isOpen: $isMenuOpen) {
            sideMenuContent
        } content: {
            DSTabView(selection: $selectedTab, tabs: tabs, styleBinding: $barStyle) {
                ZStack {
                    NavigationStack {
                        ComponentShowcaseView()
                            .toolbar { brandStyleToolbar }
                    }
                    .opacity(selectedTab == "components" ? 1 : 0)

                    NavigationStack {
                        PagesShowcaseView()
                            .toolbar { brandStyleToolbar }
                    }
                    .opacity(selectedTab == "pages" ? 1 : 0)

                    NavigationStack {
                        ColorPaletteView()
                            .toolbar { brandStyleToolbar }
                    }
                    .opacity(selectedTab == "colors" ? 1 : 0)

                    NavigationStack {
                        TokenBrowserView()
                            .toolbar { brandStyleToolbar }
                    }
                    .opacity(selectedTab == "tokens" ? 1 : 0)

                    NavigationStack {
                        CombinationGridView()
                            .toolbar { brandStyleToolbar }
                    }
                    .opacity(selectedTab == "grid" ? 1 : 0)
                }
            }
        }
        .ignoresSafeArea(.keyboard)
        .preferredColorScheme(style.isDark ? .dark : .light)
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

    @ToolbarContentBuilder
    private var brandStyleToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            HStack(spacing: 8) {
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) { isMenuOpen.toggle() }
                } label: {
                    Image(systemName: "line.3.horizontal")
                }

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
                    HStack(spacing: 4) {
                        Image(systemName: "paintbrush")
                        Text(brand.displayName)
                            .font(.subheadline.weight(.medium))
                    }
                }
            }
        }

        ToolbarItem(placement: .topBarTrailing) {
            HStack(spacing: 12) {
                Menu {
                    ForEach(DSBottomAppBarStyle.allCases, id: \.self) { s in
                        Button {
                            barStyle = s
                        } label: {
                            if s == barStyle {
                                Label(barStyleName(s), systemImage: "checkmark")
                            } else {
                                Text(barStyleName(s))
                            }
                        }
                    }
                } label: {
                    Image(systemName: barStyleIcon)
                }

                Button {
                    style = Style(isDark: !style.isDark, isSharp: style.isSharp)
                } label: {
                    Image(systemName: style.isDark ? "moon.fill" : "sun.max.fill")
                }

                Button {
                    style = Style(isDark: style.isDark, isSharp: !style.isSharp)
                } label: {
                    Image(systemName: style.isSharp ? "square" : "square.on.circle")
                }
            }
        }
    }
    private var barStyleIcon: String {
        switch barStyle {
        case .labeled: return "dock.rectangle"
        case .full: return "dock.arrow.up.rectangle"
        case .floating: return "capsule"
        }
    }

    private func barStyleName(_ s: DSBottomAppBarStyle) -> String {
        switch s {
        case .labeled: return "Labeled"
        case .full: return "Full"
        case .floating: return "Floating"
        }
    }
}

#Preview {
    ContentView(brand: .constant(.coralCamo), style: .constant(.lightRounded))
        .previewThemed()
}
