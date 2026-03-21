import SwiftUI
import DesignSystem

// MARK: - ShoppingStart5Page

/// Figma: [Shopping] Start - 5 (node 709:69092)
///
/// Shopping start page with greeting top bar, gender picker,
/// two horizontal product teaser rows, and a bottom app bar.
struct ShoppingStart5Page: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    @State private var selectedGender = 1

    var body: some View {
        VStack(spacing: 0) {
            topAppBar

            ScrollView(showsIndicators: false) {
                VStack(spacing: theme.spacing.sm) {
                    picker

                    DSProductTeaser(products: teaserRow1)

                    DSProductTeaser(products: teaserRow2)
                }
            }
            .padding(.horizontal, theme.spacing.sm)
        }
        .background(theme.colors.surfaceNeutral0_5.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .dsTabBarHidden()
    }

    // MARK: - Top App Bar

    private var topAppBar: some View {
        DSTopAppBar(title: "Hello Hristo", style: .smallCentered, onBack: { dismiss() }) {
            DSButton(style: .neutral, size: .medium, icon: .bellNotification) {}
        }
    }

    // MARK: - Gender Picker

    private var picker: some View {
        HStack {
            DSIconSegmentedPicker(
                items: [
                    DSIconSegmentedPickerItem(id: 0, icon: .female),
                    DSIconSegmentedPickerItem(id: 1, label: "Him", icon: .male)
                ],
                selectedId: $selectedGender
            )

            Spacer()
        }
        .padding(.bottom, theme.spacing.sm)
    }

    // MARK: - Data

    private var teaserRow1: [DSProductTeaserItem] {
        [
            DSProductTeaserItem(
                image: "shop_product1",
                brand: "Roa® Synthetic",
                subtitle: "Hooded Down Jacket",
                price: "$585",
                originalPrice: "$590",
                discount: "10%"
            ),
            DSProductTeaserItem(
                image: "shop_product2",
                brand: "Roa® Seamless",
                subtitle: "Long Sleeve Sweater",
                price: "$225",
                originalPrice: "$250",
                discount: "10%"
            )
        ]
    }

    private var teaserRow2: [DSProductTeaserItem] {
        [
            DSProductTeaserItem(
                image: "shop_product3",
                brand: "Roa® Corduroy",
                subtitle: "Hooded Corduroy Jacket",
                price: "$585",
                originalPrice: "$590",
                discount: "10%"
            ),
            DSProductTeaserItem(
                image: "shop_product4",
                brand: "Roa® Windbreaker",
                subtitle: "Windbreaker Jacket",
                price: "$550"
            )
        ]
    }
}

#Preview {
    ShoppingStart5Page()
        .previewThemed()
}
