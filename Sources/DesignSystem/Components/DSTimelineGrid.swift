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
/// Usage (modifier API):
/// ```swift
/// @State private var selectedTime = "14:00"
///
/// DSTimelineGrid(
///     timeLabels: (0...23).map { String(format: "%d:00", $0) },
///     selectedTime: $selectedTime,
///     slots: [
///         DSTimelineSlot(id: "meeting", startHour: 10, row: 0, columnSpan: 4) {
///             DSEventCard(title: "Meeting", subtitle: "Team sync")
///         },
///     ]
/// )
/// .timelineColumnWidth(60)
/// ```
public struct DSTimelineGrid: View {
    @Environment(\.theme) private var theme

    // Core (required)
    private var _timeLabels: [String]
    @Binding private var _selectedTime: String
    private var _slots: [DSTimelineSlot]

    // Modifier props (optional, with defaults)
    private var _columnWidth: CGFloat = 56

    /// Height for each event row (card + spacing).
    private let rowHeight: CGFloat = 100

    /// Vertical offset where event rows start (below time labels + gap).
    private let eventsTopOffset: CGFloat = 36

    // MARK: - New Modifier API

    /// Creates a timeline grid with time labels, selection binding, and event slots.
    public init(
        timeLabels: [String],
        selectedTime: Binding<String>,
        slots: [DSTimelineSlot] = []
    ) {
        self._timeLabels = timeLabels
        self.__selectedTime = selectedTime
        self._slots = slots
    }

    /// Sets the width of each time column. Default is 56.
    public func timelineColumnWidth(_ width: CGFloat) -> Self {
        var copy = self; copy._columnWidth = width; return copy
    }

    // MARK: - Deprecated Init

    @available(*, deprecated, message: "Use DSTimelineGrid(timeLabels:selectedTime:slots:) with modifier methods instead")
    public init(
        timeLabels: [String],
        selectedTime: Binding<String>,
        columnWidth: CGFloat,
        slots: [DSTimelineSlot] = []
    ) {
        self._timeLabels = timeLabels
        self.__selectedTime = selectedTime
        self._columnWidth = columnWidth
        self._slots = slots
    }

    public var body: some View {
        DSCard {
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    ZStack(alignment: .topLeading) {
                        // Time columns
                        HStack(alignment: .top, spacing: 0) {
                            ForEach(Array(_timeLabels.enumerated()), id: \.offset) { index, time in
                                let isSelected = time == _selectedTime
                                timeColumn(time: time, isSelected: isSelected)
                                    .frame(width: _columnWidth)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            _selectedTime = time
                                        }
                                    }
                                    .id(time)
                            }
                        }

                        // Event slots — positioned by hour and row
                        ForEach(_slots, id: \.id) { slot in
                            slot.content
                                .frame(width: _columnWidth * CGFloat(slot.columnSpan))
                                .offset(
                                    x: _columnWidth * CGFloat(slot.startHour),
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
                            proxy.scrollTo(_selectedTime, anchor: .center)
                        }
                    }
                }
            }
        }
        .cardPadding(0)
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
