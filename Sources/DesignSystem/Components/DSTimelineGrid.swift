import SwiftUI

// MARK: - DSTimelineSlot

/// Represents an event positioned on the timeline grid.
///
/// Events are positioned by `startHour` (column index) and `row` (vertical stacking).
/// The `columnSpan` controls how many columns wide the event card is.
public struct DSTimelineSlot {
    public let id: String
    public let startHour: Int
    public let row: Int
    public let columnSpan: Int
    public let content: AnyView

    public init<Content: View>(
        id: String,
        startHour: Int,
        row: Int = 0,
        columnSpan: Int = 4,
        @ViewBuilder content: () -> Content
    ) {
        self.id = id
        self.startHour = startHour
        self.row = row
        self.columnSpan = columnSpan
        self.content = AnyView(content())
    }
}

// MARK: - DSTimelineGrid

/// A horizontal scrollable timeline grid with tappable time columns.
///
/// Each column has a time label, dashed vertical line, and bottom dot.
/// The selected column is highlighted with accent color (orange dot, thicker line, full opacity).
/// Tapping a column selects it. The grid auto-scrolls to the selected column on appear.
///
/// Usage:
/// ```swift
/// @State private var selectedTime = "14:00"
///
/// DSTimelineGrid(
///     timeLabels: (0...23).map { String(format: "%d:00", $0) },
///     selectedTime: $selectedTime,
///     slots: [
///         DSTimelineSlot(id: "meeting", startHour: 10, row: 0, columnSpan: 4) {
///             DSEventCard(...)
///         },
///     ]
/// )
/// ```
public struct DSTimelineGrid: View {
    @Environment(\.theme) private var theme

    private let timeLabels: [String]
    @Binding private var selectedTime: String
    private let slots: [DSTimelineSlot]
    private let columnWidth: CGFloat

    public init(
        timeLabels: [String],
        selectedTime: Binding<String>,
        columnWidth: CGFloat = 56,
        slots: [DSTimelineSlot] = []
    ) {
        self.timeLabels = timeLabels
        self._selectedTime = selectedTime
        self.columnWidth = columnWidth
        self.slots = slots
    }

    /// Height for each event row (card + spacing).
    private let rowHeight: CGFloat = 100

    /// Vertical offset where event rows start (below time labels + gap).
    private let eventsTopOffset: CGFloat = 36

    public var body: some View {
        DSCard(
            background: theme.colors.surfaceNeutral2,
            radius: theme.radius.xl,
            padding: 0
        ) {
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    ZStack(alignment: .topLeading) {
                        // Time columns
                        HStack(alignment: .top, spacing: 0) {
                            ForEach(Array(timeLabels.enumerated()), id: \.offset) { index, time in
                                let isSelected = time == selectedTime
                                timeColumn(time: time, isSelected: isSelected)
                                    .frame(width: columnWidth)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            selectedTime = time
                                        }
                                    }
                                    .id(time)
                            }
                        }

                        // Event slots — positioned by hour and row
                        ForEach(slots, id: \.id) { slot in
                            slot.content
                                .frame(width: columnWidth * CGFloat(slot.columnSpan))
                                .offset(
                                    x: columnWidth * CGFloat(slot.startHour),
                                    y: eventsTopOffset + CGFloat(slot.row) * rowHeight
                                )
                                .allowsHitTesting(false)
                        }
                    }
                    .padding(.horizontal, theme.spacing.lg)
                    .padding(.vertical, theme.spacing.xl)
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation {
                            proxy.scrollTo(selectedTime, anchor: .center)
                        }
                    }
                }
            }
        }
        .clipped()
    }

    // MARK: - Time Column

    private func timeColumn(time: String, isSelected: Bool) -> some View {
        VStack(spacing: theme.spacing.md) {
            Text(time)
                .font(theme.typography.tiny.font)
                .tracking(theme.typography.tiny.tracking)
                .foregroundStyle(
                    theme.colors.textNeutral9
                        .opacity(isSelected ? 1.0 : 0.5)
                )

            VStack(spacing: 0) {
                dashedLine(isSelected: isSelected)
                    .frame(maxHeight: .infinity)

                Circle()
                    .fill(isSelected ? theme.colors.surfaceSecondary100 : theme.colors.textNeutral9.opacity(0.5))
                    .frame(
                        width: isSelected ? 10 : 5,
                        height: isSelected ? 10 : 5
                    )
            }
        }
    }

    // MARK: - Dashed Line

    private func dashedLine(isSelected: Bool) -> some View {
        GeometryReader { geo in
            Path { path in
                path.move(to: CGPoint(x: geo.size.width / 2, y: 0))
                path.addLine(to: CGPoint(x: geo.size.width / 2, y: geo.size.height))
            }
            .stroke(
                isSelected ? theme.colors.surfaceSecondary100 : theme.colors.textNeutral9.opacity(0.5),
                style: StrokeStyle(
                    lineWidth: isSelected ? 2 : 1,
                    dash: [4, 4]
                )
            )
        }
        .frame(width: 2)
    }
}
