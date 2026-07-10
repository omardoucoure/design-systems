import XCTest
@testable import DesignSystem

final class DSMissingComponentsSpecTests: XCTestCase {

    private let theme = ThemeConfiguration(brand: .coralCamo, style: .lightRounded)

    // MARK: - DSDateRangeBar (figma 87:99691)

    func testDateRangeBarMetricsMatchFigma() {
        let m = theme.components.dateRangeBar
        XCTAssertEqual(m.iconSize, 24)
        XCTAssertEqual(m.dividerWidth, 1)
    }

    func testDateRangeBarTokensMatchFigma() {
        XCTAssertEqual(theme.radius.lg, 24)
        XCTAssertEqual(theme.spacing.xl, 32)
        XCTAssertEqual(theme.spacing.lg, 24)
        XCTAssertEqual(theme.spacing.sm, 12)
        XCTAssertEqual(theme.typography.tiny.size, 10)
        XCTAssertEqual(theme.typography.body.size, 16)
        XCTAssertEqual(theme.typography.body.weight, .medium)
    }

    // MARK: - DSLikeCommentRow (figma 87:96325)

    func testLikeCommentRowMetricsMatchFigma() {
        let m = theme.components.likeCommentRow
        XCTAssertEqual(m.badgeGlyphSize, 20)
        XCTAssertEqual(m.rowGlyphSize, 24)
    }

    func testLikeCommentRowTokensMatchFigma() {
        XCTAssertEqual(theme.radius.full, 360)
        XCTAssertEqual(theme.spacing.sm, 12)
        XCTAssertEqual(theme.spacing.xs, 8)
        XCTAssertEqual(theme.spacing.md, 16)
        XCTAssertEqual(theme.spacing.xxs, 4)
        XCTAssertEqual(theme.typography.label.size, 14)
        XCTAssertEqual(theme.typography.label.weight, .semibold)
    }

    // MARK: - DSOverlappingCards (figma 88:152411)

    func testOverlappingCardsMetricsMatchFigma() {
        let m = theme.components.overlappingCards
        XCTAssertEqual(m.overlapSmall, 50)
        XCTAssertEqual(m.overlapMedium, 85)
        XCTAssertEqual(m.overlapLarge, 132)
        XCTAssertEqual(m.socialButtonHeight, 56)
    }

    func testOverlappingCardsTokensMatchFigma() {
        XCTAssertEqual(theme.radius.xl, 32)
        XCTAssertEqual(theme.spacing.xl, 32)
        XCTAssertEqual(theme.spacing.xxl, 40)
        XCTAssertEqual(theme.spacing.lg, 24)
        XCTAssertEqual(theme.spacing.sm, 12)
        XCTAssertEqual(theme.typography.body.size, 16)
        XCTAssertEqual(theme.typography.body.weight, .medium)
    }
}
