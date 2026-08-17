import XCTest
import SwiftUI
@testable import DesignSystem

final class HeroTokensSpecTests: XCTestCase {
    private let brand = Brand.coralCamo

    func testLightHeroMapsToPrimary100() {
        let tokens = Style.lightRounded.resolveColors(from: brand.primitives)
        XCTAssertEqual(tokens.surfaceHero, brand.primitives.primary100)
    }

    func testLightHeroDeepMapsToPrimary120() {
        let tokens = Style.lightRounded.resolveColors(from: brand.primitives)
        XCTAssertEqual(tokens.surfaceHeroDeep, brand.primitives.primary120)
    }

    func testLightTextOnHeroIsOnPrimary() {
        let tokens = Style.lightRounded.resolveColors(from: brand.primitives)
        XCTAssertEqual(tokens.textOnHero, tokens.textNeutral05)
    }

    func testDarkHeroAndHeroDeepMapToDeepestNeutral() {
        let tokens = Style.darkRounded.resolveColors(from: brand.primitives)
        XCTAssertEqual(tokens.surfaceHero, brand.primitives.neutrals.n95)
        XCTAssertEqual(tokens.surfaceHeroDeep, brand.primitives.neutrals.n95)
    }

    func testDarkHeroSitsBelowThePageSurface() {
        let tokens = Style.darkRounded.resolveColors(from: brand.primitives)
        XCTAssertNotEqual(tokens.surfaceHero, tokens.surfaceNeutral05)
    }
}
