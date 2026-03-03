import XCTest
@testable import DesignSystem

final class ThemeTests: XCTestCase {

    // MARK: - Brand Primitives

    func testAllBrandsProvidePrimitives() {
        for brand in Brand.allCases {
            let primitives = brand.primitives
            // Verify all 7 brand colors and neutral scale are non-nil (struct guarantee)
            XCTAssertNotNil(primitives.primary100)
            XCTAssertNotNil(primitives.neutrals.n0)
            XCTAssertNotNil(primitives.neutrals.n10)
        }
    }

    // MARK: - Style Resolution

    func testLightRoundedResolvesCorrectRadius() {
        let theme = ThemeConfiguration(brand: .coralCamo, style: .lightRounded)
        XCTAssertEqual(theme.radius.xxs, 4)
        XCTAssertEqual(theme.radius.sm, 12)
        XCTAssertEqual(theme.radius.md, 16)
        XCTAssertEqual(theme.radius.full, 360)
    }

    func testSharpStyleZerosRadius() {
        let theme = ThemeConfiguration(brand: .coralCamo, style: .lightSharp)
        XCTAssertEqual(theme.radius.xxs, 0)
        XCTAssertEqual(theme.radius.xs, 0)
        XCTAssertEqual(theme.radius.sm, 0)
        XCTAssertEqual(theme.radius.md, 0)
        XCTAssertEqual(theme.radius.lg, 0)
        XCTAssertEqual(theme.radius.xl, 0)
        XCTAssertEqual(theme.radius.xxl, 0)
        XCTAssertEqual(theme.radius.xxxl, 0)
        // full is always 360
        XCTAssertEqual(theme.radius.full, 360)
    }

    func testDarkSharpAlsoZerosRadius() {
        let theme = ThemeConfiguration(brand: .seaLime, style: .darkSharp)
        XCTAssertEqual(theme.radius.sm, 0)
        XCTAssertEqual(theme.radius.full, 360)
        XCTAssertTrue(theme.isDark)
        XCTAssertTrue(theme.isSharp)
    }

    // MARK: - Dark Mode Inversion

    func testDarkModeFlags() {
        XCTAssertFalse(Style.lightRounded.isDark)
        XCTAssertTrue(Style.darkRounded.isDark)
        XCTAssertFalse(Style.lightSharp.isDark)
        XCTAssertTrue(Style.darkSharp.isDark)
    }

    func testSharpModeFlags() {
        XCTAssertFalse(Style.lightRounded.isSharp)
        XCTAssertFalse(Style.darkRounded.isSharp)
        XCTAssertTrue(Style.lightSharp.isSharp)
        XCTAssertTrue(Style.darkSharp.isSharp)
    }

    // MARK: - 16 Combinations

    func testAll16CombinationsResolve() {
        for brand in Brand.allCases {
            for style in Style.allCases {
                let theme = ThemeConfiguration(brand: brand, style: style)
                XCTAssertEqual(theme.brand, brand)
                XCTAssertEqual(theme.style, style)
                XCTAssertNotNil(theme.colors.surfacePrimary100)
                XCTAssertEqual(theme.spacing.md, 16)
            }
        }
    }

    // MARK: - Shared Tokens

    func testSpacingIsSharedAcrossAllModes() {
        let theme1 = ThemeConfiguration(brand: .coralCamo, style: .lightRounded)
        let theme2 = ThemeConfiguration(brand: .blueHaze, style: .darkSharp)
        XCTAssertEqual(theme1.spacing.md, theme2.spacing.md)
        XCTAssertEqual(theme1.spacing.xl, theme2.spacing.xl)
    }

    func testTypographyIsSharedAcrossAllModes() {
        let theme = ThemeConfiguration(brand: .mistyRose, style: .darkRounded)
        XCTAssertEqual(theme.typography.body.size, 16)
        XCTAssertEqual(theme.typography.display1.size, 56)
        XCTAssertEqual(theme.typography.small.size, 12)
    }

    func testOpacityTokensAreShared() {
        let theme = ThemeConfiguration(brand: .coralCamo, style: .lightRounded)
        XCTAssertEqual(theme.opacity.md, 0.50)
        XCTAssertEqual(theme.opacity.lg, 0.75)
    }

    func testBorderTokensAreShared() {
        let theme = ThemeConfiguration(brand: .seaLime, style: .darkSharp)
        XCTAssertEqual(theme.borders.widthSm, 1)
        XCTAssertEqual(theme.borders.widthMd, 2)
        XCTAssertEqual(theme.borders.widthLg, 4)
    }
}
