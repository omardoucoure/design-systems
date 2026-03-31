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
            DSCard {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: theme.spacing.xl) {
                        DSText(pages[currentPage].title,
                               style: theme.typography.display2, color: theme.colors.textNeutral9)

                        DSDivider()

                        DSText(pages[currentPage].subtitle,
                               style: theme.typography.bodyRegular, color: theme.colors.textNeutral9)
                    }

                    Spacer()

                    HStack(spacing: 0) {
                        DSButton(action: previousPage).buttonStyle(.filledA).systemIcon("arrow.left")
                            .opacity(currentPage > 0 ? 1.0 : 0.3)
                        DSButton(action: nextPage).buttonStyle(.filledA).systemIcon("arrow.right")
                            .opacity(currentPage < pages.count - 1 ? 1.0 : 0.3)
                    }
                }
            }
            .frame(maxHeight: .infinity)

            DSCard {
                HStack {
                    DSText("For designers who dare to think differently.",
                           style: theme.typography.bodyRegular, color: theme.colors.textNeutral05)
                    Spacer()
                    DSButton("Skip") {}.buttonStyle(.filledA).buttonSize(.medium)
                }
            }
            .cardBackground(theme.colors.surfacePrimary100)
            .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, theme.spacing.sm)
        .padding(.bottom, theme.spacing.sm)
        .background(theme.colors.surfaceNeutral05.ignoresSafeArea())
        .navigationBarBackButtonHidden(false)
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
