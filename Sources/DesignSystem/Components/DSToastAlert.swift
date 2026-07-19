import SwiftUI

public enum DSToastAlertType: Sendable {
    case success, warning, error, info
}

enum DSToastAlertStyle {
    static func background(for type: DSToastAlertType, from colors: ColorTokens) -> Color {
        switch type {
        case .success: return colors.validated
        case .warning: return Color(hex: "#FFD143")
        case .error: return Color(hex: "#FF6A5F")
        case .info: return colors.infoFocus
        }
    }

    static func cornerRadius(for type: DSToastAlertType, from radius: RadiusTokens) -> CGFloat {
        switch type {
        case .success, .info: return radius.lg
        case .warning, .error: return radius.xl
        }
    }

    static func titleTypography(_ typography: TypographyTokens) -> TypographyStyle {
        typography.h5
    }

    static func messageTypography(_ typography: TypographyTokens) -> TypographyStyle {
        typography.caption
    }

    static func textColor(from colors: ColorTokens) -> Color {
        colors.textNeutral9
    }

    static func hasLeadingChip(_ type: DSToastAlertType) -> Bool {
        switch type {
        case .warning, .error: return true
        case .success, .info: return false
        }
    }
}

public struct DSToastAlert: View {
    @Environment(\.theme) private var theme

    private let _type: DSToastAlertType
    private var _title: LocalizedStringKey?
    private var _message: LocalizedStringKey?
    private var _onDismiss: (() -> Void)?

    public init(type: DSToastAlertType) {
        self._type = type
    }

    public func title(_ title: LocalizedStringKey) -> Self {
        var copy = self
        copy._title = title
        return copy
    }

    public func message(_ message: LocalizedStringKey) -> Self {
        var copy = self
        copy._message = message
        return copy
    }

    public func onDismiss(_ action: @escaping () -> Void) -> Self {
        var copy = self
        copy._onDismiss = action
        return copy
    }

    public var body: some View {
        Group {
            if DSToastAlertStyle.hasLeadingChip(_type) {
                VStack(alignment: .leading, spacing: theme.spacing.md) {
                    HStack(alignment: .top) {
                        chip
                        Spacer()
                        dismissGlyph
                    }
                    texts
                }
            } else {
                HStack(alignment: .top, spacing: theme.spacing.md) {
                    texts
                    dismissGlyph
                }
            }
        }
        .padding(theme.spacing.xl)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(DSToastAlertStyle.background(for: _type, from: theme.colors))
        .clipShape(RoundedRectangle(cornerRadius: DSToastAlertStyle.cornerRadius(for: _type, from: theme.radius)))
    }

    private var texts: some View {
        VStack(alignment: .leading, spacing: theme.spacing.xxs) {
            if let _title {
                Text(_title)
                    .typographyStyle(DSToastAlertStyle.titleTypography(theme.typography))
                    .foregroundStyle(DSToastAlertStyle.textColor(from: theme.colors))
            }
            if let _message {
                Text(_message)
                    .typographyStyle(DSToastAlertStyle.messageTypography(theme.typography))
                    .foregroundStyle(DSToastAlertStyle.textColor(from: theme.colors))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var chip: some View {
        DSIconImage(.messageAlert, size: 20, color: DSToastAlertStyle.textColor(from: theme.colors))
            .padding(.horizontal, theme.spacing.sm)
            .padding(.vertical, theme.spacing.xxs)
            .background(theme.colors.surfaceNeutral2, in: Capsule())
    }

    private var dismissGlyph: some View {
        Group {
            if let _onDismiss {
                Button(action: _onDismiss) {
                    DSIconImage(.xmark, size: 20, color: DSToastAlertStyle.textColor(from: theme.colors))
                }
                .buttonStyle(.plain)
            } else {
                DSIconImage(.xmark, size: 20, color: DSToastAlertStyle.textColor(from: theme.colors))
            }
        }
        .padding(.vertical, theme.spacing.xxs)
    }
}
