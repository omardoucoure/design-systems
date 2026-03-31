import SwiftUI

// MARK: - Button Style

public enum DSButtonStyle: Sendable, CaseIterable {
    /// Secondary-colored background, dark text.
    case filledA
    /// Primary-colored background, light text.
    case filledB
    /// Primary-120 background, light text.
    case filledC
    /// Neutral-2 background, dark text.
    case neutral
    /// Neutral-0.5 (white/cream) background, dark text. For dark backgrounds.
    case neutralLight
    /// Transparent with primary-120 border, dark text.
    case outlined
    /// Transparent with neutral-0.5 border, light text. For dark backgrounds.
    case outlinedLight
    /// No background, no border, dark text.
    case text
}

// MARK: - Button Size

public enum DSButtonSize: Sendable, CaseIterable {
    /// Height 56, icon 24, font bodySemiBold(16).
    case big
    /// Height 40, icon 24, font label(14).
    case medium
    /// Height 32, icon 20, font label(14).
    case small
}

// MARK: - DSButton

/// A themed button with modifier-based customization.
///
/// Usage:
/// ```swift
/// // Text button (minimal)
/// DSButton("Save") { save() }
///
/// // Styled text button
/// DSButton("Save") { save() }
///     .buttonStyle(.filledA)
///     .buttonSize(.big)
///     .fullWidth()
///
/// // Text + icon
/// DSButton("Let's Roll!") { go() }
///     .buttonStyle(.filledA)
///     .icon(.arrowRightLong, position: .right)
///
/// // Icon-only
/// DSButton { dismiss() }
///     .buttonStyle(.neutral)
///     .icon(.xmark)
///
/// // SF Symbol
/// DSButton { dismiss() }
///     .buttonStyle(.neutral)
///     .systemIcon("xmark")
/// ```
public struct DSButton: View {
    @Environment(\.theme) private var theme
    @Environment(\.isEnabled) private var isEnabled

    // Core
    private let _label: LocalizedStringKey?
    private let _action: () -> Void

    // Configurable via modifiers
    private var _style: DSButtonStyle = .filledB
    private var _size: DSButtonSize = .big
    private var _iconLeft: String?
    private var _iconRight: String?
    private var _isSystemIcon: Bool = true
    private var _isFullWidth: Bool = false

    public enum IconPosition: Sendable {
        case left, right
    }

    // MARK: - Inits (2 only: text button + icon-only)

    /// Text button.
    public init(_ label: LocalizedStringKey, action: @escaping () -> Void) {
        self._label = label
        self._action = action
    }

    /// Icon-only button (no label). Requires `.icon()`, `.systemIcon()`, or `.assetIcon()` modifier.
    public init(action: @escaping () -> Void) {
        self._label = nil
        self._action = action
    }

    // MARK: - Modifiers

    public func buttonStyle(_ style: DSButtonStyle) -> Self {
        var copy = self
        copy._style = style
        return copy
    }

    public func buttonSize(_ size: DSButtonSize) -> Self {
        var copy = self
        copy._size = size
        return copy
    }

    public func fullWidth(_ isFullWidth: Bool = true) -> Self {
        var copy = self
        copy._isFullWidth = isFullWidth
        return copy
    }

    /// DS icon (from the 1364 icon set).
    public func icon(_ icon: DSIcon, position: IconPosition = .left) -> Self {
        var copy = self
        copy._isSystemIcon = false
        if position == .left {
            copy._iconLeft = icon.imageName
            copy._iconRight = nil
        } else {
            copy._iconLeft = nil
            copy._iconRight = icon.imageName
        }
        return copy
    }

    /// SF Symbol icon.
    public func systemIcon(_ name: String, position: IconPosition = .left) -> Self {
        var copy = self
        copy._isSystemIcon = true
        if position == .left {
            copy._iconLeft = name
            copy._iconRight = nil
        } else {
            copy._iconLeft = nil
            copy._iconRight = name
        }
        return copy
    }

    /// Custom asset image icon.
    public func assetIcon(_ name: String, position: IconPosition = .left) -> Self {
        var copy = self
        copy._isSystemIcon = false
        if position == .left {
            copy._iconLeft = name
            copy._iconRight = nil
        } else {
            copy._iconLeft = nil
            copy._iconRight = name
        }
        return copy
    }

    // MARK: - Deprecated inits (backward compat)

    @available(*, deprecated, message: "Use DSButton(label) { action }.buttonStyle(.x).buttonSize(.y) instead")
    public init(
        _ label: LocalizedStringKey,
        style: DSButtonStyle,
        size: DSButtonSize = .big,
        iconLeft: String? = nil,
        iconRight: String? = nil,
        isFullWidth: Bool = false,
        action: @escaping () -> Void
    ) {
        self._label = label
        self._action = action
        self._style = style
        self._size = size
        self._iconLeft = iconLeft
        self._iconRight = iconRight
        self._isSystemIcon = true
        self._isFullWidth = isFullWidth
    }

    @available(*, deprecated, message: "Use DSButton { action }.buttonStyle(.x).systemIcon(name) instead")
    public init(
        style: DSButtonStyle,
        size: DSButtonSize = .big,
        systemIcon: String,
        isFullWidth: Bool = false,
        action: @escaping () -> Void
    ) {
        self._label = nil
        self._action = action
        self._style = style
        self._size = size
        self._iconLeft = systemIcon
        self._iconRight = nil
        self._isSystemIcon = true
        self._isFullWidth = isFullWidth
    }

    @available(*, deprecated, message: "Use DSButton { action }.buttonStyle(.x).assetIcon(name) instead")
    public init(
        style: DSButtonStyle,
        size: DSButtonSize = .big,
        assetIcon: String,
        isFullWidth: Bool = false,
        action: @escaping () -> Void
    ) {
        self._label = nil
        self._action = action
        self._style = style
        self._size = size
        self._iconLeft = assetIcon
        self._iconRight = nil
        self._isSystemIcon = false
        self._isFullWidth = isFullWidth
    }

    @available(*, deprecated, message: "Use DSButton(label) { action }.buttonStyle(.x).assetIcon(name, position:) instead")
    public init(
        _ label: LocalizedStringKey,
        style: DSButtonStyle,
        size: DSButtonSize = .big,
        assetIcon: String,
        iconPosition: IconPosition = .left,
        isFullWidth: Bool = false,
        action: @escaping () -> Void
    ) {
        self._label = label
        self._action = action
        self._style = style
        self._size = size
        self._iconLeft = iconPosition == .left ? assetIcon : nil
        self._iconRight = iconPosition == .right ? assetIcon : nil
        self._isSystemIcon = false
        self._isFullWidth = isFullWidth
    }

    @available(*, deprecated, message: "Use DSButton { action }.buttonStyle(.x).icon(.y) instead")
    public init(
        style: DSButtonStyle,
        size: DSButtonSize = .big,
        icon: DSIcon,
        isFullWidth: Bool = false,
        action: @escaping () -> Void
    ) {
        self.init(style: style, size: size, assetIcon: icon.imageName, isFullWidth: isFullWidth, action: action)
    }

    @available(*, deprecated, message: "Use DSButton(label) { action }.buttonStyle(.x).icon(.y, position:) instead")
    public init(
        _ label: LocalizedStringKey,
        style: DSButtonStyle,
        size: DSButtonSize = .big,
        icon: DSIcon,
        iconPosition: IconPosition = .left,
        isFullWidth: Bool = false,
        action: @escaping () -> Void
    ) {
        self.init(label, style: style, size: size, assetIcon: icon.imageName, iconPosition: iconPosition, isFullWidth: isFullWidth, action: action)
    }

    @available(*, deprecated, message: "Use new DSButton API with .buttonStyle() modifier")
    public init(
        _ label: LocalizedStringKey,
        variant: _LegacyButtonVariant,
        isFullWidth: Bool = false,
        action: @escaping () -> Void
    ) {
        self._label = label
        self._action = action
        self._style = variant.mapped
        self._size = .big
        self._iconLeft = nil
        self._iconRight = nil
        self._isSystemIcon = true
        self._isFullWidth = isFullWidth
    }

    @available(*, deprecated, message: "Use new DSButton API with .buttonStyle() modifier")
    public init(
        variant: _LegacyButtonVariant,
        systemIcon: String,
        action: @escaping () -> Void
    ) {
        self._label = nil
        self._action = action
        self._style = variant.mapped
        self._size = .big
        self._iconLeft = systemIcon
        self._iconRight = nil
        self._isSystemIcon = true
        self._isFullWidth = false
    }

    // MARK: - Body

    public var body: some View {
        Button(action: _action) {
            HStack(spacing: gap) {
                if let _iconLeft {
                    iconView(_iconLeft)
                }

                if let _label {
                    Text(_label)
                }

                if let _iconRight {
                    iconView(_iconRight)
                }
            }
            .font(textFont)
            .tracking(textTracking)
            .foregroundStyle(foregroundColor)
            .padding(.horizontal, paddingH)
            .padding(.vertical, paddingV)
            .frame(height: height)
            .frame(maxWidth: _isFullWidth ? .infinity : nil)
            .background(backgroundColor)
            .clipShape(Capsule())
            .overlay(borderOverlay)
            .opacity(isEnabled ? 1.0 : 0.5)
        }
        .buttonStyle(DSButtonPressStyle())
    }

    @ViewBuilder
    private func iconView(_ name: String) -> some View {
        if _isSystemIcon {
            Image(systemName: name)
                .font(.system(size: iconSize, weight: .medium))
                .frame(width: iconSize, height: iconSize)
        } else if let dsIcon = DSIcon(rawValue: name) {
            Image(dsIcon: dsIcon)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: iconSize, height: iconSize)
        } else {
            Image(name, bundle: .main)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: iconSize, height: iconSize)
        }
    }

    // MARK: - Resolved Sizes

    private var height: CGFloat {
        switch _size {
        case .big: return theme.components.button.bigHeight
        case .medium: return theme.components.button.mediumHeight
        case .small: return theme.components.button.smallHeight
        }
    }

    private var paddingH: CGFloat {
        if _style == .text {
            switch _size {
            case .big: return theme.spacing.md
            case .medium: return theme.spacing.xs
            case .small: return theme.spacing.xxs
            }
        }
        switch _size {
        case .big: return theme.spacing.lg
        case .medium: return theme.spacing.md
        case .small: return theme.spacing.sm
        }
    }

    private var paddingV: CGFloat {
        switch _size {
        case .big: return theme.spacing.md
        case .medium: return theme.spacing.xs
        case .small: return theme.spacing.xxs
        }
    }

    private var gap: CGFloat {
        switch _size {
        case .big, .medium: return theme.spacing.sm
        case .small: return theme.spacing.xs
        }
    }

    private var iconSize: CGFloat {
        switch _size {
        case .big, .medium: return theme.components.button.bigIconSize
        case .small: return theme.components.button.smallIconSize
        }
    }

    private var textFont: Font {
        switch _size {
        case .big: return theme.typography.bodySemiBold.font
        case .medium, .small: return theme.typography.label.font
        }
    }

    private var textTracking: CGFloat {
        switch _size {
        case .big: return theme.typography.bodySemiBold.tracking
        case .medium, .small: return theme.typography.label.tracking
        }
    }

    // MARK: - Resolved Colors

    private var backgroundColor: Color {
        switch _style {
        case .filledA: return theme.colors.surfaceSecondary100
        case .filledB: return theme.colors.surfacePrimary100
        case .filledC: return theme.colors.surfacePrimary120
        case .neutral: return theme.colors.surfaceNeutral2
        case .neutralLight: return theme.colors.surfaceNeutral05
        case .outlined, .outlinedLight, .text: return .clear
        }
    }

    private var foregroundColor: Color {
        switch _style {
        case .filledA, .neutral, .neutralLight, .outlined, .text:
            return theme.colors.textNeutral9
        case .filledB, .filledC, .outlinedLight:
            return theme.colors.textNeutral05
        }
    }

    @ViewBuilder
    private var borderOverlay: some View {
        if _style == .outlined {
            Capsule()
                .stroke(theme.colors.surfacePrimary120, lineWidth: theme.borders.widthSm)
        } else if _style == .outlinedLight {
            Capsule()
                .stroke(theme.colors.surfaceNeutral05, lineWidth: theme.borders.widthSm)
        }
    }
}

// MARK: - Press Style

private struct DSButtonPressStyle: ButtonStyle {
    @Environment(\.theme) private var theme

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? theme.components.button.pressedOpacity : 1.0)
            .scaleEffect(configuration.isPressed ? theme.components.button.pressedScale : 1.0)
            .animation(.easeInOut(duration: theme.components.button.pressedAnimationDuration), value: configuration.isPressed)
    }
}

// MARK: - Legacy Compat

public enum _LegacyButtonVariant: Sendable {
    case primary, secondary, ghost, icon

    var mapped: DSButtonStyle {
        switch self {
        case .primary: return .filledC
        case .secondary: return .filledA
        case .ghost: return .text
        case .icon: return .neutral
        }
    }
}
