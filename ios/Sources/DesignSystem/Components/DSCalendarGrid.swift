import SwiftUI

// MARK: - DSCalendarGridMode

/// Selection mode for the calendar.
public enum DSCalendarGridMode: Sendable {
    /// Tap to select a single date.
    case single
    /// Tap to select start, then tap again for end (range).
    case range
}

// MARK: - DSCalendarGrid

/// An interactive calendar grid with month navigation, day-of-week headers,
/// tappable date cells, and range selection support.
///
/// The component computes its own weeks from `displayedMonth` and the system calendar.
///
/// Usage:
/// ```swift
/// @State var month = DateComponents(calendar: .current, year: 2030, month: 8).date!
/// @State var start: Date? = nil
/// @State var end: Date? = nil
///
/// DSCalendarGrid(
///     displayedMonth: $month,
///     rangeStart: $start,
///     rangeEnd: $end,
///     mode: .range
/// )
/// ```
public struct DSCalendarGrid: View {
    @Environment(\.theme) private var theme

    @Binding private var displayedMonth: Date
    @Binding private var rangeStart: Date?
    @Binding private var rangeEnd: Date?
    private let mode: DSCalendarGridMode
    private let highlightColor: Color?
    private let rangeColor: Color?

    @State private var showMonthPicker = false

    private let calendar = Calendar.current

    public init(
        displayedMonth: Binding<Date>,
        rangeStart: Binding<Date?>,
        rangeEnd: Binding<Date?> = .constant(nil),
        mode: DSCalendarGridMode = .range,
        highlightColor: Color? = nil,
        rangeColor: Color? = nil
    ) {
        self._displayedMonth = displayedMonth
        self._rangeStart = rangeStart
        self._rangeEnd = rangeEnd
        self.mode = mode
        self.highlightColor = highlightColor
        self.rangeColor = rangeColor
    }

    public var body: some View {
        VStack(spacing: 0) {
            monthSelectorRow
            daysOfWeekHeader
            calendarRows
        }
    }

    // MARK: - Month/Year Label

    private var monthYearLabel: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: displayedMonth)
    }

    // MARK: - Month Selector

    private var monthSelectorRow: some View {
        HStack {
            // Month label button — tappable to show picker
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    showMonthPicker.toggle()
                }
            } label: {
                HStack(spacing: theme.spacing.sm) {
                    Text(monthYearLabel)
                        .font(theme.typography.label.font)
                        .tracking(theme.typography.label.tracking)
                        .foregroundStyle(theme.colors.textNeutral9)
                    Image(dsIcon: .arrowSeparateVertical)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(theme.colors.textNeutral9)
                }
                .padding(.horizontal, theme.spacing.md)
                .padding(.vertical, theme.spacing.xs)
                .frame(height: 40)
                .background(showMonthPicker ? theme.colors.surfaceSecondary100 : theme.colors.surfaceNeutral3)
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)

            Spacer()

            // Navigation arrows
            HStack(spacing: 0) {
                Button {
                    navigateMonth(by: -1)
                } label: {
                    Image(dsIcon: .arrowLeftLong)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(theme.colors.textNeutral9)
                        .padding(theme.spacing.xs)
                }
                .buttonStyle(.plain)

                Button {
                    navigateMonth(by: 1)
                } label: {
                    Image(dsIcon: .arrowRightLong)
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(theme.colors.textNeutral9)
                        .padding(theme.spacing.xs)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, theme.spacing.xs)
            .frame(height: 40)
            .background(theme.colors.surfaceNeutral3)
            .clipShape(Capsule())
        }
        .padding(.vertical, theme.spacing.sm)
    }

    // MARK: - Month/Year Picker Overlay

    @ViewBuilder
    private var monthYearPicker: some View {
        if showMonthPicker {
            VStack(spacing: theme.spacing.sm) {
                // Year navigation
                HStack {
                    Button {
                        navigateYear(by: -1)
                    } label: {
                        Image(dsIcon: .arrowLeftLong)
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(theme.colors.textNeutral9)
                    }
                    .buttonStyle(.plain)

                    Spacer()

                    Text(String(calendar.component(.year, from: displayedMonth)))
                        .font(theme.typography.bodySemiBold.font)
                        .tracking(theme.typography.bodySemiBold.tracking)
                        .foregroundStyle(theme.colors.textNeutral9)

                    Spacer()

                    Button {
                        navigateYear(by: 1)
                    } label: {
                        Image(dsIcon: .arrowRightLong)
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(theme.colors.textNeutral9)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, theme.spacing.sm)

                // Month grid (3 columns × 4 rows)
                let months = Calendar.current.shortMonthSymbols
                let currentMonth = calendar.component(.month, from: displayedMonth)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: theme.spacing.xs) {
                    ForEach(Array(months.enumerated()), id: \.offset) { index, name in
                        let isSelected = index + 1 == currentMonth
                        Button {
                            selectMonth(index + 1)
                        } label: {
                            Text(name)
                                .font(theme.typography.caption.font)
                                .tracking(theme.typography.caption.tracking)
                                .foregroundStyle(theme.colors.textNeutral9)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, theme.spacing.xs)
                                .background(isSelected ? (highlightColor ?? theme.colors.surfaceSecondary100) : Color.clear)
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(theme.spacing.md)
            .background(theme.colors.surfaceNeutral3)
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.md))
            .transition(.opacity.combined(with: .scale(scale: 0.95, anchor: .topLeading)))
        }
    }

    // MARK: - Days of Week Header

    @ViewBuilder
    private var daysOfWeekHeader: some View {
        if showMonthPicker {
            monthYearPicker
        } else {
            dayHeaders
        }
    }

    private var dayHeaders: some View {
        let days = ["M", "T", "W", "T", "F", "S", "S"]
        return HStack(spacing: 0) {
            ForEach(Array(days.enumerated()), id: \.offset) { _, day in
                Text(day)
                    .font(theme.typography.body.font)
                    .tracking(theme.typography.body.tracking)
                    .foregroundStyle(theme.colors.textNeutral9.opacity(theme.colors.textOpacity75))
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
            }
        }
    }

    // MARK: - Calendar Rows

    @ViewBuilder
    private var calendarRows: some View {
        if !showMonthPicker {
            let weeks = computeWeeks()
            VStack(spacing: 0) {
                ForEach(Array(weeks.enumerated()), id: \.offset) { _, week in
                    ZStack {
                        rangeBackground(week: week)

                        HStack(spacing: 0) {
                            ForEach(0..<7, id: \.self) { dayIndex in
                                let dayDate = dayIndex < week.count ? week[dayIndex] : nil
                                dateCell(dayDate: dayDate)
                            }
                        }
                    }
                    .frame(height: 48)
                }
            }
        }
    }

    // MARK: - Date Cell

    private func dateCell(dayDate: Date?) -> some View {
        let day = dayDate.map { calendar.component(.day, from: $0) }
        let isHighlighted = dayDate.map { isDateHighlighted($0) } ?? false
        return Button {
            guard let dayDate else { return }
            handleDateTap(dayDate)
        } label: {
            ZStack {
                if isHighlighted {
                    Circle()
                        .fill(highlightColor ?? theme.colors.surfaceSecondary100)
                        .frame(width: 40, height: 40)
                }

                if let day {
                    Text("\(day)")
                        .font(theme.typography.body.font)
                        .tracking(theme.typography.body.tracking)
                        .foregroundStyle(theme.colors.textNeutral9)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
        }
        .buttonStyle(.plain)
        .disabled(dayDate == nil)
    }

    // MARK: - Range Background

    private func rangeBackground(week: [Date?]) -> some View {
        GeometryReader { geo in
            let cellWidth = geo.size.width / 7.0
            let resolvedRangeColor = rangeColor ?? theme.colors.surfaceNeutral3

            let rangeCols = week.enumerated().compactMap { index, date -> Int? in
                guard let date, isDateInRange(date) else { return nil }
                return index
            }

            if let firstCol = rangeCols.first, let lastCol = rangeCols.last, firstCol != lastCol {
                let startX = CGFloat(firstCol) * cellWidth
                let endX = CGFloat(lastCol + 1) * cellWidth

                Capsule()
                    .fill(resolvedRangeColor)
                    .frame(width: endX - startX, height: 40)
                    .position(x: startX + (endX - startX) / 2, y: geo.size.height / 2)
            }
        }
    }

    // MARK: - Helpers

    private func isDateHighlighted(_ date: Date) -> Bool {
        if let start = rangeStart, calendar.isDate(date, inSameDayAs: start) { return true }
        if let end = rangeEnd, calendar.isDate(date, inSameDayAs: end) { return true }
        return false
    }

    private func isDateInRange(_ date: Date) -> Bool {
        guard let start = rangeStart, let end = rangeEnd else { return false }
        let earliest = min(start, end)
        let latest = max(start, end)
        return date >= calendar.startOfDay(for: earliest) && date <= calendar.startOfDay(for: latest)
    }

    private func handleDateTap(_ date: Date) {
        withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
            switch mode {
            case .single:
                rangeStart = date
                rangeEnd = nil
            case .range:
                if rangeStart == nil || rangeEnd != nil {
                    // Start new selection
                    rangeStart = date
                    rangeEnd = nil
                } else {
                    // Complete the range
                    rangeEnd = date
                    // Ensure start ≤ end
                    if let s = rangeStart, let e = rangeEnd, e < s {
                        rangeStart = e
                        rangeEnd = s
                    }
                }
            }
        }
    }

    private func navigateMonth(by offset: Int) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            if let newMonth = calendar.date(byAdding: .month, value: offset, to: displayedMonth) {
                displayedMonth = newMonth
            }
        }
    }

    private func navigateYear(by offset: Int) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            if let newDate = calendar.date(byAdding: .year, value: offset, to: displayedMonth) {
                displayedMonth = newDate
            }
        }
    }

    private func selectMonth(_ month: Int) {
        let year = calendar.component(.year, from: displayedMonth)
        if let newDate = DateComponents(calendar: calendar, year: year, month: month, day: 1).date {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                displayedMonth = newDate
                showMonthPicker = false
            }
        }
    }

    /// Compute weeks grid for the currently displayed month.
    /// Each week is an array of 7 optional Dates (nil for empty cells).
    /// Week starts on Monday.
    private func computeWeeks() -> [[Date?]] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: displayedMonth) else {
            return []
        }

        let firstDay = monthInterval.start
        // Weekday: 1=Sunday...7=Saturday. Convert to Monday-based: Mon=0..Sun=6.
        let firstWeekday = calendar.component(.weekday, from: firstDay)
        let mondayOffset = (firstWeekday + 5) % 7

        let daysInMonth = calendar.range(of: .day, in: .month, for: displayedMonth)?.count ?? 30

        var weeks: [[Date?]] = []
        var currentWeek: [Date?] = Array(repeating: nil, count: mondayOffset)

        for day in 1...daysInMonth {
            if let date = calendar.date(bySetting: .day, value: day, of: firstDay) {
                currentWeek.append(date)
            }
            if currentWeek.count == 7 {
                weeks.append(currentWeek)
                currentWeek = []
            }
        }

        // Pad last week with nils
        if !currentWeek.isEmpty {
            while currentWeek.count < 7 {
                currentWeek.append(nil)
            }
            weeks.append(currentWeek)
        }

        return weeks
    }
}
