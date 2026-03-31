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
/// **Modifier-based API (preferred):**
/// ```swift
/// DSBadge(.dot)
///
/// DSBadge(.numberBrand)
///     .count(9)
///
/// DSBadge(.tagBrand)
///     .text("New")
/// ```
///
/// **Legacy init (deprecated):**
/// ```swift
/// DSBadge(variant: .numberBrand, count: 9)
/// DSBadge(variant: .tagBrand, text: "New")
/// ```
public struct DSBadge: View {
    @Environment(\.theme) private var theme

    private let _variant: DSBadgeVariant
    private var _count: Int = 0
    private var _text: LocalizedStringKey = ""

    // MARK: - Modifier-based init (preferred)

    public init(_ variant: DSBadgeVariant = .dot) {
        self._variant = variant
    }

    // MARK: - Deprecated init

    @available(*, deprecated, message: "Use DSBadge(_:) with .count(), .text() modifiers instead")
    public init(
        variant: DSBadgeVariant,
        count: Int = 0,
        text: LocalizedStringKey = ""
    ) {
        self._variant = variant
        self._count = count
        self._text = text
    }

    // MARK: - Modifiers

    public func count(_ value: Int) -> DSBadge {
        var copy = self
        copy._count = value
        return copy
    }

    public func text(_ value: LocalizedStringKey) -> DSBadge {
        var copy = self
        copy._text = value
        return copy
    }

    // MARK: - Body

    public var body: some View {
        switch _variant {
        case .dot:
            Circle()
                .fill(theme.colors.surfaceSecondary100)
                .frame(width: 6, height: 6)

        case .numberBrand, .numberSemantic:
            Text("\(_count)")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(theme.colors.textNeutral9)
                .frame(minWidth: 16, minHeight: 16)
                .padding(.horizontal, theme.spacing.xxs)
                .padding(.vertical, 2)
                .background(numberBackground)
                .clipShape(Capsule())

        case .tagBrand, .tagSemantic:
            Text(_text)
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(theme.colors.textNeutral9)
                .padding(.horizontal, theme.spacing.xs)
                .padding(.vertical, theme.spacing.xxs)
                .background(tagBackground)
                .clipShape(Capsule())
        }
    }

    private var numberBackground: Color {
        switch _variant {
        case .numberBrand: return theme.colors.surfaceSecondary100
        case .numberSemantic: return theme.colors.infoFocus
        default: return .clear
        }
    }

    private var tagBackground: Color {
        switch _variant {
        case .tagBrand: return theme.colors.surfaceSecondary100
        case .tagSemantic: return theme.colors.infoFocus
        default: return .clear
        }
    }
}
