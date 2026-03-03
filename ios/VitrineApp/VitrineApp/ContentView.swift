import SwiftUI
import DesignSystem

struct ContentView: View {
    @Binding var brand: Brand
    @Binding var style: Style
    @Environment(\.theme) private var theme

    var body: some View {
        TabView {
            ColorPaletteView()
                .tabItem {
                    Label("Colors", systemImage: "paintpalette")
                }

            TokenBrowserView()
                .tabItem {
                    Label("Tokens", systemImage: "slider.horizontal.3")
                }

            CombinationGridView()
                .tabItem {
                    Label("Grid", systemImage: "square.grid.4x3.fill")
                }

            ComponentShowcaseView()
                .tabItem {
                    Label("Components", systemImage: "cube")
                }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 12) {
                    Picker("Brand", selection: $brand) {
                        ForEach(Brand.allCases) { b in
                            Text(b.displayName).tag(b)
                        }
                    }
                    .pickerStyle(.menu)

                    Picker("Style", selection: $style) {
                        ForEach(Style.allCases) { s in
                            Text(s.displayName).tag(s)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
        }
        .background(theme.colors.surfaceNeutral0_5)
        .preferredColorScheme(theme.isDark ? .dark : .light)
    }
}
