import SwiftUI
import DesignSystem

// MARK: - Walkthrough3Page

/// Walkthrough variant 3 — side-by-side image cards (Figma node 251:5733).
struct Walkthrough3Page: View {
    @Environment(\.theme) private var theme
    @State private var currentPage = 0

    private let pageCount = 5

    var body: some View {
        VStack(spacing: theme.spacing.sm) {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                sideBySideImages
                DSPageControl(count: pageCount, currentIndex: $currentPage)
                    .padding(.horizontal, theme.spacing.md)
            }
            .frame(maxHeight: .infinity)

            DSCard(background: theme.colors.surfacePrimary100, radius: theme.radius.xl, padding: theme.spacing.xl) {
                VStack(alignment: .leading, spacing: theme.spacing.md) {
                    DSText("Colors That Pop, Designs That Wow",
                           style: theme.typography.h4, color: theme.colors.textNeutral0_5)

                    HStack(alignment: .bottom, spacing: theme.spacing.lg) {
                        DSText("Compose with a palette of endless possibilities.",
                               style: theme.typography.bodyRegular, color: theme.colors.textNeutral0_5)
                        Spacer(minLength: 0)
                        DSButton("Skip", style: .filledA, size: .medium) {}
                    }
                }
            }
            .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, theme.spacing.sm)
        .padding(.bottom, theme.spacing.sm)
        .background(theme.colors.surfaceNeutral0_5.ignoresSafeArea())
        .navigationBarBackButtonHidden(false)
        .gesture(
            DragGesture(minimumDistance: 50)
                .onEnded { value in
                    withAnimation(.easeInOut(duration: 0.3)) {
                        if value.translation.width < -50, currentPage < pageCount - 1 {
                            currentPage += 1
                        } else if value.translation.width > 50, currentPage > 0 {
                            currentPage -= 1
                        }
                    }
                }
        )
    }

    // MARK: - Side-by-Side Images

    private let tallCardHeight: CGFloat = 488
    private let shortCardHeight: CGFloat = 340
    private let shortCardWidth: CGFloat = 160

    private var sideBySideImages: some View {
        HStack(spacing: theme.spacing.sm) {
            DSCard(background: theme.colors.surfaceNeutral2, radius: theme.radius.xl, padding: 0) {
                Image(systemName: "photo.artframe")
                    .foregroundStyle(theme.colors.textNeutral9.opacity(0.15))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, minHeight: tallCardHeight, maxHeight: tallCardHeight)

            DSCard(background: theme.colors.surfaceNeutral2, radius: theme.radius.xl, padding: 0) {
                Image(systemName: "photo")
                    .foregroundStyle(theme.colors.textNeutral9.opacity(0.15))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(width: shortCardWidth, height: shortCardHeight)
        }
    }
}

#Preview {
    Walkthrough3Page()
        .previewThemed()
}
