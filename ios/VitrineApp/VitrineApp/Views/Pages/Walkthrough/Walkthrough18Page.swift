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
                DSCard {
                    VStack(alignment: .leading, spacing: 0) {
                        VStack(alignment: .leading, spacing: theme.spacing.xl) {
                            Text(pages[currentPage].title)
                                .font(theme.typography.display2.font)
                                .tracking(theme.typography.display2.tracking)
                                .foregroundStyle(theme.colors.textNeutral05)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            DSDivider().dividerColor(theme.colors.textNeutral05.opacity(0.3))

                            Text(pages[currentPage].subtitle)
                                .font(theme.typography.bodyRegular.font)
                                .tracking(theme.typography.bodyRegular.tracking)
                                .foregroundStyle(theme.colors.textNeutral05)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        Spacer(minLength: theme.spacing.xl)

                        arrowPill
                    }
                    .padding(theme.spacing.xl)
                }
                .cardBackground(theme.colors.surfacePrimary100)
                .cardPadding(0)

                // Bottom bar — coral, fixed 112px
                DSCard {
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
                .cardBackground(theme.colors.surfaceSecondary100)
                .cardPadding(0)
                .frame(height: 112)
            }
            .padding(.horizontal, theme.spacing.sm)
            .padding(.bottom, theme.spacing.sm)
        }
        .scrollIndicators(.hidden)
        .overlay(alignment: .topLeading) {
            DSButton { dismiss() }.buttonStyle(.neutral).buttonSize(.medium).icon(.arrowLeft)
                .padding(.leading, theme.spacing.lg)
                .padding(.top, theme.spacing.xs)
        }
        .background(theme.colors.surfaceNeutral05.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .animation(.easeInOut(duration: 0.3), value: currentPage)
    }

    // MARK: - Arrow Pill

    private var arrowPill: some View {
        HStack(spacing: theme.spacing.sm) {
            DSButton(action: previousPage).buttonStyle(.text).buttonSize(.medium).icon(.arrowLeftLong)
            DSButton(action: nextPage).buttonStyle(.text).buttonSize(.medium).icon(.arrowRightLong)
        }
        .padding(.horizontal, theme.spacing.lg)
        .padding(.vertical, theme.spacing.md)
        .frame(height: 56)
        .background(theme.colors.surfaceSecondary100)
        .clipShape(Capsule())
    }

    // MARK: - Skip Button

    private var skipButton: some View {
        DSButton("Skip") {}.buttonStyle(.filledA).buttonSize(.medium)
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
