import SwiftUI
import DesignSystem

struct ContentView: View {
    @Binding var brand: Brand
    @Binding var style: Style

    @State private var selectedTab = "components"

    var body: some View {
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
        .ignoresSafeArea(.keyboard)
        .preferredColorScheme(style.isDark ? .dark : .light)
    }

    // MARK: - Toolbar

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
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
}

#Preview {
    ContentView(brand: .constant(.coralCamo), style: .constant(.lightRounded))
        .previewThemed()
}
