import XCTest
@testable import DesignSystem

final class DSTextAreaSpecTests: XCTestCase {
    func testPlaceholderAndEditorShareTheSameLeadingInset() {
        XCTAssertEqual(DSTextArea.Geometry.placeholderLeadingInset,
                       DSTextArea.Geometry.editorLeadingInset,
                       accuracy: 0.0001,
                       "a placeholder offset from the editor puts the caret beside the placeholder glyphs")
    }

    func testPlaceholderAndEditorShareTheSameTopInset() {
        XCTAssertEqual(DSTextArea.Geometry.placeholderTopInset,
                       DSTextArea.Geometry.editorTopInset,
                       accuracy: 0.0001,
                       "a placeholder offset from the editor puts the caret above the placeholder glyphs")
    }

    func testEditorBuiltInInsetIsNeutralised() {
        XCTAssertEqual(DSTextArea.Geometry.editorTextContainerInset, .zero,
                       "TextEditor's own inset is unknown to the placeholder, so it must not apply one")
        XCTAssertEqual(DSTextArea.Geometry.editorLineFragmentPadding, 0, accuracy: 0.0001,
                       "line fragment padding shifts the caret without shifting the placeholder")
    }
}
