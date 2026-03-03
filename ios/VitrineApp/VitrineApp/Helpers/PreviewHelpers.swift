import SwiftUI
import DesignSystem

extension View {
    /// Preview with a specific brand/style combination.
    func previewThemed(brand: Brand = .coralCamo, style: Style = .lightRounded) -> some View {
        self.designSystem(brand: brand, style: style)
    }

    /// Preview all 16 brand/style combinations in a grid.
    func previewAllCombinations() -> some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(Brand.allCases) { brand in
                    ForEach(Style.allCases) { style in
                        self
                            .designSystem(brand: brand, style: style)
                            .frame(height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                VStack {
                                    Spacer()
                                    Text("\(brand.displayName) / \(style.displayName)")
                                        .font(.caption2)
                                        .padding(4)
                                        .background(.ultraThinMaterial)
                                        .clipShape(Capsule())
                                }
                                .padding(4)
                            )
                    }
                }
            }
            .padding()
        }
    }
}
