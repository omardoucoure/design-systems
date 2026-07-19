import XCTest
@testable import DesignSystem

final class DSSegmentedPickerSpecTests: XCTestCase {

    private let theme = ThemeConfiguration(brand: .coralCamo, style: .lightRounded)

    func testSegmentedContainerRadiusMatchesWebSpec() {
        XCTAssertEqual(theme.components.segmentedPicker.containerRadius, theme.radius.lg)
    }

    func testSegmentedContainerRadiusIsTwentyFour() {
        XCTAssertEqual(theme.components.segmentedPicker.containerRadius, 24)
    }

    func testSegmentedTokensMatchWebSpec() {
        XCTAssertEqual(theme.radius.lg, 24)
        XCTAssertEqual(theme.radius.xl, 32)
        XCTAssertEqual(theme.radius.full, 360)
    }
}
