import SwiftUI
import DesignSystem

// MARK: - Login2Page

/// Login page variant 2 (Figma node 286:10979).
///
/// Same form layout as LoginPage but uses underline navigation tabs
/// and a neutral social login card with dark buttons.
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
        .background(theme.colors.surfaceNeutral0_5)
    }

    // MARK: - Forms Card

    private var formsCard: some View {
        DSCard(
            background: theme.colors.surfaceNeutral2,
            radius: theme.radius.xl,
            padding: theme.spacing.xl
        ) {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                // Underline tabs
                DSSegmentedPicker(
                    items: ["Log In", "Sign Up"],
                    selectedIndex: $selectedTab,
                    style: .underline
                )
                .padding(.bottom, theme.spacing.md)

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
                    Button {
                        // Forgot password action
                    } label: {
                        Text("Forgot Password?")
                            .font(theme.typography.body.font)
                            .tracking(theme.typography.body.tracking)
                            .foregroundStyle(theme.colors.textNeutral9)
                    }
                    .buttonStyle(.plain)
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
            }
        }
    }

    // MARK: - Social Login Card

    private var socialLoginCard: some View {
        DSCard(
            background: theme.colors.surfaceNeutral2,
            radius: theme.radius.xl,
            padding: theme.spacing.xl
        ) {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                Text("Continue with:")
                    .font(theme.typography.h4.font)
                    .tracking(theme.typography.h4.tracking)
                    .lineSpacing(theme.typography.h4.lineSpacing)
                    .foregroundStyle(theme.colors.textNeutral9)

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
        Button {
            // Social login action
        } label: {
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
                .foregroundStyle(theme.colors.textNeutral0_5)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(theme.colors.surfacePrimary120)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    Login2Page()
        .previewThemed()
}
