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
        ScrollView {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                backButtonRow(title: "Forgot password")

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

                            Button {
                                // Resend code action
                            } label: {
                                Text("Resend Code")
                                    .font(theme.typography.bodySemiBold.font)
                                    .tracking(theme.typography.bodySemiBold.tracking)
                                    .foregroundStyle(theme.colors.textNeutral9.opacity(0.75))
                            }
                            .buttonStyle(.plain)
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
                        VStack(spacing: 2) {
                            Text("By Signing In, you agree to our?")
                                .font(theme.typography.bodyRegular.font)
                                .tracking(theme.typography.bodyRegular.tracking)
                                .foregroundStyle(theme.colors.textNeutral9.opacity(0.75))

                            Button {
                                // Terms action
                            } label: {
                                Text("Terms and Conditions")
                                    .font(theme.typography.bodySemiBold.font)
                                    .tracking(theme.typography.bodySemiBold.tracking)
                                    .foregroundStyle(theme.colors.textNeutral9.opacity(0.75))
                            }
                            .buttonStyle(.plain)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
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
    VerifyCodePage()
        .previewThemed()
}
