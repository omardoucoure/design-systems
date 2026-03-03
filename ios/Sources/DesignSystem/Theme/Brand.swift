import SwiftUI

/// The Brand axis: selects the primitive color palette.
/// Each case provides 7 brand colors + a 15-step neutral scale with unique undertone.
public enum Brand: String, CaseIterable, Sendable, Identifiable {
    case coralCamo
    case seaLime
    case mistyRose
    case blueHaze

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .coralCamo: return "Coral Camo"
        case .seaLime: return "Sea Lime"
        case .mistyRose: return "Misty Rose"
        case .blueHaze: return "Blue Haze"
        }
    }

    /// Resolves the full primitive color palette for this brand.
    public var primitives: BrandPrimitives {
        switch self {
        case .coralCamo:
            return BrandPrimitives(
                primary80: Color(hex: "#657671"),
                primary100: Color(hex: "#465A54"),
                primary120: Color(hex: "#252F2C"),
                secondary10: Color(hex: "#FFF3F2"),
                secondary40: Color(hex: "#FFC3BF"),
                secondary100: Color(hex: "#FF6A5F"),
                secondary120: Color(hex: "#EB5B52"),
                neutrals: NeutralScale(
                    n0: Color(hex: "#FFFFFF"),
                    n0_5: Color(hex: "#FAFAF9"),
                    n1: Color(hex: "#F5F5F3"),
                    n1_5: Color(hex: "#F0F0EC"),
                    n2: Color(hex: "#EBEBE6"),
                    n3: Color(hex: "#E2E1DA"),
                    n4: Color(hex: "#D8D7CD"),
                    n5: Color(hex: "#CECDC1"),
                    n6: Color(hex: "#A5A49A"),
                    n7: Color(hex: "#7C7B74"),
                    n8: Color(hex: "#52524D"),
                    n8_5: Color(hex: "#3E3E3A"),
                    n9: Color(hex: "#292927"),
                    n9_5: Color(hex: "#151513"),
                    n10: Color(hex: "#000000")
                )
            )

        case .seaLime:
            return BrandPrimitives(
                primary80: Color(hex: "#5370A1"),
                primary100: Color(hex: "#3B588A"),
                primary120: Color(hex: "#1B2940"),
                secondary10: Color(hex: "#FAFEF2"),
                secondary40: Color(hex: "#E5FBBF"),
                secondary100: Color(hex: "#B1E158"),
                secondary120: Color(hex: "#A0D342"),
                neutrals: NeutralScale(
                    n0: Color(hex: "#FFFFFF"),
                    n0_5: Color(hex: "#FAFAFA"),
                    n1: Color(hex: "#F5F6F4"),
                    n1_5: Color(hex: "#F0F1EF"),
                    n2: Color(hex: "#EBEDE9"),
                    n3: Color(hex: "#E1E3DF"),
                    n4: Color(hex: "#D7DAD5"),
                    n5: Color(hex: "#CDD1CA"),
                    n6: Color(hex: "#A4A8A2"),
                    n7: Color(hex: "#7B7E7A"),
                    n8: Color(hex: "#535551"),
                    n8_5: Color(hex: "#3E403D"),
                    n9: Color(hex: "#2A2B29"),
                    n9_5: Color(hex: "#151715"),
                    n10: Color(hex: "#000000")
                )
            )

        case .mistyRose:
            return BrandPrimitives(
                primary80: Color(hex: "#5E6B80"),
                primary100: Color(hex: "#4C5A6F"),
                primary120: Color(hex: "#262D37"),
                secondary10: Color(hex: "#FFF5FB"),
                secondary40: Color(hex: "#FED6EF"),
                secondary100: Color(hex: "#EA81C2"),
                secondary120: Color(hex: "#DC70B3"),
                neutrals: NeutralScale(
                    n0: Color(hex: "#FFFFFF"),
                    n0_5: Color(hex: "#F9F9FA"),
                    n1: Color(hex: "#F4F4F5"),
                    n1_5: Color(hex: "#EEEEF1"),
                    n2: Color(hex: "#E9E8EC"),
                    n3: Color(hex: "#DDDDE2"),
                    n4: Color(hex: "#D2D1D9"),
                    n5: Color(hex: "#C7C6CF"),
                    n6: Color(hex: "#9F9EA6"),
                    n7: Color(hex: "#77777C"),
                    n8: Color(hex: "#504F53"),
                    n8_5: Color(hex: "#3C3B3E"),
                    n9: Color(hex: "#282829"),
                    n9_5: Color(hex: "#141415"),
                    n10: Color(hex: "#000000")
                )
            )

        case .blueHaze:
            return BrandPrimitives(
                primary80: Color(hex: "#4A5FD5"),
                primary100: Color(hex: "#2742DA"),
                primary120: Color(hex: "#21253D"),
                secondary10: Color(hex: "#FCFAF8"),
                secondary40: Color(hex: "#F4EAE3"),
                secondary100: Color(hex: "#D6B7A1"),
                secondary120: Color(hex: "#CCA78F"),
                neutrals: NeutralScale(
                    n0: Color(hex: "#FFFFFF"),
                    n0_5: Color(hex: "#F9F8F8"),
                    n1: Color(hex: "#F3F1F1"),
                    n1_5: Color(hex: "#EDEBE9"),
                    n2: Color(hex: "#E7E4E2"),
                    n3: Color(hex: "#DBD6D4"),
                    n4: Color(hex: "#CFC9C5"),
                    n5: Color(hex: "#C3BBB7"),
                    n6: Color(hex: "#9C9692"),
                    n7: Color(hex: "#75706E"),
                    n8: Color(hex: "#4E4B49"),
                    n8_5: Color(hex: "#3B3837"),
                    n9: Color(hex: "#272525"),
                    n9_5: Color(hex: "#141312"),
                    n10: Color(hex: "#000000")
                )
            )
        }
    }
}
