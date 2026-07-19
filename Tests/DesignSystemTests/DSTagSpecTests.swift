import XCTest
import SwiftUI
@testable import DesignSystem

final class DSTagSpecTests: XCTestCase {

    private let theme = ThemeConfiguration(brand: .coralCamo, style: .lightRounded)

    func testTagHeightMatchesSpec() {
        XCTAssertEqual(theme.components.tag.height, 24)
    }

    func testTagHorizontalPaddingMatchesSpec() {
        XCTAssertEqual(theme.components.tag.horizontalPadding, 10)
    }

    func testTagVerticalPaddingMatchesSpec() {
        XCTAssertEqual(theme.components.tag.verticalPadding, 4)
    }

    func testSuccessTagUsesValidatedTintAndText() {
        XCTAssertEqual(DSTag.background(for: .success, theme: theme), theme.colors.successBg)
        XCTAssertEqual(DSTag.foreground(for: .success, theme: theme), theme.colors.success)
    }

    func testErrorTagUsesErrorTintAndText() {
        XCTAssertEqual(DSTag.background(for: .error, theme: theme), theme.colors.errorBg)
        XCTAssertEqual(DSTag.foreground(for: .error, theme: theme), theme.colors.error)
    }

    func testNeutralTagUsesBorderDefaultAndNeutralText() {
        XCTAssertEqual(DSTag.background(for: .neutral, theme: theme), theme.colors.borderNeutral3)
        XCTAssertEqual(DSTag.foreground(for: .neutral, theme: theme), theme.colors.textNeutral8)
    }

    func testNeutralTagTextIsNotBrandSecondary() {
        XCTAssertNotEqual(DSTag.foreground(for: .neutral, theme: theme), theme.colors.textSecondary100)
    }
}
