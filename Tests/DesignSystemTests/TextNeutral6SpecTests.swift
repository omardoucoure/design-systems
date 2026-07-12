import XCTest
import SwiftUI
@testable import DesignSystem

final class TextNeutral6SpecTests: XCTestCase {

    func testLightTextNeutral6MapsToN6() {
        let theme = ThemeConfiguration(brand: .coralCamo, style: .lightRounded)
        XCTAssertEqual(theme.colors.textNeutral6, Brand.coralCamo.primitives.neutrals.n6)
    }

    func testDarkTextNeutral6MapsToN3() {
        let theme = ThemeConfiguration(brand: .coralCamo, style: .darkRounded)
        XCTAssertEqual(theme.colors.textNeutral6, Brand.coralCamo.primitives.neutrals.n3)
    }
}
