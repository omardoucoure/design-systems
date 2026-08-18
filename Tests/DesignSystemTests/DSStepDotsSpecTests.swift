import XCTest
import SwiftUI
@testable import DesignSystem

final class DSStepDotsSpecTests: XCTestCase {
    func testTheCurrentStepIsTheOnlyWideDot() {
        for index in 0..<5 {
            XCTAssertTrue(DSStepDots.Geometry.isActive(index: index, current: index))
            XCTAssertFalse(DSStepDots.Geometry.isActive(index: index, current: index + 1))
        }
    }

    func testStepsBeforeTheCurrentOneReadAsComplete() {
        XCTAssertTrue(DSStepDots.Geometry.isComplete(index: 0, current: 2))
        XCTAssertTrue(DSStepDots.Geometry.isComplete(index: 1, current: 2))
        XCTAssertFalse(DSStepDots.Geometry.isComplete(index: 2, current: 2))
        XCTAssertFalse(DSStepDots.Geometry.isComplete(index: 3, current: 2))
    }

    func testProgressIsTheShareOfStepsCompletedIncludingTheCurrentOne() {
        XCTAssertEqual(DSStepDots.Geometry.progress(current: 0, count: 4), 0.25, accuracy: 0.0001)
        XCTAssertEqual(DSStepDots.Geometry.progress(current: 3, count: 4), 1.0, accuracy: 0.0001)
    }

    func testProgressNeverDividesByZero() {
        XCTAssertEqual(DSStepDots.Geometry.progress(current: 0, count: 0), 0, accuracy: 0.0001)
    }

    func testTheCurrentStepIsClampedIntoRange() {
        XCTAssertEqual(DSStepDots.Geometry.clamped(current: 9, count: 4), 3)
        XCTAssertEqual(DSStepDots.Geometry.clamped(current: -3, count: 4), 0)
    }
}
