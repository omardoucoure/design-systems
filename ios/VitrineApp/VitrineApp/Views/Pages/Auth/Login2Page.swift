import SwiftUI
import DesignSystem

// MARK: - Login2Page

/// Login page variant 2 (Figma node 286:10979).
struct Login2Page: View {
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
        .background(theme.colors.surfaceNeutral05.ignoresSafeArea())
        .navigationBarBackButtonHidden(false)
    }

    // MARK: - Forms Card

    private var formsCard: some View {
        DSCard {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                DSSegmentedPicker(items: ["Log In", "Sign Up"], selectedIndex: $selectedTab)
                    .pickerStyle(.underline)
                    .padding(.bottom, theme.spacing.md)

                DSText("Welcome back!", style: theme.typography.caption, color: theme.colors.textNeutral9.opacity(0.75))

                HStack(alignment: .center, spacing: theme.spacing.xs) {
                    DSText("Login", style: theme.typography.h2, color: theme.colors.textNeutral9)
                    Spacer()
                    Image("haho_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 40)
                }

                DSTextField(text: $email, placeholder: "Enter your email")
                    .label("Your Email")
                    .inputState(.filled)
                    .icon(.mail)

                DSTextField(text: $password, placeholder: "Enter your password")
                    .label("Your Password")
                    .inputState(.filled)
                    .secure()

                HStack {
                    DSCheckbox(isOn: $rememberMe).label("Remember me")
                    Spacer()
                    DSButton("Forgot Password?") {}.buttonStyle(.text).buttonSize(.medium)
                }
                .padding(.vertical, theme.spacing.xxs)

                DSButton("Let's Roll!") {}
                    .buttonStyle(.filledA).systemIcon("arrow.right", position: .right).fullWidth()
            }
        }
    }

    // MARK: - Social Login Card

    private var socialLoginCard: some View {
        DSCard {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                DSText("Continue with:", style: theme.typography.h4, color: theme.colors.textNeutral9)

                HStack(spacing: theme.spacing.xs) {
                    socialButton(label: "Continue with Google", imageName: "icon_google")
                    socialButton(label: "Continue with Facebook", imageName: "icon_facebook")
                    socialButton(label: "Continue with X", imageName: "icon_x")
                }
            }
            .padding(.vertical, theme.spacing.xs)
        }
    }

    private func socialButton(label: String, imageName: String) -> some View {
        DSButton { }
            .buttonStyle(.filledC).assetIcon(imageName).fullWidth()
        .accessibilityLabel(label)
    }
}

#Preview {
    Login2Page()
        .previewThemed()
}
