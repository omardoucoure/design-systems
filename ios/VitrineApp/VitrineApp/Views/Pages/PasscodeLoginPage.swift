import SwiftUI
import DesignSystem

// MARK: - PasscodeLoginPage

/// Passcode login page with PIN pad (Figma node 517:13638).
///
/// Features a stacked image carousel, 6-digit PIN dots,
/// and a full number pad grid.
struct PasscodeLoginPage: View {
    @Environment(\.theme) private var theme

    @State private var passcode = ""
    private let passcodeLength = 6

    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacing.lg) {
                imageCarousel(imageName: "astronaut_flowers", height: 248)
                pinEntryCard
            }
            .padding(.horizontal, theme.spacing.sm)
            .padding(.bottom, theme.spacing.sm)
        }
        .background(theme.colors.surfaceNeutral0_5)
    }

    // MARK: - PIN Entry Card

    private var pinEntryCard: some View {
        DSCard(
            background: theme.colors.surfacePrimary100,
            radius: theme.radius.xl,
            padding: theme.spacing.xl
        ) {
            VStack(spacing: theme.spacing.xl) {
                Text("Enter Passcode")
                    .font(theme.typography.h4.font)
                    .tracking(theme.typography.h4.tracking)
                    .foregroundStyle(theme.colors.textNeutral0_5)

                // PIN dots
                HStack(spacing: theme.spacing.sm) {
                    ForEach(0..<passcodeLength, id: \.self) { index in
                        Circle()
                            .fill(
                                index < passcode.count
                                    ? theme.colors.surfaceSecondary100
                                    : theme.colors.surfaceNeutral0_5.opacity(0.3)
                            )
                            .frame(width: 12, height: 12)
                    }
                }

                // Number pad
                numberPad
            }
        }
    }

    // MARK: - Number Pad

    private var numberPad: some View {
        VStack(spacing: theme.spacing.sm) {
            // Row 1: 1, 2, 3
            HStack(spacing: theme.spacing.sm) {
                digitButton("1")
                digitButton("2")
                digitButton("3")
            }

            // Row 2: 4, 5, 6
            HStack(spacing: theme.spacing.sm) {
                digitButton("4")
                digitButton("5")
                digitButton("6")
            }

            // Row 3: 7, 8, 9
            HStack(spacing: theme.spacing.sm) {
                digitButton("7")
                digitButton("8")
                digitButton("9")
            }

            // Row 4: fingerprint, 0, backspace
            HStack(spacing: theme.spacing.sm) {
                actionButton(systemIcon: "touchid") {
                    // Biometric auth action
                }

                digitButton("0")

                actionButton(systemIcon: "delete.backward") {
                    if !passcode.isEmpty {
                        passcode.removeLast()
                    }
                }
            }
        }
    }

    private func digitButton(_ digit: String) -> some View {
        Button {
            if passcode.count < passcodeLength {
                passcode.append(digit)
            }
        } label: {
            Text(digit)
                .font(theme.typography.bodySemiBold.font)
                .tracking(theme.typography.bodySemiBold.tracking)
                .foregroundStyle(theme.colors.textNeutral0_5)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(theme.colors.surfacePrimary120)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    private func actionButton(systemIcon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemIcon)
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(theme.colors.textNeutral0_5)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(theme.colors.surfacePrimary100)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PasscodeLoginPage()
        .previewThemed()
}
