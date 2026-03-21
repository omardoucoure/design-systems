import SwiftUI
import DesignSystem

// MARK: - ShoppingStart4Page

/// Figma: [Shopping] Start - 4 (node 731:28359)
///
/// Shopping start page with greeting top bar, segmented category picker,
/// New Arrivals product row, and 60% off promotional card.
struct ShoppingStart4Page: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    @State private var categoryIndex = 0

    var body: some View {
        VStack(spacing: 0) {
            topAppBar

            ScrollView(showsIndicators: false) {
                VStack(spacing: theme.spacing.sm) {
                    categoryPicker

                    newArrivalsSection

                    saleCard
                }
                .padding(.horizontal, theme.spacing.sm)
            }
        }
        .background(theme.colors.surfaceNeutral0_5.ignoresSafeArea())
        .navigationBarBackButtonHidden(false)
    }

    // MARK: - Top App Bar

    private var topAppBar: some View {
        DSTopAppBar(
            title: "Hello Hristo",
            leadingImage: {
                Image("shop4_avatar", bundle: .main)
                    .resizable()
                    .scaledToFill()
            },
            actions: {
                DSButton("Him", style: .neutral, size: .medium, icon: .male, iconPosition: .right) {}
            }
        )
    }

    // MARK: - Category Picker

    private var categoryPicker: some View {
        DSSegmentedPicker(
            items: ["Shoes", "Clothing", "Accessories"],
            selectedIndex: $categoryIndex,
            style: .pills
        )
    }

    // MARK: - New Arrivals

    private var newArrivalsSection: some View {
        DSCard(background: theme.colors.surfaceNeutral2, radius: theme.radius.xl, padding: theme.spacing.xl) {
            VStack(spacing: theme.spacing.md) {
                // Header row
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("New Arrivals")
                            .font(theme.typography.h6.font)
                            .tracking(theme.typography.h6.tracking)
                            .foregroundStyle(theme.colors.textNeutral9)

                        Text("6.368 Items")
                            .font(theme.typography.small.font)
                            .tracking(theme.typography.small.tracking)
                            .foregroundStyle(theme.colors.textNeutral9)
                            .opacity(0.5)
                    }

                    Spacer()

                    DSButton("See all", style: .outlined, size: .small) {}
                }

                // Products row
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: theme.spacing.sm) {
                        DSProductCard(
                            image: "shop4_product1",
                            brand: "Roa® Andreas",
                            subtitle: "Hybrid Boots",
                            price: "$282",
                            originalPrice: "$470",
                            discount: "40%",
                            photoWidth: 140,
                            photoHeight: 180
                        )

                        DSProductCard(
                            image: "shop4_product2",
                            brand: "Roa® CVO",
                            subtitle: "High-Top Sneakers",
                            price: "$192",
                            originalPrice: "$320",
                            discount: "40%",
                            photoWidth: 140,
                            photoHeight: 180
                        )

                        DSProductCard(
                            image: "shop4_product3",
                            brand: "Roa® Katharina",
                            subtitle: "Approach Shoes",
                            price: "$412",
                            originalPrice: "$430",
                            discount: "40%",
                            photoWidth: 140,
                            photoHeight: 180
                        )
                    }
                }
            }
        }
    }

    // MARK: - Sale Card

    private var saleCard: some View {
        DSCard(background: theme.colors.surfacePrimary100, radius: theme.radius.xl, padding: 0) {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("60% off")
                        .font(.system(size: 48, weight: .medium))
                        .tracking(-2.4)
                        .foregroundStyle(theme.colors.textNeutral0_5)

                    HStack(alignment: .bottom) {
                        Text("Orders over $200")
                            .font(theme.typography.label.font)
                            .tracking(theme.typography.label.tracking)
                            .foregroundStyle(theme.colors.textNeutral0_5)

                        Spacer()

                        miniBarChart
                    }
                }

                // Delivery pill
                Text("Free standard Delivery on Orders over $200")
                    .font(theme.typography.small.font)
                    .tracking(theme.typography.small.tracking)
                    .foregroundStyle(theme.colors.textNeutral0_5)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(24)
                    .background(theme.colors.surfacePrimary120)
                    .clipShape(Capsule())
            }
            .padding(theme.spacing.xl)
        }
    }

    // MARK: - Mini Bar Chart (decorative)

    private var miniBarChart: some View {
        let heights: [CGFloat] = [29, 39, 24, 14, 21, 19, 15, 28, 11, 26, 43, 55, 34]
        let opacities: [Double] = [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1, 1, 1, 1, 1, 1]

        return HStack(alignment: .bottom, spacing: 0) {
            ForEach(Array(zip(heights.indices, heights)), id: \.0) { index, height in
                RoundedRectangle(cornerRadius: theme.radius.xxs)
                    .fill(theme.colors.textSecondary100)
                    .opacity(opacities[index])
                    .frame(width: 4, height: height)
                    .frame(maxWidth: .infinity)
            }
        }
        .frame(width: 144)
    }
}

#Preview {
    ShoppingStart4Page()
        .previewThemed()
}
