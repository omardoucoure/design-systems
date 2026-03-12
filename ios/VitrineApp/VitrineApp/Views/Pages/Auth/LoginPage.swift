import SwiftUI
import DesignSystem

// MARK: - LoginPage

/// Login page example (Figma node 286:5616).
struct LoginPage: View {
    @Environment(\.theme) private var theme

    @State private var selectedTab = 0
    @State private var email = "hristov123@gmail.com"
    @State private var password = "secretpassword123"
    @State private var rememberMe = false

    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacing.sm) {
                formsCard
                socialLoginCard
            }
            .padding(.horizontal, theme.spacing.sm)
            .padding(.bottom, theme.spacing.sm)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(theme.colors.surfaceNeutral0_5)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }

    // MARK: - Forms Card

    private var formsCard: some View {
        DSCard(background: theme.colors.surfaceNeutral2, radius: theme.radius.xl, padding: theme.spacing.xl) {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                DSSegmentedPicker(items: ["Log In", "Sign Up"], selectedIndex: $selectedTab)
                    .padding(.bottom, theme.spacing.sm)

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
                            variant: .filled, state: .filled, isSecure: true)

                HStack {
                    DSCheckbox(isOn: $rememberMe, label: "Remember me")
                    Spacer()
                    DSButton("Forgot Password?", style: .text, size: .medium) {}
                }
                .padding(.vertical, theme.spacing.xxs)

                DSButton("Let's Roll!", style: .filledA, size: .big,
                         iconRight: "arrow.right", isFullWidth: true) {}
            }
        }
    }

    // MARK: - Social Login Card

    private var socialLoginCard: some View {
        DSCard(background: theme.colors.surfacePrimary100, radius: theme.radius.xl, padding: theme.spacing.xl) {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                DSText("Continue with:", style: theme.typography.h4, color: theme.colors.textNeutral0_5)

                HStack(spacing: theme.spacing.xs) {
                    socialButton(imageName: "icon_google")
                    socialButton(imageName: "icon_facebook")
                    socialButton(imageName: "icon_x")
                }
            }
            .padding(.vertical, theme.spacing.xs)
        }
    }

    private func socialButton(imageName: String) -> some View {
        DSButton(style: .neutral, size: .big, assetIcon: imageName, isFullWidth: true) {
        }
    }
}

#Preview {
    LoginPage()
        .previewThemed()
}
