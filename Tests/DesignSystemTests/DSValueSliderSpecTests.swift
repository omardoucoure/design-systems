import XCTest
@testable import DesignSystem

final class DSValueSliderSpecTests: XCTestCase {
    func testKnobIsVisibleWhenValueIsNil() {
        XCTAssertTrue(DSValueSlider.Geometry.showsKnob(value: nil))
    }

    func testKnobIsVisibleWhenValueIsSet() {
        XCTAssertTrue(DSValueSlider.Geometry.showsKnob(value: 3))
    }

    func testNilValuePlacesKnobAtMiddle() {
        let fraction = DSValueSlider.Geometry.knobFraction(value: nil, in: 1...5)
        XCTAssertEqual(fraction, 0.5, accuracy: 0.0001)
    }

    func testSetValuePlacesKnobByRange() {
        XCTAssertEqual(DSValueSlider.Geometry.knobFraction(value: 1, in: 1...5), 0.0, accuracy: 0.0001)
        XCTAssertEqual(DSValueSlider.Geometry.knobFraction(value: 5, in: 1...5), 1.0, accuracy: 0.0001)
        XCTAssertEqual(DSValueSlider.Geometry.knobFraction(value: 3, in: 1...5), 0.5, accuracy: 0.0001)
    }

    func testFilledTrackOnlyWhenValueIsSet() {
        XCTAssertFalse(DSValueSlider.Geometry.showsFilledTrack(value: nil))
        XCTAssertTrue(DSValueSlider.Geometry.showsFilledTrack(value: 2))
    }
}
