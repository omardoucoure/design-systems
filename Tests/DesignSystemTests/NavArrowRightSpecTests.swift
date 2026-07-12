import XCTest
@testable import DesignSystem

final class NavArrowRightSpecTests: XCTestCase {
    private func iconsDirectory() -> URL {
        var url = URL(fileURLWithPath: #filePath)
        url.deleteLastPathComponent()
        url.deleteLastPathComponent()
        url.deleteLastPathComponent()
        return url
            .appendingPathComponent("Sources")
            .appendingPathComponent("DesignSystem")
            .appendingPathComponent("Resources")
            .appendingPathComponent("Icons.xcassets")
    }

    private func svg(_ imageset: String) throws -> String {
        let file = iconsDirectory()
            .appendingPathComponent("\(imageset).imageset")
            .appendingPathComponent("\(imageset).svg")
        return try String(contentsOf: file, encoding: .utf8)
    }

    func testRightChevronIsNotIdenticalToLeft() throws {
        let left = try svg("icon_nav_arrow_left")
        let right = try svg("icon_nav_arrow_right")
        XCTAssertNotEqual(left, right, "icon_nav_arrow_right must not be a copy of icon_nav_arrow_left")
    }

    func testRightChevronMirrorsHorizontally() throws {
        let right = try svg("icon_nav_arrow_right")
        XCTAssertTrue(right.contains("scale(-1, 1)"), "right chevron must mirror the left path horizontally")
    }
}
