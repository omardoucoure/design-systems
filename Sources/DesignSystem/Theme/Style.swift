import SwiftUI

/// The Style axis: controls color mode (light/dark) and shape (rounded/sharp).
/// Maps Brand primitives to semantic tokens.
public enum Style: String, CaseIterable, Sendable, Identifiable {
    case lightRounded
    case darkRounded
    case lightSharp
    case darkSharp

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .lightRounded: return "Light Rounded"
        case .darkRounded: return "Dark Rounded"
        case .lightSharp: return "Light Sharp"
        case .darkSharp: return "Dark Sharp"
        }
    }

    public var isDark: Bool {
        switch self {
        case .lightRounded, .lightSharp: return false
        case .darkRounded, .darkSharp: return true
        }
    }

    public var isSharp: Bool {
        switch self {
        case .lightRounded, .darkRounded: return false
        case .lightSharp, .darkSharp: return true
        }
    }

    public init(isDark: Bool, isSharp: Bool) {
        switch (isDark, isSharp) {
        case (false, false): self = .lightRounded
        case (true, false): self = .darkRounded
        case (false, true): self = .lightSharp
        case (true, true): self = .darkSharp
        }
    }

    // MARK: - Color Resolution

    /// Resolves semantic color tokens from brand primitives.
    /// Dark mode: inverts neutrals and swaps primary/secondary.
    public func resolveColors(from p: BrandPrimitives) -> ColorTokens {
        let semantic = SemanticColors.shared

        if isDark {
            return ColorTokens(
                // Surface — dark: inverted neutrals, swapped brand colors
                surfaceNeutral05: p.neutrals.n9,
                surfaceNeutral1: p.neutrals.n85,
                surfaceNeutral2: p.neutrals.n85,
                surfaceNeutral3: p.neutrals.n8,
                surfaceNeutral9: p.neutrals.n05,
                surfacePrimary100: p.secondary100,
                surfacePrimary120: p.neutrals.n5,
                surfaceSecondary100: p.primary100,
                // Text — dark: inverted
                textNeutral9: p.neutrals.n3,
                textNeutral8: p.neutrals.n2,
                textNeutral3: p.neutrals.n8,
                textNeutral2: p.neutrals.n85,
                textNeutral05: p.neutrals.n9,
                textPrimary100: p.secondary100,
                textSecondary100: p.primary100,
                textOpacity75: 0.75,
                textOpacity50: 0.50,
                // Border — dark: inverted neutrals, brand colors stay
                borderNeutral95: p.neutrals.n3,
                borderNeutral8: p.neutrals.n2,
                borderNeutral3: p.neutrals.n8,
                borderNeutral2: p.neutrals.n85,
                borderNeutral05: p.neutrals.n9,
                borderSecondary100: p.secondary100,
                borderPrimary100: p.primary100,
                // Semantic — shared
                error: semantic.error,
                warning: semantic.warning,
                validated: semantic.validated,
                infoFocus: semantic.infoFocus
            )
        } else {
            return ColorTokens(
                // Surface — light: direct mapping
                surfaceNeutral05: p.neutrals.n05,
                surfaceNeutral1: p.neutrals.n1,
                surfaceNeutral2: p.neutrals.n2,
                surfaceNeutral3: p.neutrals.n3,
                surfaceNeutral9: p.neutrals.n9,
                surfacePrimary100: p.primary100,
                surfacePrimary120: p.primary120,
                surfaceSecondary100: p.secondary100,
                // Text — light: direct
                textNeutral9: p.neutrals.n9,
                textNeutral8: p.neutrals.n8,
                textNeutral3: p.neutrals.n3,
                textNeutral2: p.neutrals.n2,
                textNeutral05: p.neutrals.n05,
                textPrimary100: p.primary100,
                textSecondary100: p.secondary100,
                textOpacity75: 0.75,
                textOpacity50: 0.50,
                // Border — light: direct
                borderNeutral95: p.neutrals.n9,
                borderNeutral8: p.neutrals.n8,
                borderNeutral3: p.neutrals.n3,
                borderNeutral2: p.neutrals.n2,
                borderNeutral05: p.neutrals.n05,
                borderSecondary100: p.secondary100,
                borderPrimary100: p.primary100,
                // Semantic — shared
                error: semantic.error,
                warning: semantic.warning,
                validated: semantic.validated,
                infoFocus: semantic.infoFocus
            )
        }
    }

    // MARK: - Radius Resolution

    /// Resolves radius tokens. Sharp styles zero all values except `full`.
    public func resolveRadius() -> RadiusTokens {
        isSharp ? .sharp : .rounded
    }

    // MARK: - Spacing Resolution

    /// Spacing is pass-through (identical across all modes).
    public func resolveSpacing() -> SpacingTokens {
        .shared
    }

    // MARK: - Border Resolution

    /// Border widths and opacities are shared across all modes.
    public func resolveBorders() -> BorderTokens {
        .shared
    }
}
