import XCTest
import SwiftUI
@testable import DesignSystem

final class AccentAndDataTokensSpecTests: XCTestCase {
    private let brand = Brand.coralCamo
    private var primitives: BrandPrimitives { brand.primitives }
    private var light: ColorTokens { Style.lightRounded.resolveColors(from: primitives) }
    private var dark: ColorTokens { Style.darkRounded.resolveColors(from: primitives) }

    func testLightAccentOnSurfaceIsPrimary100() {
        XCTAssertEqual(light.accentOnSurface, primitives.primary100)
    }

    func testDarkAccentOnSurfaceIsSecondary100() {
        XCTAssertEqual(dark.accentOnSurface, primitives.secondary100)
    }

    func testLightOnAccentTextIsLightestNeutral() {
        XCTAssertEqual(light.onAccentText, primitives.neutrals.n05)
    }

    func testDarkOnAccentTextIsPrimary120() {
        XCTAssertEqual(dark.onAccentText, primitives.primary120)
    }

    func testAccentNeverCollidesWithTheCardItSitsOn() {
        XCTAssertNotEqual(light.accentOnSurface, light.surfaceNeutral05)
        XCTAssertNotEqual(dark.accentOnSurface, dark.surfaceNeutral05)
    }

    func testLightDataSeriesTokens() {
        XCTAssertEqual(light.dataSeries, primitives.primary100)
        XCTAssertEqual(light.dataSeriesMuted, primitives.primary80)
        XCTAssertEqual(light.dataSeriesAlt, primitives.neutrals.n6)
        XCTAssertEqual(light.dataTrack, primitives.neutrals.n3)
    }

    func testDarkDataSeriesTokens() {
        XCTAssertEqual(dark.dataSeries, primitives.secondary100)
        XCTAssertEqual(dark.dataSeriesMuted, primitives.secondary40)
        XCTAssertEqual(dark.dataSeriesAlt, primitives.neutrals.n4)
        XCTAssertEqual(dark.dataTrack, primitives.primary80)
    }

    func testThreeSeriesColorsAreMutuallyDistinctInBothModes() {
        for tokens in [light, dark] {
            XCTAssertNotEqual(tokens.dataSeries, tokens.dataSeriesMuted)
            XCTAssertNotEqual(tokens.dataSeries, tokens.dataSeriesAlt)
            XCTAssertNotEqual(tokens.dataSeriesMuted, tokens.dataSeriesAlt)
        }
    }

    func testSeriesColorsAreDistinctFromTheirTrackInBothModes() {
        for tokens in [light, dark] {
            XCTAssertNotEqual(tokens.dataSeries, tokens.dataTrack)
            XCTAssertNotEqual(tokens.dataSeriesMuted, tokens.dataTrack)
            XCTAssertNotEqual(tokens.dataSeriesAlt, tokens.dataTrack)
        }
    }

    func testEveryBrandKeepsAccentAndSeriesDistinctInBothModes() {
        for brand in Brand.allCases {
            for style in [Style.lightRounded, .darkRounded] {
                let tokens = style.resolveColors(from: brand.primitives)
                XCTAssertNotEqual(
                    tokens.accentOnSurface, tokens.surfaceNeutral05,
                    "\(brand.rawValue)/\(style.rawValue) accent collides with its card"
                )
                XCTAssertNotEqual(
                    tokens.dataSeries, tokens.dataSeriesMuted,
                    "\(brand.rawValue)/\(style.rawValue) series colors collide"
                )
            }
        }
    }
}
