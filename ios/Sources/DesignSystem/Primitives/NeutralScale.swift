import SwiftUI

/// 15-step neutral color scale with brand-specific undertone.
/// Steps: 0, 0.5, 1, 1.5, 2, 3, 4, 5, 6, 7, 8, 8.5, 9, 9.5, 10
public struct NeutralScale: Sendable {
    public let n0: Color
    public let n0_5: Color
    public let n1: Color
    public let n1_5: Color
    public let n2: Color
    public let n3: Color
    public let n4: Color
    public let n5: Color
    public let n6: Color
    public let n7: Color
    public let n8: Color
    public let n8_5: Color
    public let n9: Color
    public let n9_5: Color
    public let n10: Color

    public init(
        n0: Color, n0_5: Color, n1: Color, n1_5: Color, n2: Color,
        n3: Color, n4: Color, n5: Color, n6: Color, n7: Color,
        n8: Color, n8_5: Color, n9: Color, n9_5: Color, n10: Color
    ) {
        self.n0 = n0
        self.n0_5 = n0_5
        self.n1 = n1
        self.n1_5 = n1_5
        self.n2 = n2
        self.n3 = n3
        self.n4 = n4
        self.n5 = n5
        self.n6 = n6
        self.n7 = n7
        self.n8 = n8
        self.n8_5 = n8_5
        self.n9 = n9
        self.n9_5 = n9_5
        self.n10 = n10
    }
}
