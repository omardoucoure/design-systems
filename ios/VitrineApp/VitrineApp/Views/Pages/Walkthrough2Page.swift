import SwiftUI
import DesignSystem

// MARK: - Walkthrough2Page

/// Walkthrough variant 2 — stacked image carousel (Figma node 252:2994).
///
/// Features a 3-card depth stack, a secondary-colored text card,
/// and page indicator dots.
struct Walkthrough2Page: View {
    @Environment(\.theme) private var theme
    @State private var currentPage = 0

    private let pageCount = 5

    private let headlines: [LocalizedStringKey] = [
        "Craft with Precision. Every element refined to perfection.",
        "Build with Confidence. Every pixel in its place.",
        "Design with Purpose. Every detail tells a story.",
        "Create with Passion. Every color speaks volumes.",
        "Ship with Pride. Every interaction delights."
    ]

    var body: some View {
        VStack(spacing: theme.spacing.md) {
            // Stacked image carousel
            stackedCarousel

            // Text card (secondary/coral)
            DSCard(
                background: theme.colors.surfaceSecondary100,
                radius: theme.radius.xl,
                padding: theme.spacing.xl
            ) {
                Text(headlines[currentPage])
                    .font(theme.typography.h4.font)
                    .tracking(theme.typography.h4.tracking)
                    .lineSpacing(theme.typography.h4.lineSpacing)
                    .foregroundStyle(theme.colors.textNeutral9)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Page controls
            DSPageControl(count: pageCount, currentIndex: $currentPage)
                .padding(.top, theme.spacing.lg)
                .padding(.bottom, theme.spacing.xxxl)
        }
        .padding(.horizontal, theme.spacing.sm)
        .padding(.bottom, theme.spacing.sm)
        .background(theme.colors.surfaceNeutral0_5)
        .animation(.easeInOut(duration: 0.3), value: currentPage)
        .gesture(
            DragGesture(minimumDistance: 50)
                .onEnded { value in
                    if value.translation.width < -50, currentPage < pageCount - 1 {
                        currentPage += 1
                    } else if value.translation.width > 50, currentPage > 0 {
                        currentPage -= 1
                    }
                }
        )
    }

    // MARK: - Stacked Carousel

    private var stackedCarousel: some View {
        GeometryReader { geo in
            let width = geo.size.width
            ZStack(alignment: .top) {
                // Back card (narrowest, darkest)
                cardLayer(
                    width: width - 110,
                    color: theme.colors.surfaceNeutral3.opacity(0.7),
                    iconName: "sparkles",
                    offset: 16
                )
                .zIndex(1)

                // Middle card
                cardLayer(
                    width: width - 60,
                    color: theme.colors.surfaceNeutral3,
                    iconName: "paintbrush",
                    offset: 8
                )
                .zIndex(2)

                // Front card (full width)
                cardLayer(
                    width: width,
                    color: theme.colors.surfaceNeutral2,
                    iconName: "cube.transparent",
                    offset: 0
                )
                .zIndex(3)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: 440)
    }

    private func cardLayer(width: CGFloat, color: Color, iconName: String, offset: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: theme.radius.xl)
            .fill(color)
            .frame(width: width, height: 440 - offset * 2)
            .overlay(
                Image(systemName: iconName)
                    .font(.system(size: 80, weight: .ultraLight))
                    .foregroundStyle(theme.colors.textNeutral9.opacity(0.15))
            )
            .offset(y: offset)
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    Walkthrough2Page()
        .previewThemed()
}
