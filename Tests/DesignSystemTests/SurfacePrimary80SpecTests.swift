import XCTest
import SwiftUI
@testable import DesignSystem

final class SurfacePrimary80SpecTests: XCTestCase {

    func testLightSurfacePrimary80MapsToPrimary80Primitive() {
        let brand = Brand.coralCamo
        let tokens = Style.lightRounded.resolveColors(from: brand.primitives)
        XCTAssertEqual(tokens.surfacePrimary80, brand.primitives.primary80)
    }

    func testDarkSurfacePrimary80MapsToPrimary80Primitive() {
        let brand = Brand.coralCamo
        let tokens = Style.darkRounded.resolveColors(from: brand.primitives)
        XCTAssertEqual(tokens.surfacePrimary80, brand.primitives.primary80)
    }
}
