import SwiftUI

// MARK: - Badge Variant

public enum DSBadgeVariant: Sendable, CaseIterable {
    /// Small 6pt dot.
    case dot
    /// Number in a circle (brand secondary).
    case numberBrand
    /// Number in a circle (semantic info).
    case numberSemantic
    /// Text pill (brand secondary).
    case tagBrand
    /// Text pill (semantic info).
    case tagSemantic
}

// MARK: - DSBadge

/// A themed badge (dot, number, or tag).
///
/// Usage:
/// ```swift
/// DSBadge(variant: .dot)
/// DSBadge(variant: .numberBrand, count: 9)
/// DSBadge(variant: .tagBrand, text: "New")
/// ```
public struct DSBadge: View {
    @Environment(\.theme) private var theme

    private let variant: DSBadgeVariant
    private let count: Int
    private let text: LocalizedStringKey

    public init(
        variant: DSBadgeVariant = .dot,
        count: Int = 0,
        text: LocalizedStringKey = ""
    ) {
        self.variant = variant
        self.count = count
        self.text = text
    }

    public var body: some View {
        switch variant {
        case .dot:
            Circle()
                .fill(theme.colors.surfaceSecondary100)
                .frame(width: 6, height: 6)

        case .numberBrand, .numberSemantic:
            Text("\(count)")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(theme.colors.textNeutral9)
                .frame(minWidth: 16, minHeight: 16)
                .padding(.horizontal, theme.spacing.xxs)
                .padding(.vertical, 2)
                .background(numberBackground)
                .clipShape(Capsule())

        case .tagBrand, .tagSemantic:
            Text(text)
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(theme.colors.textNeutral9)
                .padding(.horizontal, theme.spacing.xs)
                .padding(.vertical, theme.spacing.xxs)
                .background(tagBackground)
                .clipShape(Capsule())
        }
    }

    private var numberBackground: Color {
        switch variant {
        case .numberBrand: return theme.colors.surfaceSecondary100
        case .numberSemantic: return theme.colors.infoFocus
        default: return .clear
        }
    }

    private var tagBackground: Color {
        switch variant {
        case .tagBrand: return theme.colors.surfaceSecondary100
        case .tagSemantic: return theme.colors.infoFocus
        default: return .clear
        }
    }
}
