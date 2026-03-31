import SwiftUI

// MARK: - DSSearchField

/// A themed search field with search icon and clear button.
///
/// Modifier-based API:
/// ```swift
/// DSSearchField(text: $query)
///     .placeholder("Search items...")
///     .variant(.lined)
///     .onSearchSubmit { performSearch() }
/// ```
public struct DSSearchField: View {
    @Environment(\.theme) private var theme

    @Binding private var _text: String
    private var _placeholder: LocalizedStringKey = "Search"
    private var _variant: InputVariant = .filled
    private var _onSubmit: (() -> Void)?

    @FocusState private var isFocused: Bool

    // MARK: - Minimal init

    public init(text: Binding<String>) {
        self.__text = text
    }

    // MARK: - Deprecated init

    @available(*, deprecated, message: "Use DSSearchField(text:) with .placeholder(), .variant(), .onSearchSubmit() modifiers instead")
    public init(
        text: Binding<String>,
        placeholder: LocalizedStringKey,
        variant: InputVariant = .filled,
        onSubmit: (() -> Void)? = nil
    ) {
        self.__text = text
        self._placeholder = placeholder
        self._variant = variant
        self._onSubmit = onSubmit
    }

    // MARK: - Modifiers

    public func placeholder(_ value: LocalizedStringKey) -> DSSearchField {
        var copy = self
        copy._placeholder = value
        return copy
    }

    public func variant(_ value: InputVariant) -> DSSearchField {
        var copy = self
        copy._variant = value
        return copy
    }

    public func onSearchSubmit(_ action: @escaping () -> Void) -> DSSearchField {
        var copy = self
        copy._onSubmit = action
        return copy
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 20))
                .foregroundStyle(theme.colors.textNeutral9.opacity(isFocused ? 1.0 : 0.5))
                .frame(width: 24, height: 24)

            TextField(_placeholder, text: $_text)
                .font(theme.typography.body.font)
                .tracking(theme.typography.body.tracking)
                .foregroundStyle(theme.colors.textNeutral9)
                .focused($isFocused)
                .onSubmit { _onSubmit?() }

            if !_text.isEmpty {
                Button {
                    _text = ""
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
        switch _variant {
        case .filled:
            return isFocused ? theme.colors.surfaceNeutral05 : theme.colors.surfaceNeutral2
        case .lined:
            return .clear
        }
    }

    private var containerRadius: CGFloat {
        switch _variant {
        case .filled: return theme.radius.md
        case .lined: return 0
        }
    }

    private var border: some View {
        Group {
            switch _variant {
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
                        .fill(isFocused ? theme.colors.infoFocus : theme.colors.borderNeutral95)
                        .frame(height: theme.borders.widthSm)
                }
            }
        }
    }
}
