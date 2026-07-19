import XCTest
import SwiftUI
@testable import DesignSystem

final class DSToastAlertSpecTests: XCTestCase {

    private let theme = ThemeConfiguration(brand: .coralCamo, style: .lightRounded)

    func testSuccessSemanticKeepsTintGreen() {
        XCTAssertEqual(theme.colors.success, Color(hex: "#249F58"))
        XCTAssertEqual(theme.colors.successBg, Color(hex: "#DCF5E5"))
    }

    func testValidatedIsSolidToastGreen() {
        XCTAssertEqual(theme.colors.validated, Color(hex: "#76F057"))
    }

    func testBackgroundsMatchFigmaFills() {
        XCTAssertEqual(DSToastAlertStyle.background(for: .success, from: theme.colors), theme.colors.validated)
        XCTAssertEqual(DSToastAlertStyle.background(for: .warning, from: theme.colors), Color(hex: "#FFD143"))
        XCTAssertEqual(DSToastAlertStyle.background(for: .error, from: theme.colors), Color(hex: "#FF6A5F"))
        XCTAssertEqual(DSToastAlertStyle.background(for: .info, from: theme.colors), theme.colors.infoFocus)
    }

    func testCornerRadiusPerVariant() {
        XCTAssertEqual(DSToastAlertStyle.cornerRadius(for: .success, from: theme.radius), 24)
        XCTAssertEqual(DSToastAlertStyle.cornerRadius(for: .info, from: theme.radius), 24)
        XCTAssertEqual(DSToastAlertStyle.cornerRadius(for: .warning, from: theme.radius), 32)
        XCTAssertEqual(DSToastAlertStyle.cornerRadius(for: .error, from: theme.radius), 32)
    }

    func testTitleAndMessageTypography() {
        XCTAssertEqual(DSToastAlertStyle.titleTypography(theme.typography).size, theme.typography.h5.size)
        XCTAssertEqual(DSToastAlertStyle.titleTypography(theme.typography).size, 20)
        XCTAssertEqual(DSToastAlertStyle.messageTypography(theme.typography).size, theme.typography.caption.size)
        XCTAssertEqual(DSToastAlertStyle.messageTypography(theme.typography).size, 14)
    }

    func testTextColorIsNeutral9() {
        XCTAssertEqual(DSToastAlertStyle.textColor(from: theme.colors), theme.colors.textNeutral9)
    }

    func testLeadingChipOnlyForWarningAndError() {
        XCTAssertTrue(DSToastAlertStyle.hasLeadingChip(.warning))
        XCTAssertTrue(DSToastAlertStyle.hasLeadingChip(.error))
        XCTAssertFalse(DSToastAlertStyle.hasLeadingChip(.success))
        XCTAssertFalse(DSToastAlertStyle.hasLeadingChip(.info))
    }
}
