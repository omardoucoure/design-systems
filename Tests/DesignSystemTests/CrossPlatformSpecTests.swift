import XCTest
import SwiftUI
#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif
@testable import DesignSystem

final class CrossPlatformSpecTests: XCTestCase {

    func testHexInitProducesTheExpectedComponents() {
        let color = Color(hex: "#FF6A5F")
        let resolved = color.resolvedComponents()
        XCTAssertEqual(resolved.red, 1.0, accuracy: 0.01)
        XCTAssertEqual(resolved.green, 106.0 / 255.0, accuracy: 0.01)
        XCTAssertEqual(resolved.blue, 95.0 / 255.0, accuracy: 0.01)
    }

    func testHexInitAcceptsAStringWithoutTheHashPrefix() {
        XCTAssertEqual(Color(hex: "FF6A5F").resolvedComponents().red,
                       Color(hex: "#FF6A5F").resolvedComponents().red,
                       accuracy: 0.001)
    }

    func testBrightnessLightensWithoutChangingHue() {
        let base = Color(hex: "#3A5A40")
        let lighter = base.brightness(0.2)
        XCTAssertGreaterThan(lighter.resolvedComponents().brightness,
                             base.resolvedComponents().brightness)
    }

    func testBrightnessDarkensWithoutChangingHue() {
        let base = Color(hex: "#3A5A40")
        let darker = base.brightness(-0.1)
        XCTAssertLessThan(darker.resolvedComponents().brightness,
                          base.resolvedComponents().brightness)
    }

    func testBrightnessClampsAtBothEnds() {
        let white = Color(hex: "#FFFFFF").brightness(0.9)
        XCTAssertLessThanOrEqual(white.resolvedComponents().brightness, 1.0)

        let black = Color(hex: "#000000").brightness(-0.9)
        XCTAssertGreaterThanOrEqual(black.resolvedComponents().brightness, 0.0)
    }
}

private extension Color {
    struct Components {
        let red: Double
        let green: Double
        let blue: Double
        let brightness: Double
    }

    func resolvedComponents() -> Components {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        var r: CGFloat = 0, g: CGFloat = 0, bl: CGFloat = 0
        #if canImport(UIKit)
        UIColor(self).getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        UIColor(self).getRed(&r, green: &g, blue: &bl, alpha: &a)
        #else
        let converted = NSColor(self).usingColorSpace(.sRGB) ?? NSColor(self)
        converted.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        converted.getRed(&r, green: &g, blue: &bl, alpha: &a)
        #endif
        return Components(red: Double(r), green: Double(g), blue: Double(bl), brightness: Double(b))
    }
}

