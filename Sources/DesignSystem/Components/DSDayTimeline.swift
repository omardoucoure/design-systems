// figma-node: 87:99677
import SwiftUI

public enum DSDayTimelineEventColor: Sendable {
    case neutral
    case secondary
    case primary
}

public struct DSDayTimelineEvent: Identifiable, Sendable {
    public let id = UUID()
    public let title: LocalizedStringKey
    public let time: LocalizedStringKey
    public let icon: DSIcon
    public let color: DSDayTimelineEventColor
    public let startRow: Int
    public let rowSpan: Int

    public init(
        title: LocalizedStringKey,
        time: LocalizedStringKey,
        icon: DSIcon,
        color: DSDayTimelineEventColor,
        startRow: Int,
        rowSpan: Int = 1
    ) {
        self.title = title
        self.time = time
        self.icon = icon
        self.color = color
        self.startRow = startRow
        self.rowSpan = rowSpan
    }
}

public struct DSDayTimeline: View {
    @Environment(\.theme) private var theme

    private let _hours: [LocalizedStringKey]
    private let _activeHour: Int?
    private let _events: [DSDayTimelineEvent]

    public init(
        hours: [LocalizedStringKey],
        activeHour: Int? = nil,
        events: [DSDayTimelineEvent] = []
    ) {
        self._hours = hours
        self._activeHour = activeHour
        self._events = events
    }

    private var metrics: DayTimelineComponentTokens { theme.components.dayTimeline }

    public var body: some View {
        ZStack(alignment: .topLeading) {
            hourRows
            eventOverlay
        }
        .padding(.horizontal, theme.spacing.lg)
        .padding(.vertical, theme.spacing.xl)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.colors.surfaceNeutral2)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))
    }

    private var hourRows: some View {
        VStack(spacing: metrics.rowSpacing) {
            ForEach(Array(_hours.enumerated()), id: \.offset) { index, label in
                hourRow(label: label, isActive: index == _activeHour)
                    .frame(height: metrics.rowHeight)
            }
        }
    }

    private func hourRow(label: LocalizedStringKey, isActive: Bool) -> some View {
        HStack(spacing: theme.spacing.md) {
            Text(label)
                .font(theme.typography.tinySemiBold.font)
                .tracking(theme.typography.tinySemiBold.tracking)
                .foregroundStyle(theme.colors.textNeutral9)
                .opacity(isActive ? theme.opacity.full : theme.opacity.md)
                .frame(width: metrics.labelWidth, alignment: .center)

            if isActive {
                activeLine
            } else {
                Capsule()
                    .fill(theme.colors.borderNeutral8)
                    .frame(height: theme.borders.widthSm)
                    .opacity(theme.opacity.md)
            }
        }
    }

    private var activeLine: some View {
        HStack(spacing: 0) {
            Circle()
                .fill(theme.colors.surfaceSecondary100)
                .frame(width: metrics.activeDotSize, height: metrics.activeDotSize)

            Capsule()
                .fill(theme.colors.surfaceSecondary100)
                .frame(height: theme.borders.widthMd)

            Circle()
                .fill(theme.colors.surfaceSecondary100)
                .frame(width: metrics.activeDotSize, height: metrics.activeDotSize)
        }
    }

    private var eventOverlay: some View {
        GeometryReader { geo in
            ForEach(_events) { event in
                DSDayTimelineEventCard(event: event)
                    .frame(width: geo.size.width - metrics.eventLeadingInset)
                    .offset(
                        x: metrics.eventLeadingInset,
                        y: rowOffset(for: event.startRow)
                    )
            }
        }
    }

    private func rowOffset(for row: Int) -> CGFloat {
        CGFloat(row) * (metrics.rowHeight + metrics.rowSpacing)
    }
}

struct DSDayTimelineEventCard: View {
    @Environment(\.theme) private var theme
    let event: DSDayTimelineEvent

    private var metrics: DayTimelineComponentTokens { theme.components.dayTimeline }

    var body: some View {
        HStack(alignment: .top, spacing: theme.spacing.md) {
            VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                Text(event.title)
                    .font(theme.typography.bodySemiBold.font)
                    .tracking(theme.typography.bodySemiBold.tracking)
                    .foregroundStyle(foreground)

                Text(event.time)
                    .font(theme.typography.tiny.font)
                    .tracking(theme.typography.tiny.tracking)
                    .foregroundStyle(foreground)
                    .opacity(theme.opacity.lg)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Image(dsIcon: event.icon)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: metrics.eventIconSize, height: metrics.eventIconSize)
                .foregroundStyle(foreground)
        }
        .padding(theme.spacing.lg)
        .frame(height: cardHeight, alignment: .center)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.lg))
    }

    private var cardHeight: CGFloat {
        CGFloat(event.rowSpan) * metrics.rowHeight
            + CGFloat(max(0, event.rowSpan - 1)) * metrics.rowSpacing
    }

    private var background: Color {
        switch event.color {
        case .neutral: return theme.colors.surfaceNeutral3
        case .secondary: return theme.colors.surfaceSecondary100
        case .primary: return theme.colors.surfacePrimary100
        }
    }

    private var foreground: Color {
        switch event.color {
        case .neutral, .secondary: return theme.colors.textNeutral9
        case .primary: return theme.colors.textNeutral05
        }
    }
}
