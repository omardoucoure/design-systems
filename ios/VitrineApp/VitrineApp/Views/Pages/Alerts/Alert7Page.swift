import SwiftUI
import DesignSystem

/// Figma: [Alerts] 7 (node 1023:87668)
struct Alert7Page: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss
    @State private var showDialog = false

    var body: some View {
        ZStack {
            VStack(spacing: theme.spacing.sm) {
                DSTopAppBar(title: "March 2030", style: .smallCentered, onBack: { dismiss() }) {
                    DSButton(style: .neutral, size: .medium, icon: .viewGrid) {}
                }
                dateRangePicker
                ScrollView {
                    VStack(spacing: theme.spacing.sm) {
                        eventDayCard(day: "16", month: "Mar", events: [
                            ("3 pm", "Team Meeting"), ("6 pm", "Design System"),
                        ])
                        eventDayCard(day: "17", month: "Mar", events: [("10 am", "Font Fiesta")])
                        eventDayCard(day: "18", month: "Mar", events: [
                            ("3 pm", "Team Meeting"), ("6 pm", "Design System"),
                        ])
                    }
                    .padding(.horizontal, theme.spacing.sm)
                }
            }
            .background(theme.colors.surfaceNeutral0_5)

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    DSButton(style: .filledA, size: .medium, icon: .plus) {}
                        .shadow(color: .black.opacity(0.02), radius: 4, x: 0, y: 4)
                        .shadow(color: .black.opacity(0.18), radius: 24, x: 0, y: 24)
                    Spacer()
                }
                .padding(.bottom, 36)
            }

            DSAlertDialog(
                isPresented: $showDialog,
                title: "HaHo's been a battery hog!",
                message: "Keep going and risk a system tantrum, or take a break? Your call.",
                severity: .warning,
                icon: .batterySlash
            ) {
                EmptyView()
            } actions: {
                DSButton("Delete App", style: .filledA, size: .medium, icon: .logOut,
                         iconPosition: .right, isFullWidth: true) {}
                DSButton("Disable Background Usage", style: .neutral, size: .medium, isFullWidth: true) {}
                DSButton("Cancel", style: .neutral, size: .medium, isFullWidth: true) { showDialog = false }
            }
        }
        .navigationBarBackButtonHidden(true)
        .dsTabBarHidden()
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.4)) { showDialog = true }
        }
    }

    private var dateRangePicker: some View {
        HStack(spacing: theme.spacing.sm) {
            dateRangeCard(label: "Starting", date: "16 March", icon: .calendarMinus)
            dateRangeCard(label: "Until", date: "30 March", icon: .calendarPlus)
        }
        .padding(.horizontal, theme.spacing.sm)
    }

    private func dateRangeCard(label: String, date: String, icon: DSIcon) -> some View {
        DSCard(background: theme.colors.surfacePrimary100, radius: theme.radius.lg, padding: 0) {
            VStack(alignment: .leading, spacing: theme.spacing.sm) {
                DSIconImage(icon, size: 24, color: theme.colors.textNeutral0_5)
                DSText(label, style: theme.typography.tiny, color: theme.colors.textNeutral0_5)
                DSText(date, style: theme.typography.body, color: theme.colors.textNeutral0_5)
            }
            .padding(.horizontal, theme.spacing.xl)
            .padding(.vertical, theme.spacing.lg)
        }
    }

    private func eventDayCard(day: String, month: String, events: [(time: String, title: String)]) -> some View {
        DSCard(background: theme.colors.surfaceNeutral2, radius: theme.radius.xl, padding: theme.spacing.xl) {
            VStack(alignment: .leading, spacing: theme.spacing.md) {
                HStack(alignment: .firstTextBaseline, spacing: theme.spacing.xs) {
                    DSText(day, style: theme.typography.display2, color: theme.colors.textNeutral9)
                    DSText(month, style: theme.typography.caption, color: theme.colors.textNeutral9)
                }
                ForEach(Array(events.enumerated()), id: \.offset) { _, event in
                    HStack {
                        VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                            DSText(event.time, style: theme.typography.bodySemiBold, color: theme.colors.textNeutral9)
                            DSText(event.title, style: theme.typography.body, color: theme.colors.textNeutral9.opacity(0.75))
                        }
                        Spacer()
                        DSIconImage(.arrowUpRight, size: 20, color: theme.colors.textNeutral9)
                    }
                    .padding(theme.spacing.lg)
                    .background(theme.colors.surfaceNeutral0_5)
                    .clipShape(RoundedRectangle(cornerRadius: theme.radius.lg))
                }
            }
        }
    }
}

#Preview {
    Alert7Page()
        .previewThemed()
}
