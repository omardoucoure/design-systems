import SwiftUI

/// 15-step neutral color scale with brand-specific undertone.
/// Steps: 0, 0.5, 1, 1.5, 2, 3, 4, 5, 6, 7, 8, 8.5, 9, 9.5, 10
public struct NeutralScale: Sendable {
    public let n0: Color
    public let n05: Color
    public let n1: Color
    public let n15: Color
    public let n2: Color
    public let n3: Color
    public let n4: Color
    public let n5: Color
    public let n6: Color
    public let n7: Color
    public let n8: Color
    public let n85: Color
    public let n9: Color
    public let n95: Color
    public let n10: Color

    public init(
        n0: Color, n05: Color, n1: Color, n15: Color, n2: Color,
        n3: Color, n4: Color, n5: Color, n6: Color, n7: Color,
        n8: Color, n85: Color, n9: Color, n95: Color, n10: Color
    ) {
        self.n0 = n0
        self.n05 = n05
        self.n1 = n1
        self.n15 = n15
        self.n2 = n2
        self.n3 = n3
        self.n4 = n4
        self.n5 = n5
        self.n6 = n6
        self.n7 = n7
        self.n8 = n8
        self.n85 = n85
        self.n9 = n9
        self.n95 = n95
        self.n10 = n10
    }
}
