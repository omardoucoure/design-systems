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

/// A themed text field with two visual variants and five states.
///
/// Usage:
/// ```swift
/// DSTextField(
///     text: $name,
///     placeholder: "Enter your name",
///     variant: .filled,
///     state: .empty
/// )
/// ```
public struct DSTextField: View {
    @Environment(\.theme) private var theme

    @Binding private var text: String
    private let placeholder: LocalizedStringKey
    private let label: LocalizedStringKey?
    private let helperText: LocalizedStringKey?
    private let variant: InputVariant
    private let state: InputState
    private let iconLeft: String?
    private let isSecure: Bool
    private let iconRight: String?
    private let actionLabel: LocalizedStringKey?
    private let onAction: (() -> Void)?

    @FocusState private var isFocused: Bool
    @State private var isTextHidden: Bool = true

    public init(
        text: Binding<String>,
        placeholder: LocalizedStringKey,
        label: LocalizedStringKey? = nil,
        helperText: LocalizedStringKey? = nil,
        variant: InputVariant = .filled,
        state: InputState = .empty,
        isSecure: Bool = false,
        iconLeft: String? = nil,
        iconRight: String? = nil,
        actionLabel: LocalizedStringKey? = nil,
        onAction: (() -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.label = label
        self.helperText = helperText
        self.variant = variant
        self.state = state
        self.isSecure = isSecure
        self.iconLeft = iconLeft
        self.iconRight = iconRight
        self.actionLabel = actionLabel
        self.onAction = onAction
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.xxs) {
            inputContainer
            helperTextView
        }
    }

    // MARK: - Input Container

    private var inputContainer: some View {
        HStack(spacing: theme.components.textField.contentGap) {
            // Left icon
            if let iconLeft {
                Image(systemName: iconLeft)
                    .font(.system(size: theme.components.textField.iconSize))
                    .foregroundStyle(iconColor)
                    .frame(width: theme.components.textField.iconFrame, height: theme.components.textField.iconFrame)
            }

            // Text field + floating label
            VStack(alignment: .leading, spacing: 0) {
                if showFloatingLabel {
                    Text(label ?? placeholder)
                        .font(theme.typography.small.font)
                        .tracking(theme.typography.small.tracking)
                        .foregroundStyle(theme.colors.textNeutral9.opacity(0.75))
                }

                Group {
                    if isSecure && isTextHidden {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                    }
                }
                .font(theme.typography.body.font)
                .tracking(theme.typography.body.tracking)
                .foregroundStyle(theme.colors.textNeutral9.opacity(textOpacity))
                .focused($isFocused)
            }

            // Right icon (tappable toggle when secure)
            if isSecure {
                Button {
                    isTextHidden.toggle()
                } label: {
                    Image(systemName: isTextHidden ? "eye.slash" : "eye")
                        .font(.system(size: theme.components.textField.iconSize))
                        .foregroundStyle(iconColor)
                        .frame(width: theme.components.textField.iconFrame, height: theme.components.textField.iconFrame)
                }
                .buttonStyle(.plain)
            } else if let iconRight {
                Image(systemName: iconRight)
                    .font(.system(size: theme.components.textField.iconSize))
                    .foregroundStyle(iconColor)
                    .frame(width: theme.components.textField.iconFrame, height: theme.components.textField.iconFrame)
            }

            // Action button
            if let actionLabel, let onAction {
                DSButton(actionLabel, style: .filledA, size: .small, action: onAction)
            }
        }
        .padding(.horizontal, theme.spacing.md)
        .padding(.vertical, theme.spacing.md)
        .frame(height: theme.components.textField.fieldHeight)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: containerRadius))
        .overlay(borderOverlay)
    }

    // MARK: - Helper Text

    @ViewBuilder
    private var helperTextView: some View {
        if let helperText {
            Text(helperText)
                .font(theme.typography.caption.font)
                .tracking(theme.typography.caption.tracking)
                .foregroundStyle(helperTextColor)
                .padding(.leading, theme.spacing.md)
        }
    }

    // MARK: - Resolved Styles

    private var showFloatingLabel: Bool {
        switch state {
        case .filled, .active, .error, .validated:
            return label != nil || !text.isEmpty
        case .empty:
            return false
        }
    }

    private var textOpacity: Double {
        switch state {
        case .empty: return 0.5
        default: return 1.0
        }
    }

    private var backgroundColor: Color {
        switch variant {
        case .filled:
            return theme.colors.surfaceNeutral2
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

    private var borderOverlay: some View {
        Group {
            switch variant {
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
        switch state {
        case .error, .active, .validated:
            return theme.borders.widthMd
        case .empty, .filled:
            return theme.borders.widthSm
        }
    }

    private var borderColor: Color {
        switch state {
        case .active: return theme.colors.infoFocus
        case .error: return theme.colors.error
        case .validated: return theme.colors.validated
        case .empty, .filled:
            switch variant {
            case .filled: return theme.colors.borderNeutral2
            case .lined: return theme.colors.borderNeutral9_5
            }
        }
    }

    private var iconColor: Color {
        theme.colors.textNeutral9.opacity(textOpacity)
    }

    private var helperTextColor: Color {
        switch state {
        case .error: return theme.colors.error
        default: return theme.colors.textNeutral9.opacity(theme.opacity.md)
        }
    }
}
