import Foundation

/// Component-specific metrics that sit above semantic tokens.
///
/// These values describe control sizing and spacing that are shared across
/// multiple component implementations.
public struct ComponentTokens: Sendable {
    public let button: ButtonComponentTokens
    public let textField: TextFieldComponentTokens
    public let listItem: ListItemComponentTokens
    public let statRow: StatRowComponentTokens
    public let dateRangeBar: DateRangeBarComponentTokens
    public let likeCommentRow: LikeCommentRowComponentTokens
    public let overlappingCards: OverlappingCardsComponentTokens
    public let productDetailHero: ProductDetailHeroComponentTokens
    public let cameraControlsBar: CameraControlsBarComponentTokens
    public let photoEditToolbar: PhotoEditToolbarComponentTokens
    public let tickScale: TickScaleComponentTokens
    public let dayTimeline: DayTimelineComponentTokens

    public init(
        button: ButtonComponentTokens = .shared,
        textField: TextFieldComponentTokens = .shared,
        listItem: ListItemComponentTokens = .shared,
        statRow: StatRowComponentTokens = .shared,
        dateRangeBar: DateRangeBarComponentTokens = .shared,
        likeCommentRow: LikeCommentRowComponentTokens = .shared,
        overlappingCards: OverlappingCardsComponentTokens = .shared,
        productDetailHero: ProductDetailHeroComponentTokens = .shared,
        cameraControlsBar: CameraControlsBarComponentTokens = .shared,
        photoEditToolbar: PhotoEditToolbarComponentTokens = .shared,
        tickScale: TickScaleComponentTokens = .shared,
        dayTimeline: DayTimelineComponentTokens = .shared
    ) {
        self.button = button
        self.textField = textField
        self.listItem = listItem
        self.statRow = statRow
        self.dateRangeBar = dateRangeBar
        self.likeCommentRow = likeCommentRow
        self.overlappingCards = overlappingCards
        self.productDetailHero = productDetailHero
        self.cameraControlsBar = cameraControlsBar
        self.photoEditToolbar = photoEditToolbar
        self.tickScale = tickScale
        self.dayTimeline = dayTimeline
    }

    public static let shared = ComponentTokens()
}

public struct ButtonComponentTokens: Sendable {
    public let bigHeight: CGFloat
    public let mediumHeight: CGFloat
    public let smallHeight: CGFloat
    public let bigIconSize: CGFloat
    public let smallIconSize: CGFloat
    public let pressedOpacity: Double
    public let pressedScale: CGFloat
    public let pressedAnimationDuration: Double

    public static let shared = ButtonComponentTokens(
        bigHeight: 56,
        mediumHeight: 40,
        smallHeight: 32,
        bigIconSize: 24,
        smallIconSize: 20,
        pressedOpacity: 0.75,
        pressedScale: 0.97,
        pressedAnimationDuration: 0.15
    )
}

public struct TextFieldComponentTokens: Sendable {
    public let fieldHeight: CGFloat
    public let trailingActionHeight: CGFloat
    public let iconSize: CGFloat
    public let iconFrame: CGFloat
    public let contentGap: CGFloat

    public static let shared = TextFieldComponentTokens(
        fieldHeight: 56,
        trailingActionHeight: 32,
        iconSize: 20,
        iconFrame: 24,
        contentGap: 12
    )
}

public struct ListItemComponentTokens: Sendable {
    public let rowGap: CGFloat
    public let metadataVerticalPadding: CGFloat
    public let leadingIconSize: CGFloat
    public let trailingIconSize: CGFloat
    public let iconPadding: CGFloat

    public static let shared = ListItemComponentTokens(
        rowGap: 16,
        metadataVerticalPadding: 12,
        leadingIconSize: 24,
        trailingIconSize: 20,
        iconPadding: 8
    )
}

public struct StatRowComponentTokens: Sendable {
    public let labelTracking: CGFloat

    public static let shared = StatRowComponentTokens(
        labelTracking: -0.15
    )
}

public struct DateRangeBarComponentTokens: Sendable {
    public let iconSize: CGFloat
    public let dividerWidth: CGFloat

    public static let shared = DateRangeBarComponentTokens(
        iconSize: 24,
        dividerWidth: 1
    )
}

public struct LikeCommentRowComponentTokens: Sendable {
    public let badgeGlyphSize: CGFloat
    public let rowGlyphSize: CGFloat

    public static let shared = LikeCommentRowComponentTokens(
        badgeGlyphSize: 20,
        rowGlyphSize: 24
    )
}

public struct OverlappingCardsComponentTokens: Sendable {
    public let overlapSmall: CGFloat
    public let overlapMedium: CGFloat
    public let overlapLarge: CGFloat
    public let socialButtonHeight: CGFloat

    public static let shared = OverlappingCardsComponentTokens(
        overlapSmall: 50,
        overlapMedium: 85,
        overlapLarge: 132,
        socialButtonHeight: 56
    )
}

public struct ProductDetailHeroComponentTokens: Sendable {
    public let imageHeight: CGFloat
    public let sizePillWidth: CGFloat
    public let sizePillDotSize: CGFloat
    public let iconSize: CGFloat
    public let dotActiveWidth: CGFloat
    public let dotSize: CGFloat
    public let stepperGlyphSize: CGFloat
    public let starSize: CGFloat
    public let inactivePageDotOpacity: Double

    public static let shared = ProductDetailHeroComponentTokens(
        imageHeight: 180,
        sizePillWidth: 80,
        sizePillDotSize: 20,
        iconSize: 24,
        dotActiveWidth: 32,
        dotSize: 8,
        stepperGlyphSize: 20,
        starSize: 10,
        inactivePageDotOpacity: 0.38
    )
}

public struct CameraControlsBarComponentTokens: Sendable {
    public let cardOverlap: CGFloat
    public let shutterOuterSize: CGFloat
    public let shutterInnerSize: CGFloat
    public let chipHeight: CGFloat
    public let glyphSize: CGFloat

    public static let shared = CameraControlsBarComponentTokens(
        cardOverlap: 84,
        shutterOuterSize: 64,
        shutterInnerSize: 32,
        chipHeight: 32,
        glyphSize: 20
    )
}

public struct PhotoEditToolbarComponentTokens: Sendable {
    public let cardOverlap: CGFloat
    public let valuePillWidth: CGFloat
    public let valuePillHeight: CGFloat
    public let controlPillSize: CGFloat
    public let glyphSize: CGFloat
    public let cropPreviewWidth: CGFloat

    public static let shared = PhotoEditToolbarComponentTokens(
        cardOverlap: 84,
        valuePillWidth: 53,
        valuePillHeight: 40,
        controlPillSize: 32,
        glyphSize: 24,
        cropPreviewWidth: 50
    )
}

public struct DayTimelineComponentTokens: Sendable {
    public let rowHeight: CGFloat
    public let rowSpacing: CGFloat
    public let labelWidth: CGFloat
    public let eventLeadingInset: CGFloat
    public let eventIconSize: CGFloat
    public let activeDotSize: CGFloat

    public static let shared = DayTimelineComponentTokens(
        rowHeight: 29,
        rowSpacing: 14,
        labelWidth: 32,
        eventLeadingInset: 80,
        eventIconSize: 24,
        activeDotSize: 6
    )
}

public struct TickScaleComponentTokens: Sendable {
    public let tickWidth: CGFloat
    public let minHeight: CGFloat
    public let step: CGFloat
    public let centerHeight: CGFloat

    public static let shared = TickScaleComponentTokens(
        tickWidth: 1,
        minHeight: 4,
        step: 2,
        centerHeight: 40
    )
}

extension ThemeConfiguration {
    /// Component-level metrics shared across DS components.
    public var components: ComponentTokens {
        .shared
    }
}
