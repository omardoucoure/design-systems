import SwiftUI

public struct DSChatComposer: View {
    @Environment(\.theme) private var theme

    @Binding private var text: String
    private let placeholder: LocalizedStringKey
    private let onSend: () -> Void
    private var _onAdd: (() -> Void)?

    public init(
        text: Binding<String>,
        placeholder: LocalizedStringKey = "Message",
        onSend: @escaping () -> Void
    ) {
        self._text = text
        self.placeholder = placeholder
        self.onSend = onSend
    }

    public func onAdd(_ action: @escaping () -> Void) -> DSChatComposer {
        var copy = self
        copy._onAdd = action
        return copy
    }

    public var body: some View {
        HStack(spacing: theme.spacing.xs) {
            if let _onAdd {
                Button(action: _onAdd) {
                    Image(dsIcon: .plus)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: theme.spacing.lg, height: theme.spacing.lg)
                        .foregroundStyle(theme.colors.textNeutral9)
                        .frame(width: 40, height: 40)
                        .contentShape(Circle())
                }
                .buttonStyle(.plain)
            }

            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .font(theme.typography.body.font)
                .tracking(theme.typography.body.tracking)
                .foregroundStyle(theme.colors.textNeutral9)
                .frame(height: 40)

            Button(action: onSend) {
                Image(dsIcon: .sendDiagonal)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: theme.spacing.md, height: theme.spacing.md)
                    .foregroundStyle(theme.colors.textNeutral05)
                    .frame(width: 40, height: 40)
                    .background(theme.colors.surfacePrimary100)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .disabled(text.isEmpty)
            .opacity(text.isEmpty ? 0.4 : 1)
        }
        .padding(.vertical, theme.spacing.xs)
        .padding(.horizontal, theme.spacing.sm)
        .background(theme.colors.surfaceNeutral2)
        .clipShape(Capsule())
    }
}
