import SwiftUI

// MARK: - Date Picker Variant

public enum DSDatePickerVariant: Sendable {
    case single
    case range
}

// MARK: - DSDatePicker

/// A themed date picker with single and range selection modes.
///
/// Usage (modifier-based):
/// ```swift
/// DSDatePicker(startDate: $start)
///
/// DSDatePicker(startDate: $start)
///     .endDate($end)
///     .variant(.range)
///     .title("Pick a range")
///     .onCancel { dismiss() }
///     .onConfirm { save() }
/// ```
public struct DSDatePicker: View {
    @Environment(\.theme) private var theme

    // MARK: - Stored properties

    private var _startDate: Binding<Date>
    private var _endDate: Binding<Date>
    private var _variant: DSDatePickerVariant
    private var _title: LocalizedStringKey
    private var _onCancel: (() -> Void)?
    private var _onConfirm: (() -> Void)?

    @State private var startText: String = ""
    @State private var endText: String = ""

    private static let displayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MMM d, yyyy"
        return f
    }()

    // MARK: - Minimal init

    public init(startDate: Binding<Date>) {
        self._startDate = startDate
        self._endDate = .constant(Date())
        self._variant = .single
        self._title = "Select date"
        self._onCancel = nil
        self._onConfirm = nil
    }

    // MARK: - Deprecated init (old param-heavy API)

    @available(*, deprecated, message: "Use DSDatePicker(startDate:) with modifier methods instead")
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
        self._variant = variant
        self._title = title
        self._onCancel = onCancel
        self._onConfirm = onConfirm
    }

    // MARK: - Modifiers

    public func endDate(_ binding: Binding<Date>) -> DSDatePicker {
        var copy = self
        copy._endDate = binding
        return copy
    }

    public func variant(_ variant: DSDatePickerVariant) -> DSDatePicker {
        var copy = self
        copy._variant = variant
        return copy
    }

    public func title(_ title: LocalizedStringKey) -> DSDatePicker {
        var copy = self
        copy._title = title
        return copy
    }

    public func onCancel(_ action: @escaping () -> Void) -> DSDatePicker {
        var copy = self
        copy._onCancel = action
        return copy
    }

    public func onConfirm(_ action: @escaping () -> Void) -> DSDatePicker {
        var copy = self
        copy._onConfirm = action
        return copy
    }

    // MARK: - Body

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
            startText = Self.displayFormatter.string(from: _startDate.wrappedValue)
            endText = Self.displayFormatter.string(from: _endDate.wrappedValue)
        }
        .onChange(of: _startDate.wrappedValue) { newValue in
            startText = Self.displayFormatter.string(from: newValue)
        }
        .onChange(of: _endDate.wrappedValue) { newValue in
            endText = Self.displayFormatter.string(from: newValue)
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: theme.spacing.xxs) {
            Text(_title)
                .font(theme.typography.caption.font)
                .tracking(theme.typography.caption.tracking)
                .foregroundStyle(theme.colors.textNeutral8)

            HStack {
                Text(Self.displayFormatter.string(from: _startDate.wrappedValue))
                    .font(theme.typography.h3.font)
                    .tracking(theme.typography.h3.tracking)
                    .foregroundStyle(theme.colors.textNeutral9)

                if _variant == .range {
                    Text("–")
                        .font(theme.typography.h3.font)
                        .foregroundStyle(theme.colors.textNeutral3)
                    Text(Self.displayFormatter.string(from: _endDate.wrappedValue))
                        .font(theme.typography.h3.font)
                        .tracking(theme.typography.h3.tracking)
                        .foregroundStyle(theme.colors.textNeutral9)
                }

                Spacer()

                DSButton {}.buttonStyle(.neutral).systemIcon("calendar")
            }
        }
    }

    // MARK: - Date Inputs (using DSTextField)

    private var dateInputs: some View {
        HStack(spacing: theme.spacing.sm) {
            DSTextField(text: Binding(
                get: { startText },
                set: { startText = $0 }
            ), placeholder: "Start date")
                .label("Start")
                .inputState(.active)
                .icon(.calendar, position: .leading)
                .disabled(true)

            if _variant == .range {
                DSTextField(text: Binding(
                    get: { endText },
                    set: { endText = $0 }
                ), placeholder: "End date")
                    .label("End")
                    .inputState(.active)
                    .icon(.calendar, position: .leading)
                    .disabled(true)
            }
        }
    }

    // MARK: - Calendar

    private var calendarView: some View {
        DatePicker(
            "",
            selection: _startDate,
            displayedComponents: .date
        )
        .datePickerStyle(.graphical)
        .tint(theme.colors.surfacePrimary100)
    }

    // MARK: - Actions

    private var actionButtons: some View {
        HStack {
            Spacer()

            DSButton("Cancel") {
                _onCancel?()
            }.buttonStyle(.text)

            DSButton("OK") {
                _onConfirm?()
            }.buttonStyle(.filledC)
        }
    }
}
