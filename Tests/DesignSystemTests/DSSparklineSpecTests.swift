import XCTest
import SwiftUI
@testable import DesignSystem

final class DSSparklineSpecTests: XCTestCase {
    private let theme = ThemeConfiguration(brand: .coralCamo, style: .lightRounded)

    func testDefaultsMatchHomeRecallSparklineSpec() {
        let sparkline = DSSparkline(values: [0.52, 0.64, 0.71, 0.82, 0.90])
        XCTAssertEqual(sparkline._barRadius, 6)
        XCTAssertEqual(sparkline._barGap, 6)
    }

    func testPerBarColorsAreConfigurable() {
        let colors: [Color] = [.red, .green]
        let sparkline = DSSparkline(values: [0.5, 1.0]).barColors(colors)
        XCTAssertEqual(sparkline._barColors, colors)
    }

    func testValuesAreClampedToUnitRange() {
        let sparkline = DSSparkline(values: [-0.2, 0.5, 1.4])
        XCTAssertEqual(sparkline.clampedValues, [0, 0.5, 1])
    }
}

final class DSAvatarOverrideSpecTests: XCTestCase {
    func testAvatarColorAndFontOverridesAreConfigurable() {
        let avatar = DSAvatar(style: .monogram("O"), size: 44)
            .avatarBackground(.orange)
            .avatarForeground(.blue)
            .monogramFontSize(17)
        XCTAssertEqual(avatar._background, .orange)
        XCTAssertEqual(avatar._foreground, .blue)
        XCTAssertEqual(avatar._monogramFontSize, 17)
    }

    func testAvatarOverridesDefaultToNil() {
        let avatar = DSAvatar(style: .monogram("O"))
        XCTAssertNil(avatar._background)
        XCTAssertNil(avatar._foreground)
        XCTAssertNil(avatar._monogramFontSize)
    }
}

final class DSHahoTabIconSpecTests: XCTestCase {
    func testHahoTabIconsExistInCatalog() {
        XCTAssertEqual(DSIcon.hahoHome.rawValue, "icon_haho_home")
        XCTAssertEqual(DSIcon.hahoGrid.rawValue, "icon_haho_grid")
        XCTAssertEqual(DSIcon.hahoBarChart.rawValue, "icon_haho_bar_chart")
        XCTAssertEqual(DSIcon.hahoTarget.rawValue, "icon_haho_target")
    }
}

final class DSSecondaryTintTokenSpecTests: XCTestCase {
    private let theme = ThemeConfiguration(brand: .coralCamo, style: .lightRounded)

    func testLightThemeExposesSecondaryTints() {
        XCTAssertEqual(theme.colors.surfaceSecondary40, Brand.coralCamo.primitives.secondary40)
        XCTAssertEqual(theme.colors.surfaceSecondary10, Brand.coralCamo.primitives.secondary10)
    }

    func testTagBrandUsesSecondary40Pair() {
        XCTAssertEqual(DSTag.background(for: .brand, theme: theme), theme.colors.surfaceSecondary40)
        XCTAssertEqual(DSTag.foreground(for: .brand, theme: theme), theme.colors.surfaceSecondary120)
    }
}
