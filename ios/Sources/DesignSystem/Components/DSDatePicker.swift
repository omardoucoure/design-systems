import SwiftUI

// MARK: - Date Picker Variant

public enum DSDatePickerVariant: Sendable {
    case single
    case range
}

// MARK: - DSDatePicker

/// A themed date picker with single and range selection modes.
///
/// Usage:
/// ```swift
/// DSDatePicker(startDate: $start, variant: .single)
/// DSDatePicker(startDate: $start, endDate: $end, variant: .range)
/// ```
public struct DSDatePicker: View {
    @Environment(\.theme) private var theme

    @Binding private var startDate: Date
    @Binding private var endDate: Date
    private let variant: DSDatePickerVariant
    private let title: LocalizedStringKey
    private let onCancel: (() -> Void)?
    private let onConfirm: (() -> Void)?

    @State private var startText: String = ""
    @State private var endText: String = ""

    private static let displayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MMM d, yyyy"
        return f
    }()

    public init(
        startDate: Binding<Date>,
        endDate: Binding<Date> = .constant(Date()),
        variant: DSDatePickerVariant = .single,
        title: LocalizedStringKey = "Select date",
        onCancel: (() -> Void)? = nil,
        onConfirm: (() -> Void)? = nil
    ) {
        self._startDate = startDate
        self._endDate = endDate
        self.variant = variant
        self.title = title
        self.onCancel = onCancel
        self.onConfirm = onConfirm
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            header
            dateInputs
            calendarView
            actionButtons
        }
        .padding(theme.spacing.md)
        .background(theme.colors.surfaceNeutral2)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))
        .onAppear {
            startText = Self.displayFormatter.string(from: startDate)
            endText = Self.displayFormatter.string(from: endDate)
        }
        .onChange(of: startDate) { newValue in
            startText = Self.displayFormatter.string(from: newValue)
        }
        .onChange(of: endDate) { newValue in
            endText = Self.displayFormatter.string(from: newValue)
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: theme.spacing.xxs) {
            Text(title)
                .font(theme.typography.caption.font)
                .tracking(theme.typography.caption.tracking)
                .foregroundStyle(theme.colors.textNeutral8)

            HStack {
                Text(Self.displayFormatter.string(from: startDate))
                    .font(theme.typography.h3.font)
                    .tracking(theme.typography.h3.tracking)
                    .foregroundStyle(theme.colors.textNeutral9)

                if variant == .range {
                    Text("–")
                        .font(theme.typography.h3.font)
                        .foregroundStyle(theme.colors.textNeutral3)
                    Text(Self.displayFormatter.string(from: endDate))
                        .font(theme.typography.h3.font)
                        .tracking(theme.typography.h3.tracking)
                        .foregroundStyle(theme.colors.textNeutral9)
                }

                Spacer()

                DSButton(variant: .icon, systemIcon: "calendar") {}
            }
        }
    }

    // MARK: - Date Inputs (using DSTextField)

    private var dateInputs: some View {
        HStack(spacing: theme.spacing.sm) {
            DSTextField(
                text: $startText,
                placeholder: "Start date",
                label: "Start",
                variant: .filled,
                state: .active,
                icon: .calendar, iconPosition: .leading
            )
            .disabled(true)

            if variant == .range {
                DSTextField(
                    text: $endText,
                    placeholder: "End date",
                    label: "End",
                    variant: .filled,
                    state: .active,
                    icon: .calendar, iconPosition: .leading
                )
                .disabled(true)
            }
        }
    }

    // MARK: - Calendar

    private var calendarView: some View {
        DatePicker(
            "",
            selection: $startDate,
            displayedComponents: .date
        )
        .datePickerStyle(.graphical)
        .tint(theme.colors.surfacePrimary100)
    }

    // MARK: - Actions

    private var actionButtons: some View {
        HStack {
            Spacer()

            DSButton("Cancel", variant: .ghost) {
                onCancel?()
            }

            DSButton("OK", variant: .primary) {
                onConfirm?()
            }
        }
    }
}
