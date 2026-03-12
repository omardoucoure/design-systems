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
    private let icon: DSIcon?
    private let iconPosition: IconPosition
    private let isSecure: Bool
    private let actionLabel: LocalizedStringKey?
    private let onAction: (() -> Void)?
    private let tintColor: Color?
    private let fieldBackgroundColor: Color?

    @FocusState private var isFocused: Bool
    @State private var isTextHidden: Bool = true

    public enum IconPosition {
        case leading, trailing
    }

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
        self.label = label
        self.helperText = helperText
        self.variant = variant
        self.state = state
        self.isSecure = isSecure
        self.icon = icon
        self.iconPosition = iconPosition
        self.actionLabel = actionLabel
        self.onAction = onAction
        self.tintColor = tintColor
        self.fieldBackgroundColor = fieldBackgroundColor
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
            // Leading icon
            if let icon, iconPosition == .leading {
                iconView(icon)
            }

            // Text field + floating label
            VStack(alignment: .leading, spacing: 0) {
                if showFloatingLabel {
                    Text(label ?? placeholder)
                        .font(theme.typography.small.font)
                        .tracking(theme.typography.small.tracking)
                        .foregroundStyle(resolvedTint.opacity(0.75))
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
                .foregroundStyle(resolvedTint.opacity(textOpacity))
                .focused($isFocused)
            }

            // Trailing: secure toggle or trailing icon
            if isSecure {
                Button {
                    isTextHidden.toggle()
                } label: {
                    iconView(isTextHidden ? .eyeClosed : .eye)
                }
                .buttonStyle(.plain)
            } else if let icon, iconPosition == .trailing {
                iconView(icon)
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

    private var resolvedTint: Color {
        tintColor ?? theme.colors.textNeutral9
    }

    private var backgroundColor: Color {
        if let fieldBackgroundColor { return fieldBackgroundColor }
        switch variant {
        case .filled:
            return theme.colors.surfaceNeutral0_5
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
        switch variant {
        case .filled:
            // Figma: filled variant always uses borderwidth-md (2px) for all states
            return theme.borders.widthMd
        case .lined:
            switch state {
            case .active, .error, .validated:
                return theme.borders.widthMd
            case .empty, .filled:
                return theme.borders.widthSm
            }
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
        resolvedTint.opacity(textOpacity)
    }

    private var helperTextColor: Color {
        switch state {
        case .error: return theme.colors.error
        default: return resolvedTint.opacity(theme.opacity.md)
        }
    }
}
