import SwiftUI
import DesignSystem

// MARK: - Alert11Page

/// Figma: [Alerts] 11 (node 1025:91375)
///
/// Background: day picker + timeline with event cards.
/// Overlay: dark dialog (surfacePrimary120) with bell icon, "Turn On" + "Maybe Later".
struct Alert11Page: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss
    @State private var showDialog = false
    @State private var selectedDay = 8
    @State private var selectedTime = "14:00"

    var body: some View {
        ZStack {
            // Background: Schedule page — Figma: gap=sm(12), px=sm(12), py=0
            VStack(spacing: theme.spacing.sm) {
                DSTopAppBar(title: "Today, 8 Aug", style: .smallCentered, onBack: { dismiss() }) {
                    DSButton(style: .neutral, size: .medium, icon: .calendar) {}
                }

                // Days row
                DSWeekStrip(items: weekDays, selectedId: $selectedDay)
                    .padding(.horizontal, theme.spacing.sm)

                // Timeline
                DSTimelineGrid(
                    timeLabels: (0...23).map { String(format: "%d:00", $0) },
                    selectedTime: $selectedTime,
                    slots: timelineSlots
                )
                .frame(maxHeight: .infinity)
                .padding(.horizontal, theme.spacing.sm)
                .padding(.bottom, theme.spacing.sm)
            }
            .background(theme.colors.surfaceNeutral0_5.ignoresSafeArea())

            // Dialog overlay
            DSAlertDialog(
                isPresented: $showDialog,
                title: "Don't miss a beat!",
                message: "Enable notifications to catch all the important updates as they happen.",
                severity: .neutral,
                icon: .bellNotification
            ) {
                EmptyView()
            } actions: {
                DSButton(
                    "Turn On",
                    style: .filledA,
                    size: .medium,
                    icon: .switchOn,
                    iconPosition: .right,
                    isFullWidth: true
                ) {}
                DSButton("Maybe Later", style: .neutral, size: .medium, isFullWidth: true) {}
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .dsTabBarHidden()
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.4)) {
                showDialog = true
            }
        }
    }

    // MARK: - Data

    private let weekDays: [DSWeekStripItem] = [
        DSWeekStripItem(letter: "T", number: 1),
        DSWeekStripItem(letter: "F", number: 2),
        DSWeekStripItem(letter: "S", number: 3),
        DSWeekStripItem(letter: "S", number: 4),
        DSWeekStripItem(letter: "M", number: 5),
        DSWeekStripItem(letter: "T", number: 6),
        DSWeekStripItem(letter: "W", number: 7),
        DSWeekStripItem(letter: "T", number: 8),
        DSWeekStripItem(letter: "F", number: 9),
        DSWeekStripItem(letter: "S", number: 10),
        DSWeekStripItem(letter: "S", number: 11),
        DSWeekStripItem(letter: "M", number: 12),
        DSWeekStripItem(letter: "T", number: 13),
        DSWeekStripItem(letter: "W", number: 14),
        DSWeekStripItem(letter: "T", number: 15),
        DSWeekStripItem(letter: "F", number: 16),
        DSWeekStripItem(letter: "S", number: 17),
        DSWeekStripItem(letter: "S", number: 18),
        DSWeekStripItem(letter: "M", number: 19),
        DSWeekStripItem(letter: "T", number: 20),
        DSWeekStripItem(letter: "W", number: 21),
        DSWeekStripItem(letter: "T", number: 22),
        DSWeekStripItem(letter: "F", number: 23),
        DSWeekStripItem(letter: "S", number: 24),
        DSWeekStripItem(letter: "S", number: 25),
        DSWeekStripItem(letter: "M", number: 26),
        DSWeekStripItem(letter: "T", number: 27),
        DSWeekStripItem(letter: "W", number: 28),
        DSWeekStripItem(letter: "T", number: 29),
        DSWeekStripItem(letter: "F", number: 30),
        DSWeekStripItem(letter: "S", number: 31),
    ]

    private var timelineSlots: [DSTimelineSlot] {
        [
            // 10:00–14:00 (startHour=10, row=0, spans 4 cols)
            DSTimelineSlot(id: "design-systems", startHour: 10, row: 0, columnSpan: 4) {
                DSEventCard(
                    title: "Design Systems",
                    subtitle: "Unleash your ideas in a storm of creativity!",
                    icon: .eye,
                    background: theme.colors.surfaceSecondary100,
                    foreground: theme.colors.textNeutral9
                )
            },
            // 12:00–15:00 (startHour=12, row=1, spans 3 cols)
            DSTimelineSlot(id: "font-fiesta", startHour: 12, row: 1, columnSpan: 3) {
                DSEventCard(
                    title: "Font Fiesta",
                    subtitle: "Celebrate the art of typography by geeking out over serifs and sans-serifs.",
                    icon: .textSize,
                    background: theme.colors.surfacePrimary100,
                    foreground: theme.colors.textNeutral0_5
                )
            },
            // 15:00–19:00 (startHour=15, row=2, spans 4 cols)
            DSTimelineSlot(id: "sustainability", startHour: 15, row: 2, columnSpan: 4) {
                DSEventCard(
                    title: "Sustainability in Design Symposium",
                    subtitle: "Discover how to save the world!",
                    icon: .timer,
                    background: theme.colors.surfaceSecondary100,
                    foreground: theme.colors.textNeutral9
                )
            },
            // 10:00–14:00 (startHour=10, row=3, spans 4 cols)
            DSTimelineSlot(id: "hackathon", startHour: 10, row: 3, columnSpan: 4) {
                DSEventCard(
                    title: "Design Hackathon",
                    subtitle: "Race against time and caffeine shortages to create the next big thing in design.",
                    icon: .running,
                    background: theme.colors.surfacePrimary100,
                    foreground: theme.colors.textNeutral0_5
                )
            },
        ]
    }
}

#Preview {
    Alert11Page()
        .previewThemed()
}
