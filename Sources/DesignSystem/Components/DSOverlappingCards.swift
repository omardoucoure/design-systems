// figma-node: 88:152411
import SwiftUI

public struct DSOverlappingCard: Identifiable, Sendable {
    public let id = UUID()
    public let title: LocalizedStringKey
    public let background: DSOverlappingCardColor
    public let height: CGFloat

    public init(
        title: LocalizedStringKey,
        background: DSOverlappingCardColor,
        height: CGFloat
    ) {
        self.title = title
        self.background = background
        self.height = height
    }
}

public enum DSOverlappingCardColor: Sendable {
    case primary
    case primaryDark
    case secondary
    case neutral2
    case neutral3
}

public enum DSOverlapAmount: Sendable {
    case small
    case medium
    case large
}

public struct DSOverlappingCards: View {
    @Environment(\.theme) private var theme

    private let _cards: [DSOverlappingCard]
    private let _overlap: DSOverlapAmount

    public init(cards: [DSOverlappingCard], overlap: DSOverlapAmount = .small) {
        self._cards = cards
        self._overlap = overlap
    }

    public var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(_cards.enumerated()), id: \.element.id) { index, card in
                cardView(card, isFirst: index == 0)
            }
        }
    }

    private var overlapAmount: CGFloat {
        let m = theme.components.overlappingCards
        switch _overlap {
        case .small: return m.overlapSmall
        case .medium: return m.overlapMedium
        case .large: return m.overlapLarge
        }
    }

    private func cardView(_ card: DSOverlappingCard, isFirst: Bool) -> some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            Text(card.title)
                .font(theme.typography.body.font)
                .tracking(theme.typography.body.tracking)
                .foregroundStyle(textColor(for: card.background))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, theme.spacing.xl)
        .padding(.top, isFirst ? theme.spacing.xxl : overlapAmount + theme.spacing.xl)
        .padding(.bottom, isFirst ? theme.spacing.xxl : theme.spacing.lg)
        .frame(height: card.height, alignment: isFirst ? .center : .top)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(background(for: card.background))
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))
        .padding(.top, isFirst ? 0 : -overlapAmount)
    }

    private func background(for color: DSOverlappingCardColor) -> Color {
        switch color {
        case .primary: return theme.colors.surfacePrimary100
        case .primaryDark: return theme.colors.surfacePrimary120
        case .secondary: return theme.colors.surfaceSecondary100
        case .neutral2: return theme.colors.surfaceNeutral2
        case .neutral3: return theme.colors.surfaceNeutral3
        }
    }

    private func textColor(for color: DSOverlappingCardColor) -> Color {
        switch color {
        case .primary, .primaryDark:
            return theme.colors.textNeutral05
        case .secondary, .neutral2, .neutral3:
            return theme.colors.textNeutral9
        }
    }
}
