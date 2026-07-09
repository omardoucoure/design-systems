import SwiftUI
import DesignSystem

struct CommerceDetailView: View {
    @Environment(\.theme) private var theme
    @State private var qty = 1
    @State private var cartQty = 2

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                DSDivider().dividerStyle(.subheader("Quantity Stepper"))
                HStack(spacing: theme.spacing.lg) {
                    DSStepper(value: $qty)
                    DSStepper(value: .constant(1))
                }

                DSDivider().dividerStyle(.subheader("Rating"))
                DSRating(value: 4).label("4.0 · 218 reviews")
                DSRating(value: 5)
                DSRating(value: 2.5)

                DSDivider().dividerStyle(.subheader("Cart Row"))
                DSCartRow(title: "Linen oversized shirt", meta: "Sand · M", price: "$168", quantity: $cartQty) {
                    LinearGradient(colors: [theme.colors.surfaceSecondary100, theme.colors.surfacePrimary100],
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                }
                DSCartRow(title: "Wool wide-leg trouser", meta: "Charcoal · 30", price: "$148", quantity: .constant(1)) {
                    LinearGradient(colors: [theme.colors.surfacePrimary100, theme.colors.surfacePrimary120],
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                }
            }
            .padding(theme.spacing.lg)
        }
        .navigationTitle("Stepper, Rating & Cart")
    }
}

struct CheckoutDetailView: View {
    @Environment(\.theme) private var theme
    @State private var selectedPayment = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                DSDivider().dividerStyle(.subheader("Order Summary"))
                DSOrderSummary(
                    lines: [
                        DSOrderLine(label: "Subtotal", value: "$316.00"),
                        DSOrderLine(label: "Shipping", value: "Free"),
                        DSOrderLine(label: "Tax", value: "$25.28")
                    ],
                    totalLabel: "Total",
                    totalValue: "$341.28"
                )

                DSDivider().dividerStyle(.subheader("Payment Methods"))
                DSPaymentMethod(brand: .visa, title: "Visa ···· 4821", subtitle: "Expires 04/29",
                                isSelected: selectedPayment == 0) { selectedPayment = 0 }
                DSPaymentMethod(brand: .mastercard, title: "Mastercard ···· 1192", subtitle: "Expires 11/27",
                                isSelected: selectedPayment == 1) { selectedPayment = 1 }
                DSPaymentMethod(brand: .paypal, title: "PayPal", subtitle: "mira@haho.studio",
                                isSelected: selectedPayment == 2) { selectedPayment = 2 }
            }
            .padding(theme.spacing.lg)
        }
        .navigationTitle("Order & Payment")
    }
}

struct ChatDetailView: View {
    @Environment(\.theme) private var theme
    @State private var message = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                DSDivider().dividerStyle(.subheader("Bubble Thread"))
                VStack(spacing: theme.spacing.xs) {
                    DSChatBubble("Hey, did the new system land?", side: .incoming)
                    DSChatBubble("Yep — pushed components-extras tonight.", side: .outgoing).time("8:42 PM ✓✓")
                    DSChatBubble("Amazing. Calendar tokens working in dark too?", side: .incoming)
                    DSChatBubble("Tried it on Sea Lime. Looks tight.", side: .outgoing)
                    HStack {
                        DSTypingIndicator()
                        Spacer(minLength: 48)
                    }
                }

                DSDivider().dividerStyle(.subheader("Composer"))
                DSChatComposer(text: $message) {}.onAdd {}
            }
            .padding(theme.spacing.lg)
        }
        .navigationTitle("Chat")
    }
}

struct ExtrasDetailView: View {
    @Environment(\.theme) private var theme
    @State private var page = 2

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                DSDivider().dividerStyle(.subheader("Numeric Pager"))
                DSNumericPager(current: $page, total: 12)
                DSNumericPager(current: .constant(1), total: 4)

                DSDivider().dividerStyle(.subheader("Donut Chart"))
                DSDonutChart(
                    segments: [
                        DSDonutSegment(label: "Food 35%", value: 35, color: theme.colors.surfaceSecondary100),
                        DSDonutSegment(label: "Rent 35%", value: 35, color: theme.colors.surfacePrimary100),
                        DSDonutSegment(label: "Other 30%", value: 30, color: theme.colors.borderNeutral3)
                    ],
                    centerLabel: "$2.4k"
                )

                DSDivider().dividerStyle(.subheader("Divider Variants"))
                DSDivider().dividerStyle(.strong)
                DSDivider().dividerStyle(.dotted)
                DSDivider().dividerStyle(.label("or continue with"))
            }
            .padding(theme.spacing.lg)
        }
        .navigationTitle("Pager & Donut")
    }
}
