import SwiftUI
import DesignSystem

// MARK: - NewPasswordPage

/// New password page (Figma nodes 292:8572, 302:6272).
struct NewPasswordPage: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    @State private var newPassword = ""
    @State private var confirmPassword = ""

    var body: some View {
        VStack(spacing: 0) {
            DSTopAppBar(title: "New password").onBack { dismiss() }

            ScrollView {
                DSCard {
                    VStack(alignment: .leading, spacing: theme.spacing.lg) {
                        DSText("Add new password", style: theme.typography.h4, color: theme.colors.textNeutral9)
                        DSText("At least 8 characters, with uppercase and lowercase letters",
                               style: theme.typography.caption, color: theme.colors.textNeutral9.opacity(0.75))

                        DSTextField(text: $newPassword, placeholder: "New Password")
                            .inputState(newPassword.isEmpty ? .empty : .filled)
                            .secure()

                        DSTextField(text: $confirmPassword, placeholder: "Confirm Password")
                            .inputState(confirmPassword.isEmpty ? .empty : .filled)
                            .secure()

                        DSButton("Sign In") {}
                            .buttonStyle(.filledA).systemIcon("arrow.right", position: .right).fullWidth()
                            .disabled(newPassword.isEmpty || confirmPassword.isEmpty)
                    }
                }
                .padding(.horizontal, theme.spacing.sm)
                .padding(.bottom, theme.spacing.sm)
            }
        }
        .background(theme.colors.surfaceNeutral05.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .dsTabBarHidden()
    }
}

#Preview {
    NewPasswordPage()
        .previewThemed()
}
