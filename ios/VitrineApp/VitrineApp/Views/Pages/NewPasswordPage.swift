import SwiftUI
import DesignSystem

// MARK: - NewPasswordPage

/// New password page (Figma nodes 292:8572, 302:6272).
///
/// Two password fields (new + confirm) with empty and filled states.
/// "Sign In" button is disabled until both fields have input.
struct NewPasswordPage: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    @State private var newPassword = ""
    @State private var confirmPassword = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                backButtonRow(title: "New password")

                DSCard(
                    background: theme.colors.surfaceNeutral2,
                    radius: theme.radius.xl,
                    padding: theme.spacing.xl
                ) {
                    VStack(alignment: .leading, spacing: theme.spacing.lg) {
                        Text("Add new password")
                            .font(theme.typography.h4.font)
                            .tracking(theme.typography.h4.tracking)
                            .foregroundStyle(theme.colors.textNeutral9)

                        Text("At least 8 characters, with uppercase and lowercase letters")
                            .font(theme.typography.caption.font)
                            .tracking(theme.typography.caption.tracking)
                            .foregroundStyle(theme.colors.textNeutral9.opacity(0.75))

                        DSTextField(
                            text: $newPassword,
                            placeholder: "New Password",
                            variant: .filled,
                            state: newPassword.isEmpty ? .empty : .filled,
                            isSecure: true
                        )

                        DSTextField(
                            text: $confirmPassword,
                            placeholder: "Confirm Password",
                            variant: .filled,
                            state: confirmPassword.isEmpty ? .empty : .filled,
                            isSecure: true
                        )

                        DSButton(
                            "Sign In",
                            style: .filledA,
                            size: .big,
                            iconRight: "arrow.right",
                            isFullWidth: true
                        ) {
                            // Sign in action
                        }
                        .disabled(newPassword.isEmpty || confirmPassword.isEmpty)
                    }
                }
            }
            .padding(.horizontal, theme.spacing.sm)
            .padding(.bottom, theme.spacing.sm)
        }
        .background(theme.colors.surfaceNeutral0_5)
        .toolbar(.hidden, for: .navigationBar)
    }

    private func backButtonRow(title: String) -> some View {
        ZStack {
            HStack {
                DSButton(
                    style: .neutral,
                    size: .medium,
                    systemIcon: "arrow.left"
                ) {
                    dismiss()
                }
                Spacer()
            }

            Text(title)
                .font(theme.typography.h5.font)
                .tracking(theme.typography.h5.tracking)
                .foregroundStyle(theme.colors.textNeutral9)
        }
    }
}

#Preview {
    NewPasswordPage()
        .previewThemed()
}
