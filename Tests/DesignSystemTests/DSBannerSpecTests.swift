import XCTest
import SwiftUI
@testable import DesignSystem

final class DSBannerSpecTests: XCTestCase {

    private let theme = ThemeConfiguration(brand: .coralCamo, style: .lightRounded)

    func testSuccessUsesTintBackgroundNotSolid() {
        XCTAssertEqual(DSAlertSeverity.success.tintBackground(from: theme.colors), theme.colors.successBg)
        XCTAssertNotEqual(DSAlertSeverity.success.tintBackground(from: theme.colors), theme.colors.success)
    }

    func testErrorUsesTintBackgroundNotSolid() {
        XCTAssertEqual(DSAlertSeverity.error.tintBackground(from: theme.colors), theme.colors.errorBg)
        XCTAssertNotEqual(DSAlertSeverity.error.tintBackground(from: theme.colors), theme.colors.error)
    }

    func testWarningUsesTintBackground() {
        XCTAssertEqual(DSAlertSeverity.warning.tintBackground(from: theme.colors), theme.colors.warningBg)
    }

    func testAccentMatchesSolidSeverityColor() {
        XCTAssertEqual(DSAlertSeverity.success.accent(from: theme.colors), theme.colors.success)
        XCTAssertEqual(DSAlertSeverity.error.accent(from: theme.colors), theme.colors.error)
    }

    func testMessageUsesBodyRegularNotCaption() {
        XCTAssertEqual(DSBannerStyle.messageTypography(theme.typography).size, theme.typography.bodyRegular.size)
        XCTAssertEqual(DSBannerStyle.messageTypography(theme.typography).size, 16)
    }
}
