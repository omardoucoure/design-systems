import SwiftUI

public enum DSTagVariant: Sendable, CaseIterable {
    case brand
    case success
    case warn
    case error
    case info
    case neutral
    case strong
}

public struct DSTag: View {
    @Environment(\.theme) private var theme

    private let _text: LocalizedStringKey
    private let _variant: DSTagVariant

    public init(_ text: LocalizedStringKey, variant: DSTagVariant = .brand) {
        self._text = text
        self._variant = variant
    }

    public var body: some View {
        Text(_text)
            .font(theme.typography.small.font)
            .tracking(theme.typography.small.tracking)
            .foregroundStyle(Self.foreground(for: _variant, theme: theme))
            .padding(.horizontal, theme.components.tag.horizontalPadding)
            .padding(.vertical, theme.components.tag.verticalPadding)
            .frame(height: theme.components.tag.height)
            .background(
                Capsule().fill(Self.background(for: _variant, theme: theme))
            )
    }

    public static func background(for variant: DSTagVariant, theme: ThemeConfiguration) -> Color {
        switch variant {
        case .brand:   return theme.colors.surfaceSecondary40
        case .success: return theme.colors.successBg
        case .warn:    return theme.colors.warningBg
        case .error:   return theme.colors.errorBg
        case .info:    return theme.colors.infoBg
        case .neutral: return theme.colors.borderNeutral3
        case .strong:  return theme.colors.surfacePrimary100
        }
    }

    public static func foreground(for variant: DSTagVariant, theme: ThemeConfiguration) -> Color {
        switch variant {
        case .brand:   return theme.colors.surfaceSecondary120
        case .success: return theme.colors.success
        case .warn:    return theme.colors.warning
        case .error:   return theme.colors.error
        case .info:    return theme.colors.infoFocus
        case .neutral: return theme.colors.textNeutral8
        case .strong:  return theme.colors.textNeutral05
        }
    }
}
