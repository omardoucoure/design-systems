import SwiftUI
import DesignSystem

// MARK: - Login6ErrorPage

/// Login page variant 6 with error state (Figma node 288:3657).
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
        .dsTabBarHidden()
    }

    // MARK: - Forms Card

    private var formsCard: some View {
        DSCard(background: theme.colors.surfaceNeutral2, radius: theme.radius.xl, padding: theme.spacing.xl) {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                DSText("Welcome back!", style: theme.typography.caption, color: theme.colors.textNeutral9.opacity(0.75))

                HStack(alignment: .center, spacing: theme.spacing.xs) {
                    DSText("Login", style: theme.typography.h2, color: theme.colors.textNeutral9)
                    Spacer()
                    Image("haho_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 40)
                }

                DSTextField(text: $email, placeholder: "Enter your email", label: "Your Email",
                            variant: .filled, state: .filled, icon: .mail)

                DSTextField(text: $password, placeholder: "Enter your password", label: "Your Password",
                            helperText: "Oops! Wrong password. Try again.",
                            variant: .filled, state: .error, isSecure: true)

                HStack {
                    DSCheckbox(isOn: $rememberMe, label: "Remember me")
                    Spacer()
                    DSButton("Forgot Password?", style: .text, size: .medium) {}
                }
                .padding(.vertical, theme.spacing.xs)

                DSButton("Let's Roll!", style: .filledA, size: .big,
                         iconRight: "arrow.right", isFullWidth: true) {}
            }
        }
    }

    // MARK: - Social Login Card

    private var socialLoginCard: some View {
        DSCard(background: theme.colors.surfacePrimary100, radius: theme.radius.xl, padding: 0) {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                DSText("Continue with:", style: theme.typography.h4, color: theme.colors.textNeutral0_5)

                HStack(spacing: theme.spacing.xs) {
                    socialButton(label: "Continue with Google", imageName: "icon_google")
                    socialButton(label: "Continue with Facebook", imageName: "icon_facebook")
                    socialButton(label: "Continue with X", imageName: "icon_x")
                }
            }
            .padding(.horizontal, theme.spacing.xl)
            .padding(.vertical, theme.spacing.xxl)
        }
    }

    private func socialButton(label: String, imageName: String) -> some View {
        DSButton(style: .neutral, size: .big, assetIcon: imageName, isFullWidth: true) {
        }
        .accessibilityLabel(label)
    }

    // MARK: - Sign Up Bar

    private var signUpBar: some View {
        DSCard(background: theme.colors.surfaceSecondary100, radius: theme.radius.xl, padding: 0) {
            HStack {
                DSText("Don't have an account?",
                       style: theme.typography.bodyRegular, color: theme.colors.textNeutral9)
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
