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

    // MARK: - DSProductDetailHero (figma 87:96135)

    func testProductDetailHeroMetricsMatchFigma() {
        let m = theme.components.productDetailHero
        XCTAssertEqual(m.imageHeight, 180)
        XCTAssertEqual(m.sizePillWidth, 80)
        XCTAssertEqual(m.sizePillDotSize, 20)
        XCTAssertEqual(m.iconSize, 24)
        XCTAssertEqual(m.dotActiveWidth, 32)
        XCTAssertEqual(m.dotSize, 8)
        XCTAssertEqual(m.stepperGlyphSize, 20)
        XCTAssertEqual(m.starSize, 10)
        XCTAssertEqual(m.inactivePageDotOpacity, 0.38)
    }

    func testProductDetailHeroTokensMatchFigma() {
        XCTAssertEqual(theme.radius.xl, 32)
        XCTAssertEqual(theme.radius.lg, 24)
        XCTAssertEqual(theme.radius.full, 360)
        XCTAssertEqual(theme.typography.largeBold.size, 18)
        XCTAssertEqual(theme.typography.largeBold.weight, .bold)
        XCTAssertEqual(theme.typography.tiny.size, 10)
        XCTAssertEqual(theme.typography.tinyRegular.weight, .regular)
        XCTAssertEqual(theme.typography.h4.size, 24)
        XCTAssertEqual(theme.opacity.lg, 0.75)
    }

    // MARK: - DSCameraControlsBar (figma 87:100709)

    func testCameraControlsBarMetricsMatchFigma() {
        let m = theme.components.cameraControlsBar
        XCTAssertEqual(m.cardOverlap, 84)
        XCTAssertEqual(m.shutterOuterSize, 64)
        XCTAssertEqual(m.shutterInnerSize, 32)
        XCTAssertEqual(m.chipHeight, 32)
        XCTAssertEqual(m.glyphSize, 20)
    }

    func testCameraControlsBarTokensMatchFigma() {
        XCTAssertEqual(theme.radius.xl, 32)
        XCTAssertEqual(theme.radius.full, 360)
        XCTAssertEqual(theme.spacing.xl, 32)
        XCTAssertEqual(theme.spacing.xxl, 40)
        XCTAssertEqual(theme.typography.label.size, 14)
        XCTAssertEqual(theme.typography.smallSemiBold.size, 12)
        XCTAssertEqual(theme.typography.smallSemiBold.weight, .semibold)
    }

    // MARK: - DSPhotoEditToolbar (figma 87:100817)

    func testPhotoEditToolbarMetricsMatchFigma() {
        let m = theme.components.photoEditToolbar
        XCTAssertEqual(m.cardOverlap, 84)
        XCTAssertEqual(m.valuePillWidth, 53)
        XCTAssertEqual(m.valuePillHeight, 40)
        XCTAssertEqual(m.controlPillSize, 32)
        XCTAssertEqual(m.glyphSize, 24)
        XCTAssertEqual(m.cropPreviewWidth, 50)
    }

    func testPhotoEditToolbarTokensMatchFigma() {
        XCTAssertEqual(theme.radius.xl, 32)
        XCTAssertEqual(theme.radius.xs, 8)
        XCTAssertEqual(theme.spacing.xl, 32)
        XCTAssertEqual(theme.spacing.lg, 24)
        XCTAssertEqual(theme.typography.smallSemiBold.size, 12)
        XCTAssertEqual(theme.typography.smallSemiBold.weight, .semibold)
        XCTAssertEqual(theme.opacity.md, 0.50)
    }

    // MARK: - Bold typography tokens (added for 700-weight designs)

    func testBoldTypographyTokens() {
        XCTAssertEqual(theme.typography.largeBold.size, 18)
        XCTAssertEqual(theme.typography.largeBold.weight, .bold)
        XCTAssertEqual(theme.typography.bodyBold.size, 16)
        XCTAssertEqual(theme.typography.bodyBold.weight, .bold)
    }
}
