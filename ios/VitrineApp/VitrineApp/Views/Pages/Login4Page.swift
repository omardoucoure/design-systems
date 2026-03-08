import SwiftUI
import DesignSystem

// MARK: - Login4Page

/// Login page variant 4 (Figma node 286:12058).
///
/// Social login first with full-width labeled buttons,
/// then email/password form below with "Or better yet..." heading.
struct Login4Page: View {
    @Environment(\.theme) private var theme

    @State private var email = "hristov123@gmail.com"
    @State private var password = "secretpassword123"
    @State private var rememberMe = false

    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacing.sm) {
                socialCard
                formsCard
            }
            .padding(.horizontal, theme.spacing.sm)
            .padding(.bottom, theme.spacing.sm)
        }
        .background(theme.colors.surfaceNeutral0_5)
    }

    // MARK: - Social Card

    private var socialCard: some View {
        DSCard(
            background: theme.colors.surfaceNeutral0_5,
            radius: theme.radius.xl,
            padding: theme.spacing.xl
        ) {
            VStack(alignment: .center, spacing: theme.spacing.lg) {
                Text("Welcome back! Log in to continue enjoying the Haho benefits.")
                    .font(theme.typography.h6.font)
                    .tracking(theme.typography.h6.tracking)
                    .lineSpacing(theme.typography.h6.lineSpacing)
                    .foregroundStyle(theme.colors.textNeutral9)
                    .multilineTextAlignment(.center)

                VStack(spacing: theme.spacing.xs) {
                    socialButton(label: "Continue with Google", imageName: "icon_google")
                    socialButton(label: "Continue with Facebook", imageName: "icon_facebook")
                }
            }
        }
    }

    private func socialButton(label: String, imageName: String) -> some View {
        Button {
            // Social login action
        } label: {
            HStack {
                Text(label)
                    .font(theme.typography.bodySemiBold.font)
                    .tracking(theme.typography.bodySemiBold.tracking)
                    .foregroundStyle(theme.colors.textNeutral0_5)

                Spacer()

                Image(imageName)
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(theme.colors.textNeutral0_5)
            }
            .padding(.horizontal, theme.spacing.lg)
            .padding(.vertical, theme.spacing.md)
            .frame(height: 56)
            .background(theme.colors.surfacePrimary120)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Forms Card

    private var formsCard: some View {
        DSCard(
            background: theme.colors.surfaceNeutral2,
            radius: theme.radius.xl,
            padding: theme.spacing.xl
        ) {
            VStack(alignment: .center, spacing: theme.spacing.lg) {
                // Headline + Logo
                HStack(alignment: .center, spacing: theme.spacing.xs) {
                    Text("Or better yet...")
                        .font(theme.typography.h4.font)
                        .tracking(theme.typography.h4.tracking)
                        .foregroundStyle(theme.colors.textNeutral9)

                    Spacer()

                    Image("haho_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 40)
                }

                // Email field
                DSTextField(
                    text: $email,
                    placeholder: "Enter your email",
                    label: "Your Email",
                    variant: .filled,
                    state: .filled,
                    iconRight: "envelope"
                )

                // Password field
                DSTextField(
                    text: $password,
                    placeholder: "Enter your password",
                    label: "Your Password",
                    variant: .filled,
                    state: .filled,
                    iconRight: "eye.slash"
                )

                // Remember me + Forgot password
                HStack {
                    DSCheckbox(isOn: $rememberMe, label: "Remember me")
                    Spacer()
                    DSButton("Forgot Password?", style: .text, size: .medium) {}
                }
                .padding(.vertical, theme.spacing.xxs)

                // CTA button
                DSButton(
                    "Let's Roll!",
                    style: .filledA,
                    size: .big,
                    iconRight: "arrow.right",
                    isFullWidth: true
                ) {
                    // Login action
                }

                // Sign up link
                HStack(spacing: 0) {
                    Text("Don't have an account? ")
                        .font(theme.typography.bodyRegular.font)
                        .tracking(theme.typography.bodyRegular.tracking)
                        .foregroundStyle(theme.colors.textNeutral9)

                    DSButton("Sign Up", style: .text, size: .medium) {}
                }
            }
        }
    }
}

#Preview {
    Login4Page()
        .previewThemed()
}
