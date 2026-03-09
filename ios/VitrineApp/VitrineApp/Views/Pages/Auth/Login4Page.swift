import SwiftUI
import DesignSystem

// MARK: - Login4Page

/// Login page variant 4 (Figma node 286:12058).
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
        DSCard(background: theme.colors.surfaceNeutral0_5, radius: theme.radius.xl, padding: theme.spacing.xl) {
            VStack(alignment: .center, spacing: theme.spacing.lg) {
                DSText("Welcome back! Log in to continue enjoying the Haho benefits.",
                       style: theme.typography.h6, color: theme.colors.textNeutral9)
                    .multilineTextAlignment(.center)

                VStack(spacing: theme.spacing.xs) {
                    socialButton(label: "Continue with Google", imageName: "icon_google")
                    socialButton(label: "Continue with Facebook", imageName: "icon_facebook")
                }
            }
        }
    }

    private func socialButton(label: LocalizedStringKey, imageName: String) -> some View {
        DSButton(label, style: .filledC, size: .big, assetIcon: imageName, iconPosition: .right, isFullWidth: true) {
        }
    }

    // MARK: - Forms Card

    private var formsCard: some View {
        DSCard(background: theme.colors.surfaceNeutral2, radius: theme.radius.xl, padding: theme.spacing.xl) {
            VStack(alignment: .center, spacing: theme.spacing.lg) {
                HStack(alignment: .center, spacing: theme.spacing.xs) {
                    DSText("Or better yet...", style: theme.typography.h4, color: theme.colors.textNeutral9)
                    Spacer()
                    Image("haho_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 40)
                }

                DSTextField(text: $email, placeholder: "Enter your email", label: "Your Email",
                            variant: .filled, state: .filled, iconRight: "envelope")

                DSTextField(text: $password, placeholder: "Enter your password", label: "Your Password",
                            variant: .filled, state: .filled, iconRight: "eye.slash")

                HStack {
                    DSCheckbox(isOn: $rememberMe, label: "Remember me")
                    Spacer()
                    DSButton("Forgot Password?", style: .text, size: .medium) {}
                }
                .padding(.vertical, theme.spacing.xxs)

                DSButton("Let's Roll!", style: .filledA, size: .big,
                         iconRight: "arrow.right", isFullWidth: true) {}

                HStack(spacing: 0) {
                    DSText("Don't have an account? ",
                           style: theme.typography.bodyRegular, color: theme.colors.textNeutral9)
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
