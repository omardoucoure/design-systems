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
/// Usage:
/// ```swift
/// DSChip("Swift", style: .filledA)
/// DSChip("iOS", style: .outlined, onDismiss: { remove() })
/// ```
public struct DSChip: View {
    @Environment(\.theme) private var theme
    @Environment(\.isEnabled) private var isEnabled

    private let label: LocalizedStringKey
    private let style: DSChipStyle
    private let onDismiss: (() -> Void)?
    private let onTap: (() -> Void)?

    public init(
        _ label: LocalizedStringKey,
        style: DSChipStyle = .filledA,
        onTap: (() -> Void)? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        self.label = label
        self.style = style
        self.onTap = onTap
        self.onDismiss = onDismiss
    }

    public var body: some View {
        HStack(spacing: theme.spacing.xs) {
            Text(label)
                .font(theme.typography.label.font)
                .tracking(theme.typography.label.tracking)

            if let onDismiss {
                Button(action: onDismiss) {
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
        .onTapGesture { onTap?() }
    }

    private var backgroundColor: Color {
        switch style {
        case .filledA: return theme.colors.surfaceSecondary100
        case .filledB: return theme.colors.surfacePrimary100
        case .filledC: return theme.colors.surfacePrimary120
        case .neutral: return theme.colors.surfaceNeutral2
        case .outlined: return .clear
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .filledA, .neutral, .outlined:
            return theme.colors.textNeutral9
        case .filledB, .filledC:
            return theme.colors.textNeutral0_5
        }
    }

    @ViewBuilder
    private var borderOverlay: some View {
        if style == .outlined {
            Capsule()
                .stroke(theme.colors.surfacePrimary120, lineWidth: theme.borders.widthSm)
        }
    }
}
