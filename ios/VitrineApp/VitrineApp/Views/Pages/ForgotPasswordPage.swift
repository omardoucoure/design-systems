import SwiftUI
import DesignSystem

// MARK: - ForgotPasswordPage

/// Forgot password page (Figma nodes 289:9246, 289:9436).
///
/// Email entry form with empty and filled states.
/// "Send Code" button is disabled until email is entered.
struct ForgotPasswordPage: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    @State private var email = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                backButtonRow(title: "Forgot password")

                DSCard(
                    background: theme.colors.surfaceNeutral2,
                    radius: theme.radius.xl,
                    padding: theme.spacing.xl
                ) {
                    VStack(alignment: .leading, spacing: theme.spacing.lg) {
                        Text("Forgot password")
                            .font(theme.typography.h4.font)
                            .tracking(theme.typography.h4.tracking)
                            .foregroundStyle(theme.colors.textNeutral9)

                        Text("Enter your email address to recover your password")
                            .font(theme.typography.caption.font)
                            .tracking(theme.typography.caption.tracking)
                            .foregroundStyle(theme.colors.textNeutral9.opacity(0.75))

                        DSTextField(
                            text: $email,
                            placeholder: "Your Email",
                            variant: .filled,
                            state: email.isEmpty ? .empty : .filled,
                            iconRight: "envelope"
                        )

                        DSButton(
                            "Send Code",
                            style: .filledA,
                            size: .big,
                            iconRight: "arrow.right",
                            isFullWidth: true
                        ) {
                            // Send code action
                        }
                        .disabled(email.isEmpty)
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
    ForgotPasswordPage()
        .previewThemed()
}
