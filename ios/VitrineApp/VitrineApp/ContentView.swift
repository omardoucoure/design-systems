import SwiftUI
import DesignSystem

struct ContentView: View {
    @Binding var brand: Brand
    @Binding var style: Style
    @Environment(\.theme) private var theme

    @State private var selectedTab = Tab.components

    private enum Tab: String, CaseIterable {
        case components, pages, colors, tokens, grid

        var label: LocalizedStringKey {
            switch self {
            case .components: return "Components"
            case .pages: return "Pages"
            case .colors: return "Colors"
            case .tokens: return "Tokens"
            case .grid: return "Grid"
            }
        }

        var systemIcon: String {
            switch self {
            case .components: return "cube"
            case .pages: return "doc.richtext"
            case .colors: return "paintpalette"
            case .tokens: return "slider.horizontal.3"
            case .grid: return "square.grid.4x3.fill"
            }
        }
    }

    private var tabs: [DSBottomBarItem] {
        Tab.allCases.map { DSBottomBarItem(id: $0.rawValue, label: $0.label, systemIcon: $0.systemIcon) }
    }

    private var selectedTabId: Binding<String> {
        Binding(
            get: { selectedTab.rawValue },
            set: { selectedTab = Tab(rawValue: $0) ?? .components }
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                NavigationStack {
                    ComponentShowcaseView()
                        .toolbar { brandStyleToolbar }
                }
                .opacity(selectedTab == .components ? 1 : 0)
                .allowsHitTesting(selectedTab == .components)

                NavigationStack {
                    PagesShowcaseView()
                        .toolbar { brandStyleToolbar }
                }
                .opacity(selectedTab == .pages ? 1 : 0)
                .allowsHitTesting(selectedTab == .pages)

                NavigationStack {
                    ColorPaletteView()
                        .toolbar { brandStyleToolbar }
                }
                .opacity(selectedTab == .colors ? 1 : 0)
                .allowsHitTesting(selectedTab == .colors)

                NavigationStack {
                    TokenBrowserView()
                        .toolbar { brandStyleToolbar }
                }
                .opacity(selectedTab == .tokens ? 1 : 0)
                .allowsHitTesting(selectedTab == .tokens)

                NavigationStack {
                    CombinationGridView()
                        .toolbar { brandStyleToolbar }
                }
                .opacity(selectedTab == .grid ? 1 : 0)
                .allowsHitTesting(selectedTab == .grid)
            }
            .frame(maxHeight: .infinity)

            DSBottomAppBar(items: tabs, selectedId: selectedTabId, style: .labeled)
                .background(theme.colors.surfaceNeutral2)
        }
        .ignoresSafeArea(.keyboard)
        .preferredColorScheme(style.isDark ? .dark : .light)
    }

    @ToolbarContentBuilder
    private var brandStyleToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
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

        ToolbarItem(placement: .topBarTrailing) {
            HStack(spacing: 12) {
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
}

#Preview {
    ContentView(brand: .constant(.coralCamo), style: .constant(.lightRounded))
        .previewThemed()
}
