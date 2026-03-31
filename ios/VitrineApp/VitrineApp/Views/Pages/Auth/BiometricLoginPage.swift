import SwiftUI
import DesignSystem

// MARK: - BiometricLoginPage

/// Biometric login page with fingerprint verification (Figma node 516:10893).
struct BiometricLoginPage: View {
    @Environment(\.theme) private var theme

    private let cardOverlap: CGFloat = 50

    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacing.sm) {
                imageCarousel(imageName: "astronaut_balloons")
                touchIDCard
                    .padding(.top, -cardOverlap)
                passcodeBar
                    .padding(.top, -cardOverlap)
            }
            .padding(.horizontal, theme.spacing.sm)
            .padding(.bottom, theme.spacing.sm)
        }
        .background(theme.colors.surfaceNeutral05.ignoresSafeArea())
        .navigationBarBackButtonHidden(false)
    }

    // MARK: - Touch ID Card

    private var touchIDCard: some View {
        DSCard {
            VStack(spacing: theme.spacing.xl) {
                DSText("Tap to verify identity", style: theme.typography.h4, color: theme.colors.textNeutral05)

                Image(systemName: "touchid")
                    .font(theme.typography.display1.font)
                    .foregroundStyle(theme.colors.textNeutral05)
                    .frame(width: 80, height: 80)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, theme.spacing.xxl)
        }
        .cardBackground(theme.colors.surfacePrimary100)
    }

    // MARK: - Passcode Bar

    private var passcodeBar: some View {
        DSCard {
            HStack {
                DSText("Login with Passcode?", style: theme.typography.caption, color: theme.colors.textNeutral9)
                Spacer()
                DSButton(style: .text, size: .medium, systemIcon: "ellipsis.rectangle") {}
            }
            .padding(.vertical, theme.spacing.sm)
        }
        .cardBackground(theme.colors.surfaceSecondary100)
    }
}

// MARK: - Shared Image Carousel

extension View {
    /// Stacked image carousel with depth effect used by BiometricLoginPage and PasscodeLoginPage.
    func imageCarousel(imageName: String, height: CGFloat = 416) -> some View {
        ImageCarouselView(imageName: imageName, height: height)
    }
}

struct ImageCarouselView: View {
    @Environment(\.theme) private var theme
    let imageName: String
    var height: CGFloat = 416

    var body: some View {
        ZStack(alignment: .top) {
            DSCard {
                Color.clear
            }
            .cardBackground(theme.colors.surfaceNeutral2.opacity(0.5))
            .cardPadding(0)
            .frame(height: height - 26)
            .padding(.horizontal, 60)
            .offset(y: 20)

            DSCard {
                Color.clear
            }
            .cardBackground(theme.colors.surfaceNeutral3)
            .cardPadding(0)
            .frame(height: height - 16)
            .padding(.horizontal, 30)
            .offset(y: 10)

            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: height)
                .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))
        }
    }
}

#Preview {
    BiometricLoginPage()
        .previewThemed()
}
