import SwiftUI
import DesignSystem

// MARK: - PasscodeLoginPage

/// Passcode login page with PIN pad (Figma node 517:13638).
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
        .background(theme.colors.surfaceNeutral05.ignoresSafeArea())
        .navigationBarBackButtonHidden(false)
    }

    // MARK: - PIN Entry Card

    private var pinEntryCard: some View {
        DSCard {
            VStack(spacing: theme.spacing.xl) {
                DSText("Enter Passcode", style: theme.typography.h4, color: theme.colors.textNeutral05)

                HStack(spacing: theme.spacing.sm) {
                    ForEach(0..<passcodeLength, id: \.self) { index in
                        Circle()
                            .fill(
                                index < passcode.count
                                    ? theme.colors.surfaceSecondary100
                                    : theme.colors.surfaceNeutral05.opacity(0.3)
                            )
                            .frame(width: theme.spacing.sm, height: theme.spacing.sm)
                    }
                }

                numberPad
            }
        }
        .cardBackground(theme.colors.surfacePrimary100)
    }

    // MARK: - Number Pad

    private var numberPad: some View {
        VStack(spacing: theme.spacing.sm) {
            HStack(spacing: theme.spacing.sm) {
                digitButton("1"); digitButton("2"); digitButton("3")
            }
            HStack(spacing: theme.spacing.sm) {
                digitButton("4"); digitButton("5"); digitButton("6")
            }
            HStack(spacing: theme.spacing.sm) {
                digitButton("7"); digitButton("8"); digitButton("9")
            }
            HStack(spacing: theme.spacing.sm) {
                DSButton(style: .filledB, size: .big, systemIcon: "touchid", isFullWidth: true) {}
                digitButton("0")
                DSButton(style: .filledB, size: .big, systemIcon: "delete.backward", isFullWidth: true) {
                    if !passcode.isEmpty { passcode.removeLast() }
                }
            }
        }
    }

    private func digitButton(_ digit: String) -> some View {
        DSButton(LocalizedStringKey(digit), style: .filledC, size: .big, isFullWidth: true) {
            if passcode.count < passcodeLength { passcode.append(digit) }
        }
    }
}

#Preview {
    PasscodeLoginPage()
        .previewThemed()
}
