import SwiftUI

// MARK: - DSSearchField

/// A themed search field with search icon and clear button.
///
/// Usage:
/// ```swift
/// DSSearchField(text: $query, placeholder: "Search...")
/// ```
public struct DSSearchField: View {
    @Environment(\.theme) private var theme

    @Binding private var text: String
    private let placeholder: LocalizedStringKey
    private let variant: InputVariant
    private let onSubmit: (() -> Void)?

    @FocusState private var isFocused: Bool

    public init(
        text: Binding<String>,
        placeholder: LocalizedStringKey = "Search",
        variant: InputVariant = .filled,
        onSubmit: (() -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.variant = variant
        self.onSubmit = onSubmit
    }

    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 20))
                .foregroundStyle(theme.colors.textNeutral9.opacity(isFocused ? 1.0 : 0.5))
                .frame(width: 24, height: 24)

            TextField(placeholder, text: $text)
                .font(theme.typography.body.font)
                .tracking(theme.typography.body.tracking)
                .foregroundStyle(theme.colors.textNeutral9)
                .focused($isFocused)
                .onSubmit { onSubmit?() }

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(theme.colors.textNeutral9.opacity(0.5))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, theme.spacing.md)
        .padding(.vertical, theme.spacing.md)
        .frame(height: 56)
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: containerRadius))
        .overlay(border)
    }

    private var background: Color {
        switch variant {
        case .filled:
            return isFocused ? theme.colors.surfaceNeutral0_5 : theme.colors.surfaceNeutral2
        case .lined:
            return .clear
        }
    }

    private var containerRadius: CGFloat {
        switch variant {
        case .filled: return theme.radius.md
        case .lined: return 0
        }
    }

    private var border: some View {
        Group {
            switch variant {
            case .filled:
                RoundedRectangle(cornerRadius: theme.radius.md)
                    .stroke(
                        isFocused ? theme.colors.infoFocus : theme.colors.borderNeutral2,
                        lineWidth: theme.borders.widthSm
                    )
            case .lined:
                VStack {
                    Spacer()
                    Rectangle()
                        .fill(isFocused ? theme.colors.infoFocus : theme.colors.borderNeutral9_5)
                        .frame(height: theme.borders.widthSm)
                }
            }
        }
    }
}
