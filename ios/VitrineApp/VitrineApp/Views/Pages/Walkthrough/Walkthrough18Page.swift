import SwiftUI
import DesignSystem

// MARK: - Walkthrough18Page

/// Walkthrough variant 18 — dark green text carousel with coral bottom bar (Figma node 994:52642).
struct Walkthrough18Page: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss
    @State private var currentPage = 0

    private let pages: [(title: LocalizedStringKey, subtitle: LocalizedStringKey)] = [
        (
            "Craft Every Curve. Polish to Shine, for Spotless Creations & Designs!",
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
        ScrollView {
            VStack(spacing: theme.spacing.sm) {
                // Main carousel card — dark green
                DSCard(background: theme.colors.surfacePrimary100, radius: theme.radius.xl, padding: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        VStack(alignment: .leading, spacing: theme.spacing.xl) {
                            Text(pages[currentPage].title)
                                .font(theme.typography.display2.font)
                                .tracking(theme.typography.display2.tracking)
                                .foregroundStyle(theme.colors.textNeutral0_5)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            DSDivider(style: .fullBleed, color: theme.colors.textNeutral0_5.opacity(0.3))

                            Text(pages[currentPage].subtitle)
                                .font(theme.typography.bodyRegular.font)
                                .tracking(theme.typography.bodyRegular.tracking)
                                .foregroundStyle(theme.colors.textNeutral0_5)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        Spacer(minLength: theme.spacing.xl)

                        arrowPill
                    }
                    .padding(theme.spacing.xl)
                }

                // Bottom bar — coral, fixed 112px
                DSCard(background: theme.colors.surfaceSecondary100, radius: theme.radius.xl, padding: 0) {
                    HStack(spacing: theme.spacing.md) {
                        Text("For designers who dare to think differently.")
                            .font(theme.typography.bodyRegular.font)
                            .tracking(theme.typography.bodyRegular.tracking)
                            .foregroundStyle(theme.colors.textNeutral9)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        skipButton
                    }
                    .frame(maxHeight: .infinity)
                    .padding(.horizontal, theme.spacing.xl)
                }
                .frame(height: 112)
            }
            .padding(.horizontal, theme.spacing.sm)
            .padding(.bottom, theme.spacing.sm)
        }
        .scrollIndicators(.hidden)
        .overlay(alignment: .topLeading) {
            DSButton(style: .neutral, size: .medium, icon: .arrowLeft) { dismiss() }
                .padding(.leading, theme.spacing.lg)
                .padding(.top, theme.spacing.xs)
        }
        .background(theme.colors.surfaceNeutral0_5.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .animation(.easeInOut(duration: 0.3), value: currentPage)
    }

    // MARK: - Arrow Pill

    private var arrowPill: some View {
        HStack(spacing: theme.spacing.sm) {
            DSButton(style: .text, size: .medium, icon: .arrowLeftLong, action: previousPage)
            DSButton(style: .text, size: .medium, icon: .arrowRightLong, action: nextPage)
        }
        .padding(.horizontal, theme.spacing.lg)
        .padding(.vertical, theme.spacing.md)
        .frame(height: 56)
        .background(theme.colors.surfaceSecondary100)
        .clipShape(Capsule())
    }

    // MARK: - Skip Button

    private var skipButton: some View {
        DSButton("Skip", style: .filledA, size: .medium) {}
    }

    // MARK: - Navigation

    private func nextPage() {
        if currentPage < pages.count - 1 { currentPage += 1 }
    }

    private func previousPage() {
        if currentPage > 0 { currentPage -= 1 }
    }
}

#Preview {
    Walkthrough18Page()
        .previewThemed()
}
