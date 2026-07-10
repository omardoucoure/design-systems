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

    public init(
        button: ButtonComponentTokens = .shared,
        textField: TextFieldComponentTokens = .shared,
        listItem: ListItemComponentTokens = .shared,
        statRow: StatRowComponentTokens = .shared,
        dateRangeBar: DateRangeBarComponentTokens = .shared,
        likeCommentRow: LikeCommentRowComponentTokens = .shared,
        overlappingCards: OverlappingCardsComponentTokens = .shared
    ) {
        self.button = button
        self.textField = textField
        self.listItem = listItem
        self.statRow = statRow
        self.dateRangeBar = dateRangeBar
        self.likeCommentRow = likeCommentRow
        self.overlappingCards = overlappingCards
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
        mediumHeight: 48,
        smallHeight: 36,
        bigIconSize: 24,
        smallIconSize: 18,
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

extension ThemeConfiguration {
    /// Component-level metrics shared across DS components.
    public var components: ComponentTokens {
        .shared
    }
}
