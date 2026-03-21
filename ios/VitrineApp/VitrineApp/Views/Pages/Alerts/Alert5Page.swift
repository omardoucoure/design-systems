import SwiftUI
import DesignSystem

/// Figma: [Alerts] 5 - Success (node 1021:81139)
struct Alert5Page: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss
    @State private var showBanner = false
    @State private var displayedMonth: Date = {
        DateComponents(calendar: .current, year: 2030, month: 8, day: 1).date ?? Date()
    }()
    @State private var rangeStart: Date? = {
        DateComponents(calendar: .current, year: 2030, month: 8, day: 14).date
    }()
    @State private var rangeEnd: Date? = {
        DateComponents(calendar: .current, year: 2030, month: 8, day: 17).date
    }()

    var body: some View {
        ZStack {
            VStack(spacing: theme.spacing.sm) {
                DSTopAppBar(title: "Statistics", style: .smallCentered, onBack: { dismiss() }) {
                    DSAvatar(style: .image(Image("avatar_contact")),
                             size: CGSize(width: 56, height: 40), shape: .roundedRect(theme.radius.sm))
                }
                ZStack(alignment: .top) {
                    contentCard
                    if showBanner {
                        DSBanner(title: "Boom!",
                                 message: "You've successfully completed the mission. Treat yourself!",
                                 severity: .success,
                                 onDismiss: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { showBanner = false }
                        })
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
            }
            .padding(.horizontal, theme.spacing.sm)
            .padding(.bottom, theme.spacing.sm)

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    DSButton(style: .filledB, size: .medium, icon: .running) {}
                        .shadow(color: .black.opacity(0.02), radius: 8, x: 0, y: 4)
                        .shadow(color: .black.opacity(0.18), radius: 48, x: 0, y: 24)
                        .padding(.trailing, 36)
                }
                .padding(.bottom, 36)
            }
        }
        .background(theme.colors.surfaceNeutral0_5.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .dsTabBarHidden()
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.4)) { showBanner = true }
        }
    }

    private var contentCard: some View {
        ZStack(alignment: .topTrailing) {
            DSCard(background: theme.colors.surfaceNeutral2, radius: theme.radius.xl, padding: 0) {
                VStack(spacing: 0) {
                    gaugeSection
                        .padding(.top, theme.spacing.xxxl)
                        .padding(.horizontal, theme.spacing.xl)
                    DSCalendarGrid(displayedMonth: $displayedMonth, rangeStart: $rangeStart,
                                   rangeEnd: $rangeEnd, mode: .range)
                        .padding(.horizontal, theme.spacing.xl)
                }
                .padding(.bottom, theme.spacing.xxl)
            }
            .clipped()
            DSButton(style: .neutralLight, size: .medium, icon: .heart) {}
                .padding(.trailing, theme.spacing.lg)
                .padding(.top, theme.spacing.lg)
        }
    }

    private var gaugeSection: some View {
        ZStack {
            DSSemiCircularGauge(segments: [
                .init(fraction: 0.55, color: theme.colors.textNeutral9),
                .init(fraction: 0.22, color: theme.colors.surfaceSecondary100),
            ]) {
                HStack(spacing: 0) {
                    timeInfo(time: "07:00", label: "Starts").frame(width: 54)
                    RoundedRectangle(cornerRadius: 20)
                        .fill(theme.colors.borderNeutral9_5)
                        .frame(width: 2, height: 49)
                        .padding(.horizontal, theme.spacing.xs)
                    timeInfo(time: "10:00", label: "Ends").frame(width: 56)
                }
            }
            VStack(spacing: 0) {
                Spacer()
                DSText("14", style: theme.typography.display1, color: theme.colors.textNeutral9)
                DSText("Aug 2030", style: theme.typography.smallRegular, color: theme.colors.textNeutral8)
            }
        }
        .frame(height: 244)
    }

    private func timeInfo(time: String, label: String) -> some View {
        VStack(spacing: 0) {
            DSText(time, style: theme.typography.h5, color: theme.colors.textNeutral9)
            DSText(label, style: theme.typography.smallRegular, color: theme.colors.textNeutral8)
        }
    }
}

#Preview {
    Alert5Page()
        .previewThemed()
}
