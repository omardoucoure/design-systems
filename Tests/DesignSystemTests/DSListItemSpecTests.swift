import XCTest
import SwiftUI
@testable import DesignSystem

final class DSListItemSpecTests: XCTestCase {

    private let theme = ThemeConfiguration(brand: .coralCamo, style: .lightRounded)

    func testListItemVerticalPaddingMatchesSpec() {
        XCTAssertEqual(theme.components.listItem.verticalPadding, theme.spacing.sm)
        XCTAssertEqual(theme.spacing.sm, 12)
    }

    func testListItemHorizontalPaddingMatchesSpec() {
        XCTAssertEqual(theme.components.listItem.horizontalPadding, theme.spacing.md)
        XCTAssertEqual(theme.spacing.md, 16)
    }

    func testListItemMinHeightMatchesSpec() {
        XCTAssertEqual(theme.components.listItem.minHeight, 56)
    }

    func testListItemDividerUsesLightBorderNotDarkNeutral() {
        XCTAssertEqual(DSListItem<EmptyView, EmptyView>.dividerColor(for: theme), theme.colors.borderNeutral3)
        XCTAssertNotEqual(DSListItem<EmptyView, EmptyView>.dividerColor(for: theme), theme.colors.borderNeutral95)
    }

    func testLightBorderTokenIsDistinctFromDarkNeutral() {
        XCTAssertNotEqual(theme.colors.borderNeutral3, theme.colors.borderNeutral95)
    }

    func testListItemDividerHorizontalInsetMatchesSpec() {
        XCTAssertEqual(theme.components.listItem.dividerInset, theme.spacing.md)
    }
}
