import XCTest
import SwiftUI
@testable import DesignSystem

final class DSFlowLayoutSpecTests: XCTestCase {
    private let spacing: CGFloat = 8

    private func rows(_ widths: [CGFloat], containerWidth: CGFloat) -> [[Int]] {
        DSFlowLayout.Rows.make(widths: widths, containerWidth: containerWidth, spacing: spacing)
    }

    func testItemsThatFitShareOneRow() {
        XCTAssertEqual(rows([40, 40, 40], containerWidth: 200), [[0, 1, 2]])
    }

    func testAnItemThatDoesNotFitStartsTheNextRow() {
        XCTAssertEqual(rows([100, 100], containerWidth: 150), [[0], [1]])
    }

    func testSpacingCountsAgainstTheRowWidth() {
        XCTAssertEqual(rows([50, 50], containerWidth: 100), [[0], [1]])
        XCTAssertEqual(rows([50, 50], containerWidth: 108), [[0, 1]])
    }

    func testAnItemWiderThanTheContainerKeepsItsOwnRowRatherThanWrappingForever() {
        XCTAssertEqual(rows([300, 40], containerWidth: 100), [[0], [1]])
    }

    func testAnOversizedItemDoesNotDragTheNextItemOntoItsRow() {
        XCTAssertEqual(rows([40, 300, 40], containerWidth: 100), [[0], [1], [2]])
    }

    func testNoItemsMakeNoRows() {
        XCTAssertTrue(rows([], containerWidth: 100).isEmpty)
    }

    func testAZeroWidthContainerStillPlacesEachItemOnItsOwnRow() {
        XCTAssertEqual(rows([10, 10], containerWidth: 0), [[0], [1]])
    }

    func testTheHeightIsTheTallestItemPerRowPlusSpacingBetweenRows() {
        let size = DSFlowLayout.Rows.size(
            sizes: [CGSize(width: 60, height: 20), CGSize(width: 60, height: 30),
                    CGSize(width: 60, height: 10)],
            containerWidth: 130, spacing: spacing)
        XCTAssertEqual(size.height, 30 + spacing + 10)
    }

    func testASingleRowHasNoRowSpacingInItsHeight() {
        let size = DSFlowLayout.Rows.size(
            sizes: [CGSize(width: 20, height: 14), CGSize(width: 20, height: 22)],
            containerWidth: 200, spacing: spacing)
        XCTAssertEqual(size.height, 22)
    }

    func testAnEmptyLayoutHasNoHeight() {
        let size = DSFlowLayout.Rows.size(sizes: [], containerWidth: 200, spacing: spacing)
        XCTAssertEqual(size.height, 0)
    }

    func testTheDefaultSpacingResolvesThroughAToken() {
        XCTAssertEqual(DSFlowLayout.Metrics.defaultSpacing, SpacingTokens.shared.xs)
    }
}
