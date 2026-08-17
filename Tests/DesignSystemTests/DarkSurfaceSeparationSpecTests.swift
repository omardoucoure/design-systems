import XCTest
import SwiftUI
@testable import DesignSystem

final class DarkSurfaceSeparationSpecTests: XCTestCase {
    private func dark(_ brand: Brand) -> ColorTokens {
        Style.darkRounded.resolveColors(from: brand.primitives)
    }

    func testDarkInsetIsDistinctFromTheCardItSitsOn() {
        for brand in Brand.allCases {
            let tokens = dark(brand)
            XCTAssertNotEqual(
                tokens.surfaceNeutral1, tokens.surfaceNeutral2,
                "\(brand.rawValue) dark inset is identical to its card surface"
            )
        }
    }

    func testDarkHeroCollapsesToOneDepthAndStaysOffThePage() {
        for brand in Brand.allCases {
            let tokens = dark(brand)
            XCTAssertEqual(
                tokens.surfaceHero, tokens.surfaceHeroDeep,
                "\(brand.rawValue) dark hero must collapse to a single depth"
            )
            XCTAssertNotEqual(
                tokens.surfaceHero, tokens.surfaceNeutral05,
                "\(brand.rawValue) dark hero is indistinguishable from the page"
            )
        }
    }

    func testDarkSurfaceLadderAscendsWithoutRepeats() {
        for brand in Brand.allCases {
            let tokens = dark(brand)
            let ladder = [
                tokens.surfaceNeutral05,
                tokens.surfaceNeutral1,
                tokens.surfaceNeutral2,
                tokens.surfaceNeutral3,
            ]
            XCTAssertEqual(
                Set(ladder).count, ladder.count,
                "\(brand.rawValue) dark surface ladder repeats a value"
            )
        }
    }

    func testDarkTextLadderIsDistinctFromItsSurfaces() {
        for brand in Brand.allCases {
            let tokens = dark(brand)
            XCTAssertNotEqual(tokens.textNeutral9, tokens.surfaceNeutral05, brand.rawValue)
            XCTAssertNotEqual(tokens.textNeutral6, tokens.surfaceNeutral1, brand.rawValue)
        }
    }
}
