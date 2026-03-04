import SwiftUI
import DesignSystem

struct ContentView: View {
    @Binding var brand: Brand
    @Binding var style: Style
    @Environment(\.theme) private var theme

    var body: some View {
        NavigationStack {
            TabView {
                ComponentShowcaseView()
                    .tabItem {
                        Label("Components", systemImage: "cube")
                    }

                PagesShowcaseView()
                    .tabItem {
                        Label("Pages", systemImage: "doc.richtext")
                    }

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
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
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
                        // Dark mode toggle
                        Button {
                            let dark = !style.isDark
                            let sharp = style.isSharp
                            switch (dark, sharp) {
                            case (false, false): style = .lightRounded
                            case (true, false): style = .darkRounded
                            case (false, true): style = .lightSharp
                            case (true, true): style = .darkSharp
                            }
                        } label: {
                            Image(systemName: style.isDark ? "moon.fill" : "sun.max.fill")
                        }

                        // Shape toggle
                        Button {
                            let dark = style.isDark
                            let sharp = !style.isSharp
                            switch (dark, sharp) {
                            case (false, false): style = .lightRounded
                            case (true, false): style = .darkRounded
                            case (false, true): style = .lightSharp
                            case (true, true): style = .darkSharp
                            }
                        } label: {
                            Image(systemName: style.isSharp ? "square" : "square.on.circle")
                        }
                    }
                }
            }
        }
        .preferredColorScheme(style.isDark ? .dark : .light)
    }
}

#Preview {
    ContentView(brand: .constant(.coralCamo), style: .constant(.lightRounded))
        .previewThemed()
}
