import SwiftUI

/// A themed multi-line text area with an optional title.
///
/// Usage:
/// ```swift
/// DSTextArea(text: $notes, title: "Notes", placeholder: "Add your notes here...")
/// ```
public struct DSTextArea: View {
    @Environment(\.theme) private var theme

    @Binding private var text: String
    private let title: LocalizedStringKey?
    private let placeholder: LocalizedStringKey
    private let minHeight: CGFloat

    public init(
        text: Binding<String>,
        title: LocalizedStringKey? = nil,
        placeholder: LocalizedStringKey = "Enter text...",
        minHeight: CGFloat = 120
    ) {
        self._text = text
        self.title = title
        self.placeholder = placeholder
        self.minHeight = minHeight
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.xs) {
            if let title {
                Text(title)
                    .font(theme.typography.bodySemiBold.font)
                    .tracking(theme.typography.bodySemiBold.tracking)
                    .foregroundStyle(theme.colors.textNeutral9)
            }

            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(theme.typography.bodyRegular.font)
                        .tracking(theme.typography.bodyRegular.tracking)
                        .foregroundStyle(theme.colors.textNeutral9.opacity(0.5))
                        .padding(.top, 8)
                        .padding(.leading, 4)
                }

                TextEditor(text: $text)
                    .font(theme.typography.bodyRegular.font)
                    .tracking(theme.typography.bodyRegular.tracking)
                    .foregroundStyle(theme.colors.textNeutral9.opacity(0.75))
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: minHeight)
            }
        }
        .padding(theme.spacing.md)
        .background(theme.colors.surfaceNeutral2)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.lg))
    }
}
