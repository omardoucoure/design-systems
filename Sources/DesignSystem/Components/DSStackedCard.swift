import SwiftUI

// MARK: - DSStackedCardAlignment

/// Where the stacked background cards peek out from behind the front card.
public enum DSStackedCardAlignment {
    case top
    case bottom
    case leading
    case trailing
}

// MARK: - DSStackedCardLevel

/// Describes a single background card level.
public struct DSStackedCardLevel {
    /// Horizontal inset on each side relative to the front card width. Positive = narrower.
    public let horizontalInset: CGFloat
    /// Black overlay opacity applied on top of the background color.
    public let darkOverlay: Double
    /// How far this card peeks out along the alignment axis.
    public let peekOffset: CGFloat

    public init(
        horizontalInset: CGFloat,
        darkOverlay: Double = 0,
        peekOffset: CGFloat = 0
    ) {
        self.horizontalInset = horizontalInset
        self.darkOverlay = darkOverlay
        self.peekOffset = peekOffset
    }
}

// MARK: - DSStackedCard

/// A stacked depth-effect card container.
///
/// Background cards peek behind the front card to create a layered depth illusion.
/// The front card sizes to its content. Background cards match the front card height
/// via a PreferenceKey once layout is resolved.
///
/// Usage (modifier API):
/// ```swift
/// DSStackedCard {
///     MyContent()
/// }
/// .stackedLevels([
///     DSStackedCardLevel(horizontalInset: 42, peekOffset: 20),
///     DSStackedCardLevel(horizontalInset: 67, darkOverlay: 0.10, peekOffset: 0),
/// ])
/// .stackedAlignment(.top)
/// .stackedFrontOffset(39)
/// ```
public struct DSStackedCard<Content: View>: View {
    @Environment(\.theme) private var theme
    @State private var frontHeight: CGFloat = 300

    // Core (init-only)
    private let content: Content

    // Modifier-based visual customization
    private var _levels: [DSStackedCardLevel]?
    private var _alignment: DSStackedCardAlignment = .top
    private var _frontOffset: CGFloat = 39
    private var _frontBackground: Color?
    private var _backgroundCardColor: Color?

    public init(
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
    }

    // MARK: - Deprecated init

    @available(*, deprecated, message: "Use DSStackedCard(content:) with .stackedLevels(), .stackedAlignment(), .stackedFrontOffset(), .stackedFrontBackground(), .stackedBackgroundCardColor() modifiers instead")
    public init(
        levels: [DSStackedCardLevel] = DSStackedCard.defaultLevels,
        alignment: DSStackedCardAlignment = .top,
        frontOffset: CGFloat = 39,
        frontBackground: Color? = nil,
        backgroundCardColor: Color? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self._levels = levels
        self._alignment = alignment
        self._frontOffset = frontOffset
        self._frontBackground = frontBackground
        self._backgroundCardColor = backgroundCardColor
        self.content = content()
    }

    public static var defaultLevels: [DSStackedCardLevel] {
        [
            DSStackedCardLevel(horizontalInset: 18, darkOverlay: 0.00, peekOffset: 20),
            DSStackedCardLevel(horizontalInset: 36, darkOverlay: 0.10, peekOffset: 0),
        ]
    }

    // MARK: - Modifiers

    public func stackedLevels(_ levels: [DSStackedCardLevel]) -> Self {
        var copy = self
        copy._levels = levels
        return copy
    }

    public func stackedAlignment(_ alignment: DSStackedCardAlignment) -> Self {
        var copy = self
        copy._alignment = alignment
        return copy
    }

    public func stackedFrontOffset(_ offset: CGFloat) -> Self {
        var copy = self
        copy._frontOffset = offset
        return copy
    }

    public func stackedFrontBackground(_ color: Color) -> Self {
        var copy = self
        copy._frontBackground = color
        return copy
    }

    public func stackedBackgroundCardColor(_ color: Color) -> Self {
        var copy = self
        copy._backgroundCardColor = color
        return copy
    }

    // MARK: - Computed helpers

    private var levels: [DSStackedCardLevel] {
        _levels ?? DSStackedCard.defaultLevels
    }

    private var zStackAlignment: Alignment {
        switch _alignment {
        case .top: return .top
        case .bottom: return .bottom
        case .leading: return .leading
        case .trailing: return .trailing
        }
    }

    // MARK: - Body

    public var body: some View {
        ZStack(alignment: zStackAlignment) {
            // Background cards — deepest first
            ForEach(Array(levels.reversed().enumerated()), id: \.offset) { _, level in
                backgroundCard(level: level)
            }
            // Front card — layout driver
            frontCard
        }
    }

    private var frontCard: some View {
        let edgePadding: Edge.Set = {
            switch _alignment {
            case .top: return .top
            case .bottom: return .bottom
            case .leading: return .leading
            case .trailing: return .trailing
            }
        }()
        return content
            .padding(theme.spacing.xl)
            .background(
                RoundedRectangle(cornerRadius: theme.radius.xl)
                    .fill(_frontBackground ?? theme.colors.surfaceNeutral2)
            )
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))
            .padding(edgePadding, _frontOffset)
            .background(
                GeometryReader { geo in
                    Color.clear
                        .preference(key: DSStackedCardHeightKey.self, value: geo.size.height)
                }
            )
            .onPreferenceChange(DSStackedCardHeightKey.self) { h in
                if h > 0 { frontHeight = h }
            }
    }

    private func backgroundCard(level: DSStackedCardLevel) -> some View {
        let base = _backgroundCardColor ?? theme.colors.surfaceNeutral3
        let edgePadding: Edge.Set = {
            switch _alignment {
            case .top: return .top
            case .bottom: return .bottom
            case .leading: return .leading
            case .trailing: return .trailing
            }
        }()
        return RoundedRectangle(cornerRadius: theme.radius.xl)
            .fill(base)
            .overlay(
                level.darkOverlay > 0
                    ? AnyView(RoundedRectangle(cornerRadius: theme.radius.xl)
                        .fill(Color.black.opacity(level.darkOverlay)))
                    : AnyView(EmptyView())
            )
            .frame(height: max(0, frontHeight - _frontOffset))
            .padding(.horizontal, level.horizontalInset)
            .padding(edgePadding, level.peekOffset)
    }
}

// MARK: - Preference Key

private struct DSStackedCardHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
