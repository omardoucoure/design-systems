import SwiftUI

// MARK: - Input Variant

public enum InputVariant: Sendable {
    /// Filled background with border on all sides.
    case filled
    /// Transparent background, bottom border only.
    case lined
}

// MARK: - Input State

public enum InputState: Sendable {
    case empty
    case filled
    case active
    case error
    case validated
}

// MARK: - DSTextField

/// A themed text field with modifier-based customization.
///
/// Usage:
/// ```swift
/// // Minimal
/// DSTextField(text: $name, placeholder: "Enter your name")
///
/// // Full customization via modifiers
/// DSTextField(text: $email, placeholder: "Enter your email")
///     .label("Email")
///     .variant(.filled)
///     .inputState(email.isEmpty ? .empty : .filled)
///     .icon(.mailOpen)
///     .fieldBackground(theme.colors.surfaceNeutral05)
///
/// // Secure field
/// DSTextField(text: $password, placeholder: "Enter your password")
///     .label("Password")
///     .secure()
/// ```
public struct DSTextField: View {
    @Environment(\.theme) private var theme

    // Core (required)
    @Binding private var text: String
    private let placeholder: LocalizedStringKey

    // Configurable via modifiers (all have defaults)
    private var _label: LocalizedStringKey?
    private var _helperText: LocalizedStringKey?
    private var _variant: InputVariant = .filled
    private var _state: InputState = .empty
    private var _isSecure: Bool = false
    private var _icon: DSIcon?
    private var _iconPosition: IconPosition = .trailing
    private var _actionLabel: LocalizedStringKey?
    private var _onAction: (() -> Void)?
    private var _tintColor: Color?
    private var _fieldBackgroundColor: Color?

    @FocusState private var isFocused: Bool
    @State private var isTextHidden: Bool = true

    public enum IconPosition: Sendable {
        case leading, trailing
    }

    // MARK: - Init (minimal)

    public init(text: Binding<String>, placeholder: LocalizedStringKey) {
        self._text = text
        self.placeholder = placeholder
    }

    // MARK: - Deprecated init (backward compat)

    @available(*, deprecated, message: "Use DSTextField(text:placeholder:) with modifier chain instead")
    public init(
        text: Binding<String>,
        placeholder: LocalizedStringKey,
        label: LocalizedStringKey? = nil,
        helperText: LocalizedStringKey? = nil,
        variant: InputVariant = .filled,
        state: InputState = .empty,
        isSecure: Bool = false,
        icon: DSIcon? = nil,
        iconPosition: IconPosition = .trailing,
        actionLabel: LocalizedStringKey? = nil,
        onAction: (() -> Void)? = nil,
        tintColor: Color? = nil,
        fieldBackgroundColor: Color? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self._label = label
        self._helperText = helperText
        self._variant = variant
        self._state = state
        self._isSecure = isSecure
        self._icon = icon
        self._iconPosition = iconPosition
        self._actionLabel = actionLabel
        self._onAction = onAction
        self._tintColor = tintColor
        self._fieldBackgroundColor = fieldBackgroundColor
    }

    // MARK: - Modifiers

    public func label(_ label: LocalizedStringKey) -> Self {
        var copy = self
        copy._label = label
        return copy
    }

    public func helperText(_ text: LocalizedStringKey) -> Self {
        var copy = self
        copy._helperText = text
        return copy
    }

    public func variant(_ variant: InputVariant) -> Self {
        var copy = self
        copy._variant = variant
        return copy
    }

    public func inputState(_ state: InputState) -> Self {
        var copy = self
        copy._state = state
        return copy
    }

    public func secure(_ isSecure: Bool = true) -> Self {
        var copy = self
        copy._isSecure = isSecure
        return copy
    }

    public func icon(_ icon: DSIcon, position: IconPosition = .trailing) -> Self {
        var copy = self
        copy._icon = icon
        copy._iconPosition = position
        return copy
    }

    public func actionButton(_ label: LocalizedStringKey, action: @escaping () -> Void) -> Self {
        var copy = self
        copy._actionLabel = label
        copy._onAction = action
        return copy
    }

    public func fieldBackground(_ color: Color) -> Self {
        var copy = self
        copy._fieldBackgroundColor = color
        return copy
    }

    public func inputTint(_ color: Color) -> Self {
        var copy = self
        copy._tintColor = color
        return copy
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.xxs) {
            inputContainer
            helperTextView
        }
    }

    // MARK: - Input Container

    private var inputContainer: some View {
        HStack(spacing: theme.components.textField.contentGap) {
            if let _icon, _iconPosition == .leading {
                iconView(_icon)
            }

            VStack(alignment: .leading, spacing: 0) {
                if showFloatingLabel {
                    Text(_label ?? placeholder)
                        .font(theme.typography.small.font)
                        .tracking(theme.typography.small.tracking)
                        .foregroundStyle(resolvedTint.opacity(0.75))
                }

                Group {
                    if _isSecure && isTextHidden {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                    }
                }
                .font(theme.typography.body.font)
                .tracking(theme.typography.body.tracking)
                .foregroundStyle(resolvedTint.opacity(textOpacity))
                .focused($isFocused)
            }

            if _isSecure {
                Button {
                    isTextHidden.toggle()
                } label: {
                    iconView(isTextHidden ? .eyeClosed : .eye)
                }
                .buttonStyle(.plain)
            } else if let _icon, _iconPosition == .trailing {
                iconView(_icon)
            }

            if let _actionLabel, let _onAction {
                DSButton(_actionLabel, action: _onAction).buttonStyle(.filledA).buttonSize(.small)
            }
        }
        .padding(.horizontal, theme.spacing.md)
        .padding(.vertical, theme.spacing.md)
        .frame(height: theme.components.textField.fieldHeight)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: containerRadius))
        .overlay(borderOverlay)
    }

    private func iconView(_ dsIcon: DSIcon) -> some View {
        Image(dsIcon: dsIcon)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(iconColor)
            .frame(width: theme.components.textField.iconFrame, height: theme.components.textField.iconFrame)
    }

    // MARK: - Helper Text

    @ViewBuilder
    private var helperTextView: some View {
        if let _helperText {
            Text(_helperText)
                .font(theme.typography.caption.font)
                .tracking(theme.typography.caption.tracking)
                .foregroundStyle(helperTextColor)
                .padding(.leading, theme.spacing.md)
        }
    }

    // MARK: - Resolved Styles

    private var showFloatingLabel: Bool {
        switch _state {
        case .filled, .active, .error, .validated:
            return _label != nil || !text.isEmpty
        case .empty:
            return false
        }
    }

    private var textOpacity: Double {
        _state == .empty ? 0.5 : 1.0
    }

    private var resolvedTint: Color {
        _tintColor ?? theme.colors.textNeutral9
    }

    private var backgroundColor: Color {
        if let _fieldBackgroundColor { return _fieldBackgroundColor }
        switch _variant {
        case .filled: return theme.colors.surfaceNeutral05
        case .lined: return .clear
        }
    }

    private var containerRadius: CGFloat {
        _variant == .filled ? theme.radius.md : 0
    }

    private var borderOverlay: some View {
        Group {
            switch _variant {
            case .filled:
                RoundedRectangle(cornerRadius: theme.radius.md)
                    .stroke(borderColor, lineWidth: borderWidth)
            case .lined:
                VStack {
                    Spacer()
                    Rectangle()
                        .fill(borderColor)
                        .frame(height: borderWidth)
                }
            }
        }
    }

    private var borderWidth: CGFloat {
        switch _variant {
        case .filled:
            return theme.borders.widthMd
        case .lined:
            switch _state {
            case .active, .error, .validated: return theme.borders.widthMd
            case .empty, .filled: return theme.borders.widthSm
            }
        }
    }

    private var borderColor: Color {
        switch _state {
        case .active: return theme.colors.infoFocus
        case .error: return theme.colors.error
        case .validated: return theme.colors.validated
        case .empty, .filled:
            return _variant == .filled ? theme.colors.borderNeutral2 : theme.colors.borderNeutral95
        }
    }

    private var iconColor: Color {
        resolvedTint.opacity(textOpacity)
    }

    private var helperTextColor: Color {
        _state == .error ? theme.colors.error : resolvedTint.opacity(theme.opacity.md)
    }
}
