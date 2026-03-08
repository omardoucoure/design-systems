import SwiftUI
import DesignSystem

// MARK: - VerifyCodePage

/// Verification code page (Figma nodes 289:9831, 292:7867).
///
/// 4-digit code entry with DSCodeInput, empty and filled states.
/// "Next" button is disabled until all 4 digits are entered.
struct VerifyCodePage: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    @State private var code = ""

    var body: some View {
        VStack(spacing: 0) {
            DSTopAppBar(title: "Forgot password", style: .small, onBack: { dismiss() })

            ScrollView {
                DSCard(
                    background: theme.colors.surfaceNeutral2,
                    radius: theme.radius.xl,
                    padding: theme.spacing.xl
                ) {
                    VStack(alignment: .leading, spacing: theme.spacing.lg) {
                        Text("Verify your identity")
                            .font(theme.typography.h4.font)
                            .tracking(theme.typography.h4.tracking)
                            .foregroundStyle(theme.colors.textNeutral9)

                        Text("An authentication code has been sent to hristov123@gmail.com")
                            .font(theme.typography.caption.font)
                            .tracking(theme.typography.caption.tracking)
                            .foregroundStyle(theme.colors.textNeutral9.opacity(0.75))

                        DSCodeInput(code: $code, digitCount: 4)

                        // Resend code
                        HStack(spacing: theme.spacing.xs) {
                            Text("I didn't receive code?")
                                .font(theme.typography.bodyRegular.font)
                                .tracking(theme.typography.bodyRegular.tracking)
                                .foregroundStyle(theme.colors.textNeutral9.opacity(0.75))

                            DSButton("Resend Code", style: .text, size: .medium) {}
                        }

                        DSButton(
                            "Next",
                            style: .filledA,
                            size: .big,
                            iconRight: "arrow.right",
                            isFullWidth: true
                        ) {
                            // Next action
                        }
                        .disabled(code.count < 4)

                        // Terms
                        VStack(spacing: theme.spacing.xxs) {
                            Text("By Signing In, you agree to our?")
                                .font(theme.typography.bodyRegular.font)
                                .tracking(theme.typography.bodyRegular.tracking)
                                .foregroundStyle(theme.colors.textNeutral9.opacity(0.75))

                            DSButton("Terms and Conditions", style: .text, size: .medium) {}
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal, theme.spacing.sm)
                .padding(.bottom, theme.spacing.sm)
            }
        }
        .background(theme.colors.surfaceNeutral0_5)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    VerifyCodePage()
        .previewThemed()
}
