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

/// A themed button matching all 6 Figma styles × 3 sizes.
///
/// Usage:
/// ```swift
/// DSButton("Save", style: .filledB, size: .big) { save() }
/// DSButton("Cancel", style: .text, size: .medium) { cancel() }
/// DSButton(style: .neutral, size: .big, systemIcon: "xmark") { dismiss() }
/// ```
public struct DSButton: View {
    @Environment(\.theme) private var theme
    @Environment(\.isEnabled) private var isEnabled

    private let label: LocalizedStringKey?
    private let style: DSButtonStyle
    private let size: DSButtonSize
    private let iconLeft: String?
    private let iconRight: String?
    private let isSystemIcon: Bool
    private let isFullWidth: Bool
    private let action: () -> Void

    /// Text button with optional SF Symbol icons.
    public init(
        _ label: LocalizedStringKey,
        style: DSButtonStyle = .filledB,
        size: DSButtonSize = .big,
        iconLeft: String? = nil,
        iconRight: String? = nil,
        isFullWidth: Bool = false,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.style = style
        self.size = size
        self.iconLeft = iconLeft
        self.iconRight = iconRight
        self.isSystemIcon = true
        self.isFullWidth = isFullWidth
        self.action = action
    }

    /// Icon-only button with SF Symbol.
    public init(
        style: DSButtonStyle = .neutral,
        size: DSButtonSize = .big,
        systemIcon: String,
        isFullWidth: Bool = false,
        action: @escaping () -> Void
    ) {
        self.label = nil
        self.style = style
        self.size = size
        self.iconLeft = systemIcon
        self.iconRight = nil
        self.isSystemIcon = true
        self.isFullWidth = isFullWidth
        self.action = action
    }

    /// Icon-only button with custom asset image.
    public init(
        style: DSButtonStyle = .neutral,
        size: DSButtonSize = .big,
        assetIcon: String,
        isFullWidth: Bool = false,
        action: @escaping () -> Void
    ) {
        self.label = nil
        self.style = style
        self.size = size
        self.iconLeft = assetIcon
        self.iconRight = nil
        self.isSystemIcon = false
        self.isFullWidth = isFullWidth
        self.action = action
    }

    /// Text button with a custom asset icon (left or right).
    public init(
        _ label: LocalizedStringKey,
        style: DSButtonStyle = .filledB,
        size: DSButtonSize = .big,
        assetIcon: String,
        iconPosition: IconPosition = .left,
        isFullWidth: Bool = false,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.style = style
        self.size = size
        self.iconLeft = iconPosition == .left ? assetIcon : nil
        self.iconRight = iconPosition == .right ? assetIcon : nil
        self.isSystemIcon = false
        self.isFullWidth = isFullWidth
        self.action = action
    }

    /// Icon-only button with DSIcon enum.
    public init(
        style: DSButtonStyle = .neutral,
        size: DSButtonSize = .big,
        icon: DSIcon,
        isFullWidth: Bool = false,
        action: @escaping () -> Void
    ) {
        self.init(style: style, size: size, assetIcon: icon.imageName, isFullWidth: isFullWidth, action: action)
    }

    /// Text button with a DSIcon enum (left or right).
    public init(
        _ label: LocalizedStringKey,
        style: DSButtonStyle = .filledB,
        size: DSButtonSize = .big,
        icon: DSIcon,
        iconPosition: IconPosition = .left,
        isFullWidth: Bool = false,
        action: @escaping () -> Void
    ) {
        self.init(label, style: style, size: size, assetIcon: icon.imageName, iconPosition: iconPosition, isFullWidth: isFullWidth, action: action)
    }

    public enum IconPosition {
        case left, right
    }

    // MARK: - Backward-compatible init

    /// Backward-compatible initializer mapping old variants.
    public init(
        _ label: LocalizedStringKey,
        variant: _LegacyButtonVariant,
        isFullWidth: Bool = false,
        action: @escaping () -> Void
    ) {
        self.label = label
        self.style = variant.mapped
        self.size = .big
        self.iconLeft = nil
        self.iconRight = nil
        self.isSystemIcon = true
        self.isFullWidth = isFullWidth
        self.action = action
    }

    public init(
        variant: _LegacyButtonVariant,
        systemIcon: String,
        action: @escaping () -> Void
    ) {
        self.label = nil
        self.style = variant.mapped
        self.size = .big
        self.iconLeft = systemIcon
        self.iconRight = nil
        self.isSystemIcon = true
        self.isFullWidth = false
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        Button(action: action) {
            HStack(spacing: gap) {
                if let iconLeft {
                    iconView(iconLeft)
                }

                if let label {
                    Text(label)
                }

                if let iconRight {
                    iconView(iconRight)
                }
            }
            .font(textFont)
            .tracking(textTracking)
            .foregroundStyle(foregroundColor)
            .padding(.horizontal, paddingH)
            .padding(.vertical, paddingV)
            .frame(height: height)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .background(backgroundColor)
            .clipShape(Capsule())
            .overlay(borderOverlay)
            .opacity(isEnabled ? 1.0 : 0.5)
        }
        .buttonStyle(DSButtonPressStyle())
    }

    @ViewBuilder
    private func iconView(_ name: String) -> some View {
        if isSystemIcon {
            Image(systemName: name)
                .font(.system(size: iconSize, weight: .medium))
                .frame(width: iconSize, height: iconSize)
        } else {
            Image(name, bundle: .main)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: iconSize, height: iconSize)
        }
    }

    // MARK: - Resolved Sizes

    private var height: CGFloat {
        switch size {
        case .big: return theme.components.button.bigHeight
        case .medium: return theme.components.button.mediumHeight
        case .small: return theme.components.button.smallHeight
        }
    }

    private var paddingH: CGFloat {
        if style == .text {
            switch size {
            case .big: return theme.spacing.md
            case .medium: return theme.spacing.xs
            case .small: return theme.spacing.xxs
            }
        }
        switch size {
        case .big: return theme.spacing.lg
        case .medium: return theme.spacing.md
        case .small: return theme.spacing.sm
        }
    }

    private var paddingV: CGFloat {
        switch size {
        case .big: return theme.spacing.md
        case .medium: return theme.spacing.xs
        case .small: return theme.spacing.xxs
        }
    }

    private var gap: CGFloat {
        switch size {
        case .big, .medium: return theme.spacing.sm
        case .small: return theme.spacing.xs
        }
    }

    private var iconSize: CGFloat {
        switch size {
        case .big, .medium: return theme.components.button.bigIconSize
        case .small: return theme.components.button.smallIconSize
        }
    }

    private var textFont: Font {
        switch size {
        case .big: return theme.typography.bodySemiBold.font
        case .medium, .small: return theme.typography.label.font
        }
    }

    private var textTracking: CGFloat {
        switch size {
        case .big: return theme.typography.bodySemiBold.tracking
        case .medium, .small: return theme.typography.label.tracking
        }
    }

    // MARK: - Resolved Colors

    private var backgroundColor: Color {
        switch style {
        case .filledA: return theme.colors.surfaceSecondary100
        case .filledB: return theme.colors.surfacePrimary100
        case .filledC: return theme.colors.surfacePrimary120
        case .neutral: return theme.colors.surfaceNeutral2
        case .neutralLight: return theme.colors.surfaceNeutral0_5
        case .outlined, .outlinedLight, .text: return .clear
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .filledA, .neutral, .neutralLight, .outlined, .text:
            return theme.colors.textNeutral9
        case .filledB, .filledC, .outlinedLight:
            return theme.colors.textNeutral0_5
        }
    }

    @ViewBuilder
    private var borderOverlay: some View {
        if style == .outlined {
            Capsule()
                .stroke(theme.colors.surfacePrimary120, lineWidth: theme.borders.widthSm)
        } else if style == .outlinedLight {
            Capsule()
                .stroke(theme.colors.surfaceNeutral0_5, lineWidth: theme.borders.widthSm)
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
