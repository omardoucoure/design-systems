import XCTest
import SwiftUI
@testable import DesignSystem

final class TypographyStylePublicInitTests: XCTestCase {
    func testPublicMemberwiseInit() {
        let style = TypographyStyle(size: 22, weight: .medium, lineHeight: 1.1, letterSpacing: -4.0)
        XCTAssertEqual(style.size, 22)
        XCTAssertEqual(style.lineHeight, 1.1)
        XCTAssertEqual(style.tracking, 22 * -0.04, accuracy: 0.001)
        XCTAssertEqual(style.lineSpacing, 22 * 0.1, accuracy: 0.001)
    }
}
