import SwiftUI

// MARK: - DSCodeInput

/// A themed verification code input with individual digit boxes.
///
/// Each box is tappable and shows the system keyboard for digit entry.
/// Automatically advances through boxes as digits are typed.
///
/// Usage:
/// ```swift
/// DSCodeInput(code: $code, digitCount: 4)
/// ```
public struct DSCodeInput: View {
    @Environment(\.theme) private var theme

    @Binding private var code: String
    private let digitCount: Int

    @FocusState private var isFocused: Bool

    public init(code: Binding<String>, digitCount: Int = 4) {
        self._code = code
        self.digitCount = digitCount
    }

    public var body: some View {
        ZStack {
            // Hidden text field that captures keyboard input
            TextField("", text: $code)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .focused($isFocused)
                .opacity(0)
                .allowsHitTesting(false)
                .onChange(of: code) { newValue in
                    // Filter non-digits and limit length
                    let filtered = String(newValue.filter(\.isNumber).prefix(digitCount))
                    if filtered != newValue {
                        code = filtered
                    }
                }

            // Visible digit boxes
            HStack(spacing: theme.spacing.sm) {
                ForEach(0..<digitCount, id: \.self) { index in
                    digitBox(at: index)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                isFocused = true
            }
        }
    }

    private func digitBox(at index: Int) -> some View {
        let character: String? = index < code.count
            ? String(code[code.index(code.startIndex, offsetBy: index)])
            : nil

        let isActive = isFocused && index == code.count

        return Text(character ?? "---")
            .font(theme.typography.body.font)
            .tracking(theme.typography.body.tracking)
            .foregroundStyle(
                theme.colors.textNeutral9
                    .opacity(character == nil ? 0.5 : 1.0)
            )
            .frame(maxWidth: .infinity)
            .frame(height: 88)
            .background(theme.colors.surfaceNeutral0_5)
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.md))
            .overlay(
                RoundedRectangle(cornerRadius: theme.radius.md)
                    .stroke(
                        isActive ? theme.colors.borderNeutral8 : theme.colors.borderNeutral2,
                        lineWidth: theme.borders.widthMd
                    )
            )
    }
}
