// figma-node: 87:99691
import SwiftUI

public struct DSDateRangeBar: View {
    @Environment(\.theme) private var theme

    private let _startOverline: LocalizedStringKey
    private let _startDate: LocalizedStringKey
    private let _endOverline: LocalizedStringKey
    private let _endDate: LocalizedStringKey

    public init(
        startOverline: LocalizedStringKey = "Starting",
        startDate: LocalizedStringKey,
        endOverline: LocalizedStringKey = "Until",
        endDate: LocalizedStringKey
    ) {
        self._startOverline = startOverline
        self._startDate = startDate
        self._endOverline = endOverline
        self._endDate = endDate
    }

    private var metrics: DateRangeBarComponentTokens { theme.components.dateRangeBar }

    public var body: some View {
        HStack(alignment: .top, spacing: theme.spacing.lg) {
            column(icon: .calendarMinus, overline: _startOverline, date: _startDate)

            Rectangle()
                .fill(theme.colors.borderNeutral05)
                .frame(width: metrics.dividerWidth)

            column(icon: .calendarPlus, overline: _endOverline, date: _endDate)
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding(.horizontal, theme.spacing.xl)
        .padding(.vertical, theme.spacing.lg)
        .background(theme.colors.surfacePrimary100)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.lg))
    }

    private func column(
        icon: DSIcon,
        overline: LocalizedStringKey,
        date: LocalizedStringKey
    ) -> some View {
        HStack(alignment: .top, spacing: theme.spacing.sm) {
            Image(dsIcon: icon)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: metrics.iconSize, height: metrics.iconSize)
                .foregroundStyle(theme.colors.textNeutral05)

            VStack(alignment: .leading, spacing: 0) {
                Text(overline)
                    .font(theme.typography.tiny.font)
                    .tracking(theme.typography.tiny.tracking)
                    .foregroundStyle(theme.colors.textNeutral05)

                Text(date)
                    .font(theme.typography.body.font)
                    .tracking(theme.typography.body.tracking)
                    .foregroundStyle(theme.colors.textNeutral05)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
