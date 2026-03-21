import SwiftUI
import DesignSystem

// MARK: - VerifyCodePage

/// Verification code page (Figma nodes 289:9831, 292:7867).
struct VerifyCodePage: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    @State private var code = ""

    var body: some View {
        VStack(spacing: 0) {
            DSTopAppBar(title: "Forgot password", style: .small, onBack: { dismiss() })

            ScrollView {
                DSCard(background: theme.colors.surfaceNeutral2, radius: theme.radius.xl, padding: theme.spacing.xl) {
                    VStack(alignment: .leading, spacing: theme.spacing.lg) {
                        DSText("Verify your identity", style: theme.typography.h4, color: theme.colors.textNeutral9)
                        DSText("An authentication code has been sent to hristov123@gmail.com",
                               style: theme.typography.caption, color: theme.colors.textNeutral9.opacity(0.75))

                        DSCodeInput(code: $code, digitCount: 4)

                        HStack(spacing: theme.spacing.xs) {
                            DSText("I didn't receive code?",
                                   style: theme.typography.bodyRegular, color: theme.colors.textNeutral9.opacity(0.75))
                            DSButton("Resend Code", style: .text, size: .medium) {}
                        }

                        DSButton("Next", style: .filledA, size: .big,
                                 iconRight: "arrow.right", isFullWidth: true) {}
                            .disabled(code.count < 4)

                        VStack(spacing: theme.spacing.xxs) {
                            DSText("By Signing In, you agree to our?",
                                   style: theme.typography.bodyRegular, color: theme.colors.textNeutral9.opacity(0.75))
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
        .background(theme.colors.surfaceNeutral0_5.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .dsTabBarHidden()
    }
}

#Preview {
    VerifyCodePage()
        .previewThemed()
}
