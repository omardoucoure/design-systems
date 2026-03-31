import SwiftUI

// MARK: - Chip Style

public enum DSChipStyle: Sendable, CaseIterable {
    /// Secondary-colored background (brand accent).
    case filledA
    /// Primary-colored background.
    case filledB
    /// Primary-120 background.
    case filledC
    /// Neutral-2 background.
    case neutral
    /// Transparent with primary-120 border.
    case outlined
}

// MARK: - DSChip

/// A themed chip/tag component with dismiss support.
///
/// **Modifier-based API (preferred):**
/// ```swift
/// DSChip("Swift")
///     .chipStyle(.filledA)
///
/// DSChip("iOS")
///     .chipStyle(.outlined)
///     .onDismiss { remove() }
///     .onTap { filter("ios") }
/// ```
///
/// **Legacy init (deprecated):**
/// ```swift
/// DSChip("Swift", style: .filledA, onTap: { }, onDismiss: { })
/// ```
public struct DSChip: View {
    @Environment(\.theme) private var theme
    @Environment(\.isEnabled) private var isEnabled

    private let label: LocalizedStringKey
    private var _style: DSChipStyle = .filledA
    private var _onDismiss: (() -> Void)?
    private var _onTap: (() -> Void)?

    // MARK: - Modifier-based init (preferred)

    public init(_ label: LocalizedStringKey) {
        self.label = label
    }

    // MARK: - Deprecated init

    @available(*, deprecated, message: "Use DSChip(_:) with .chipStyle(), .onTap(), .onDismiss() modifiers instead")
    public init(
        _ label: LocalizedStringKey,
        style: DSChipStyle,
        onTap: (() -> Void)? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        self.label = label
        self._style = style
        self._onTap = onTap
        self._onDismiss = onDismiss
    }

    // MARK: - Modifiers

    public func chipStyle(_ style: DSChipStyle) -> DSChip {
        var copy = self
        copy._style = style
        return copy
    }

    public func onTap(_ action: @escaping () -> Void) -> DSChip {
        var copy = self
        copy._onTap = action
        return copy
    }

    public func onDismiss(_ action: @escaping () -> Void) -> DSChip {
        var copy = self
        copy._onDismiss = action
        return copy
    }

    // MARK: - Body

    public var body: some View {
        HStack(spacing: theme.spacing.xs) {
            Text(label)
                .font(theme.typography.label.font)
                .tracking(theme.typography.label.tracking)

            if let _onDismiss {
                Button(action: _onDismiss) {
                    Image(systemName: "xmark")
                        .font(.system(size: 10, weight: .bold))
                }
                .buttonStyle(.plain)
            }
        }
        .foregroundStyle(foregroundColor)
        .padding(.horizontal, theme.spacing.sm)
        .padding(.vertical, theme.spacing.xxs)
        .frame(height: 32)
        .background(backgroundColor)
        .clipShape(Capsule())
        .overlay(borderOverlay)
        .opacity(isEnabled ? 1.0 : 0.5)
        .onTapGesture { _onTap?() }
    }

    private var backgroundColor: Color {
        switch _style {
        case .filledA: return theme.colors.surfaceSecondary100
        case .filledB: return theme.colors.surfacePrimary100
        case .filledC: return theme.colors.surfacePrimary120
        case .neutral: return theme.colors.surfaceNeutral2
        case .outlined: return .clear
        }
    }

    private var foregroundColor: Color {
        switch _style {
        case .filledA, .neutral, .outlined:
            return theme.colors.textNeutral9
        case .filledB, .filledC:
            return theme.colors.textNeutral05
        }
    }

    @ViewBuilder
    private var borderOverlay: some View {
        if _style == .outlined {
            Capsule()
                .stroke(theme.colors.surfacePrimary120, lineWidth: theme.borders.widthSm)
        }
    }
}
