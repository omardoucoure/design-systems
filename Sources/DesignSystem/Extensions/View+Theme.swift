import SwiftUI

// MARK: - Elevation Modifier

private struct ElevationModifier: ViewModifier {
    let layers: [ShadowLayer]

    func body(content: Content) -> some View {
        var view = AnyView(content)
        for layer in layers {
            view = AnyView(
                view.shadow(
                    color: layer.color.opacity(layer.opacity),
                    radius: layer.blur / 2,
                    x: layer.x,
                    y: layer.y
                )
            )
        }
        return view
    }
}

extension View {
    /// Applies a multi-layer elevation shadow from an ElevationTokens preset.
    public func elevation(_ layers: [ShadowLayer]) -> some View {
        modifier(ElevationModifier(layers: layers))
    }
}

// MARK: - Typography Modifier

private struct TypographyModifier: ViewModifier {
    let style: TypographyStyle

    func body(content: Content) -> some View {
        content
            .font(style.font)
            .lineSpacing(style.lineSpacing)
            .tracking(style.tracking)
    }
}

extension View {
    /// Applies a typography style (font, line spacing, tracking) from TypographyTokens.
    public func typographyStyle(_ style: TypographyStyle) -> some View {
        modifier(TypographyModifier(style: style))
    }
}
