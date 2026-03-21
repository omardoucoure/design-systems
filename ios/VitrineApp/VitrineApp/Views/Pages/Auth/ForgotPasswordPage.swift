import SwiftUI
import DesignSystem

// MARK: - ForgotPasswordPage

/// Forgot password page (Figma nodes 289:9246, 289:9436).
struct ForgotPasswordPage: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    @State private var email = ""

    var body: some View {
        VStack(spacing: 0) {
            DSTopAppBar(title: "Forgot password", style: .small, onBack: { dismiss() })

            ScrollView {
                DSCard(background: theme.colors.surfaceNeutral2, radius: theme.radius.xl, padding: theme.spacing.xl) {
                    VStack(alignment: .leading, spacing: theme.spacing.lg) {
                        DSText("Forgot password", style: theme.typography.h4, color: theme.colors.textNeutral9)
                        DSText("Enter your email address to recover your password",
                               style: theme.typography.caption, color: theme.colors.textNeutral9.opacity(0.75))

                        DSTextField(text: $email, placeholder: "Your Email",
                                    variant: .filled, state: email.isEmpty ? .empty : .filled, icon: .mail)

                        DSButton("Send Code", style: .filledA, size: .big,
                                 iconRight: "arrow.right", isFullWidth: true) {}
                            .disabled(email.isEmpty)
                    }
                }
                .padding(.horizontal, theme.spacing.sm)
                .padding(.bottom, theme.spacing.sm)
            }
        }
        .background(theme.colors.surfaceNeutral0_5.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .dsTabBarHidden()
    }
}

#Preview {
    ForgotPasswordPage()
        .previewThemed()
}
