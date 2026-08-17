import XCTest
import SwiftUI
@testable import DesignSystem

final class AdaptiveStyleSpecTests: XCTestCase {
    func testLightColorSchemeResolvesRoundedLightStyle() {
        XCTAssertEqual(Style.rounded(for: .light), .lightRounded)
    }

    func testDarkColorSchemeResolvesRoundedDarkStyle() {
        XCTAssertEqual(Style.rounded(for: .dark), .darkRounded)
    }

    func testSharpShapeIsPreservedAcrossColorSchemes() {
        XCTAssertEqual(Style.sharp(for: .light), .lightSharp)
        XCTAssertEqual(Style.sharp(for: .dark), .darkSharp)
    }

    func testResolvingKeepsShapeAndSwapsOnlyTheColorMode() {
        XCTAssertEqual(Style.lightRounded.resolved(for: .dark), .darkRounded)
        XCTAssertEqual(Style.darkRounded.resolved(for: .light), .lightRounded)
        XCTAssertEqual(Style.lightSharp.resolved(for: .dark), .darkSharp)
        XCTAssertEqual(Style.darkSharp.resolved(for: .light), .lightSharp)
    }

    func testResolvingIsIdempotentWhenSchemeAlreadyMatches() {
        XCTAssertEqual(Style.lightRounded.resolved(for: .light), .lightRounded)
        XCTAssertEqual(Style.darkSharp.resolved(for: .dark), .darkSharp)
    }

    func testShapeIsExpressedIndependentlyOfColorMode() {
        XCTAssertEqual(StyleShape.rounded.style(for: .light), .lightRounded)
        XCTAssertEqual(StyleShape.rounded.style(for: .dark), .darkRounded)
        XCTAssertEqual(StyleShape.sharp.style(for: .light), .lightSharp)
        XCTAssertEqual(StyleShape.sharp.style(for: .dark), .darkSharp)
    }
}
