import SwiftUI

/// A themed multi-line text area with an optional title.
///
/// Usage (modifier-based):
/// ```swift
/// DSTextArea(text: $notes)
///     .title("Notes")
///     .placeholder("Add your notes here...")
///     .minHeight(200)
/// ```
public struct DSTextArea: View {
    @Environment(\.theme) private var theme

    @Binding private var _text: String
    private var _title: LocalizedStringKey?
    private var _placeholder: LocalizedStringKey = "Enter text..."
    private var _minHeight: CGFloat = 120

    // MARK: - Minimal init

    public init(text: Binding<String>) {
        self.__text = text
    }

    // MARK: - Deprecated init

    @available(*, deprecated, message: "Use DSTextArea(text:) with .title(), .placeholder(), .minHeight() modifiers instead")
    public init(
        text: Binding<String>,
        title: LocalizedStringKey?,
        placeholder: LocalizedStringKey = "Enter text...",
        minHeight: CGFloat = 120
    ) {
        self.__text = text
        self._title = title
        self._placeholder = placeholder
        self._minHeight = minHeight
    }

    // MARK: - Modifiers

    public func title(_ value: LocalizedStringKey) -> DSTextArea {
        var copy = self
        copy._title = value
        return copy
    }

    public func placeholder(_ value: LocalizedStringKey) -> DSTextArea {
        var copy = self
        copy._placeholder = value
        return copy
    }

    public func minHeight(_ value: CGFloat) -> DSTextArea {
        var copy = self
        copy._minHeight = value
        return copy
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.xs) {
            if let _title {
                Text(_title)
                    .font(theme.typography.bodySemiBold.font)
                    .tracking(theme.typography.bodySemiBold.tracking)
                    .foregroundStyle(theme.colors.textNeutral9)
            }

            ZStack(alignment: .topLeading) {
                if _text.isEmpty {
                    Text(_placeholder)
                        .font(theme.typography.bodyRegular.font)
                        .tracking(theme.typography.bodyRegular.tracking)
                        .foregroundStyle(theme.colors.textNeutral9.opacity(0.5))
                        .padding(.top, 8)
                        .padding(.leading, 4)
                }

                TextEditor(text: $_text)
                    .font(theme.typography.bodyRegular.font)
                    .tracking(theme.typography.bodyRegular.tracking)
                    .foregroundStyle(theme.colors.textNeutral9.opacity(0.75))
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: _minHeight)
            }
        }
        .padding(theme.spacing.md)
        .background(theme.colors.surfaceNeutral2)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.lg))
    }
}
