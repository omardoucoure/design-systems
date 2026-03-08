import SwiftUI
import DesignSystem

// MARK: - Login6ErrorPage

/// Login page variant 6 with error state (Figma node 288:3657).
///
/// Shows a login form with password error, social login section,
/// and a sign-up bar with overlapping card layout.
struct Login6ErrorPage: View {
    @Environment(\.theme) private var theme

    @State private var email = "hristov123@gmail.com"
    @State private var password = "secretpassword123"
    @State private var rememberMe = true

    private let cardOverlap: CGFloat = 50

    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacing.sm) {
                formsCard
                socialLoginCard
                signUpBar
                    .padding(.top, -cardOverlap)
            }
            .padding(.horizontal, theme.spacing.sm)
            .padding(.bottom, theme.spacing.sm)
        }
        .background(theme.colors.surfaceNeutral0_5)
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: - Forms Card

    private var formsCard: some View {
        DSCard(
            background: theme.colors.surfaceNeutral2,
            radius: theme.radius.xl,
            padding: theme.spacing.xl
        ) {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                // Welcome text
                Text("Welcome back!")
                    .font(theme.typography.caption.font)
                    .tracking(theme.typography.caption.tracking)
                    .foregroundStyle(theme.colors.textNeutral9.opacity(0.75))

                // Headline + Logo
                HStack(alignment: .center, spacing: theme.spacing.xs) {
                    Text("Login")
                        .font(theme.typography.h2.font)
                        .tracking(theme.typography.h2.tracking)
                        .foregroundStyle(theme.colors.textNeutral9)

                    Spacer()

                    Image("haho_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 40)
                }

                // Email field (filled state)
                DSTextField(
                    text: $email,
                    placeholder: "Enter your email",
                    label: "Your Email",
                    variant: .filled,
                    state: .filled,
                    iconRight: "envelope"
                )

                // Password field (error state)
                DSTextField(
                    text: $password,
                    placeholder: "Enter your password",
                    label: "Your Password",
                    helperText: "Oops! Wrong password. Try again.",
                    variant: .filled,
                    state: .error,
                    isSecure: true
                )

                // Remember me + Forgot password
                HStack {
                    DSCheckbox(isOn: $rememberMe, label: "Remember me")
                    Spacer()
                    DSButton("Forgot Password?", style: .text, size: .medium) {}
                }
                .padding(.vertical, theme.spacing.xs)

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
            }
        }
    }

    // MARK: - Social Login Card

    private var socialLoginCard: some View {
        DSCard(
            background: theme.colors.surfacePrimary100,
            radius: theme.radius.xl,
            padding: 0
        ) {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                Text("Continue with:")
                    .font(theme.typography.h4.font)
                    .tracking(theme.typography.h4.tracking)
                    .lineSpacing(theme.typography.h4.lineSpacing)
                    .foregroundStyle(theme.colors.textNeutral0_5)

                HStack(spacing: theme.spacing.xs) {
                    socialButton(imageName: "icon_google")
                    socialButton(imageName: "icon_facebook")
                    socialButton(imageName: "icon_x")
                }
            }
            .padding(.horizontal, theme.spacing.xl)
            .padding(.vertical, theme.spacing.xxl)
        }
    }

    private func socialButton(imageName: String) -> some View {
        Button {
            // Social login action
        } label: {
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
                .foregroundStyle(theme.colors.textNeutral9)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(theme.colors.surfaceNeutral2)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Sign Up Bar

    private var signUpBar: some View {
        DSCard(
            background: theme.colors.surfaceSecondary100,
            radius: theme.radius.xl,
            padding: 0
        ) {
            HStack {
                Text("Don't have an account?")
                    .font(theme.typography.bodyRegular.font)
                    .tracking(theme.typography.bodyRegular.tracking)
                    .foregroundStyle(theme.colors.textNeutral9)

                Spacer()

                DSButton("Sign Up", style: .text, size: .medium) {}
            }
            .padding(.horizontal, theme.spacing.xl)
            .padding(.top, theme.spacing.xxxxl)
            .padding(.bottom, theme.spacing.lg)
        }
    }
}

#Preview {
    Login6ErrorPage()
        .previewThemed()
}
