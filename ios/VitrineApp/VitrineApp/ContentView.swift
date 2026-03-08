import SwiftUI
import DesignSystem

struct ContentView: View {
    @Binding var brand: Brand
    @Binding var style: Style
    @Environment(\.theme) private var theme

    @State private var selectedTab = "components"
    @State private var barStyle: DSBottomAppBarStyle = .labeled

    private let tabs: [DSBottomBarItem] = [
        DSBottomBarItem(id: "components", label: "Components", systemIcon: "cube"),
        DSBottomBarItem(id: "pages", label: "Pages", systemIcon: "doc.richtext"),
        DSBottomBarItem(id: "colors", label: "Colors", systemIcon: "paintpalette"),
        DSBottomBarItem(id: "tokens", label: "Tokens", systemIcon: "slider.horizontal.3"),
        DSBottomBarItem(id: "grid", label: "Grid", systemIcon: "square.grid.4x3.fill"),
    ]

    var body: some View {
        DSTabView(selection: $selectedTab, tabs: tabs, style: barStyle) {
            NavigationStack {
                ComponentShowcaseView()
                    .toolbar { brandStyleToolbar }
            }
            .tag("components")

            NavigationStack {
                PagesShowcaseView()
                    .toolbar { brandStyleToolbar }
            }
            .tag("pages")

            NavigationStack {
                ColorPaletteView()
                    .toolbar { brandStyleToolbar }
            }
            .tag("colors")

            NavigationStack {
                TokenBrowserView()
                    .toolbar { brandStyleToolbar }
            }
            .tag("tokens")

            NavigationStack {
                CombinationGridView()
                    .toolbar { brandStyleToolbar }
            }
            .tag("grid")
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
