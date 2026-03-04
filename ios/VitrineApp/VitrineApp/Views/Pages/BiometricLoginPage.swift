import SwiftUI
import DesignSystem

// MARK: - BiometricLoginPage

/// Biometric login page with fingerprint verification (Figma node 516:10893).
///
/// Features a stacked image carousel effect, Touch ID prompt,
/// and a passcode fallback bar.
struct BiometricLoginPage: View {
    @Environment(\.theme) private var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacing.sm) {
                imageCarousel(imageName: "astronaut_balloons")
                touchIDCard
                    .padding(.top, -50)
                passcodeBar
                    .padding(.top, -50)
            }
            .padding(.horizontal, theme.spacing.sm)
            .padding(.bottom, theme.spacing.sm)
        }
        .background(theme.colors.surfaceNeutral0_5)
    }

    // MARK: - Touch ID Card

    private var touchIDCard: some View {
        DSCard(
            background: theme.colors.surfacePrimary100,
            radius: theme.radius.xl,
            padding: theme.spacing.xl
        ) {
            VStack(spacing: theme.spacing.xl) {
                Text("Tap to verify identity")
                    .font(theme.typography.h4.font)
                    .tracking(theme.typography.h4.tracking)
                    .foregroundStyle(theme.colors.textNeutral0_5)

                Image(systemName: "touchid")
                    .font(.system(size: 80, weight: .thin))
                    .foregroundStyle(theme.colors.textNeutral0_5)
                    .frame(width: 80, height: 80)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, theme.spacing.xxl)
        }
    }

    // MARK: - Passcode Bar

    private var passcodeBar: some View {
        DSCard(
            background: theme.colors.surfaceSecondary100,
            radius: theme.radius.xl,
            padding: theme.spacing.xl
        ) {
            HStack {
                Text("Login with Passcode?")
                    .font(theme.typography.caption.font)
                    .tracking(theme.typography.caption.tracking)
                    .foregroundStyle(theme.colors.textNeutral9)

                Spacer()

                Image(systemName: "ellipsis.rectangle")
                    .font(.system(size: 20))
                    .foregroundStyle(theme.colors.textNeutral9)
            }
            .padding(.vertical, theme.spacing.sm)
        }
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
            // Back card
            RoundedRectangle(cornerRadius: theme.radius.xl)
                .fill(theme.colors.surfaceNeutral2.opacity(0.5))
                .frame(height: height - 26)
                .padding(.horizontal, 60)
                .offset(y: 20)

            // Middle card
            RoundedRectangle(cornerRadius: theme.radius.xl)
                .fill(theme.colors.surfaceNeutral3)
                .frame(height: height - 16)
                .padding(.horizontal, 30)
                .offset(y: 10)

            // Front card — image
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
