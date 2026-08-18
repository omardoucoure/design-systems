import XCTest
@testable import DesignSystem

final class DSTextAreaScrollSpecTests: XCTestCase {
    private var source: String {
        get throws {
            let url = URL(fileURLWithPath: #filePath)
                .deletingLastPathComponent()
                .deletingLastPathComponent()
                .deletingLastPathComponent()
                .appendingPathComponent("Sources/DesignSystem/Components/DSTextArea.swift")
            return try String(contentsOf: url, encoding: .utf8)
        }
    }

    func testTheEditorHidesItsScrollIndicator() throws {
        XCTAssertTrue(
            try source.contains("scrollIndicators(.hidden)"),
            "The text area draws its own surface; a system scrollbar on top of it is chrome the design does not have"
        )
    }
}
