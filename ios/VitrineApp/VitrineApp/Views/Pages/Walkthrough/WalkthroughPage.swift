import SwiftUI
import DesignSystem

// MARK: - WalkthroughPage

/// Walkthrough onboarding page example (Figma node 256:3850).
struct WalkthroughPage: View {
    @Environment(\.theme) private var theme
    @State private var currentPage = 0

    private let pages: [(title: LocalizedStringKey, subtitle: LocalizedStringKey)] = [
        (
            "Make Every Pixel Count. Fine-tune to perfection, for truly flawless designs.",
            "Where your concepts become masterpieces."
        ),
        (
            "Design Systems That Scale. Build once, use everywhere with confidence.",
            "Consistency across every screen."
        ),
        (
            "From Sketch to Ship. Seamless handoff between design and development.",
            "For designers who dare to think differently."
        )
    ]

    var body: some View {
        VStack(spacing: theme.spacing.sm) {
            DSCard(background: theme.colors.surfaceNeutral2) {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: theme.spacing.xl) {
                        DSText(pages[currentPage].title,
                               style: theme.typography.display2, color: theme.colors.textNeutral9)

                        DSDivider(style: .fullBleed)

                        DSText(pages[currentPage].subtitle,
                               style: theme.typography.bodyRegular, color: theme.colors.textNeutral9)
                    }

                    Spacer()

                    HStack(spacing: 0) {
                        DSButton(style: .filledA, size: .big, systemIcon: "arrow.left", action: previousPage)
                            .opacity(currentPage > 0 ? 1.0 : 0.3)
                        DSButton(style: .filledA, size: .big, systemIcon: "arrow.right", action: nextPage)
                            .opacity(currentPage < pages.count - 1 ? 1.0 : 0.3)
                    }
                }
            }
            .frame(maxHeight: .infinity)

            DSCard(background: theme.colors.surfacePrimary100) {
                HStack {
                    DSText("For designers who dare to think differently.",
                           style: theme.typography.bodyRegular, color: theme.colors.textNeutral0_5)
                    Spacer()
                    DSButton("Skip", style: .filledA, size: .medium) {}
                }
            }
            .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, theme.spacing.sm)
        .padding(.bottom, theme.spacing.sm)
        .background(theme.colors.surfaceNeutral0_5)
        .animation(.easeInOut(duration: 0.3), value: currentPage)
    }

    private func nextPage() {
        if currentPage < pages.count - 1 { currentPage += 1 }
    }

    private func previousPage() {
        if currentPage > 0 { currentPage -= 1 }
    }
}

#Preview {
    WalkthroughPage()
        .previewThemed()
}
