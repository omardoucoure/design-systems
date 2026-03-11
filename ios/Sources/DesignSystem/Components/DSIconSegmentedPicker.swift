import SwiftUI

// MARK: - DSIconSegmentedPickerItem

/// A single segment item for `DSIconSegmentedPicker`.
public struct DSIconSegmentedPickerItem: Identifiable {
    public let id: Int
    public let label: LocalizedStringKey?
    public let icon: DSIcon

    /// Icon-only segment.
    public init(id: Int, icon: DSIcon) {
        self.id = id
        self.label = nil
        self.icon = icon
    }

    /// Label + icon segment.
    public init(id: Int, label: LocalizedStringKey, icon: DSIcon) {
        self.id = id
        self.label = label
        self.icon = icon
    }
}

// MARK: - DSIconSegmentedPicker

/// A compact segmented picker with icon-only and label+icon segments.
///
/// Figma: "Segmented Picker" used in shopping gender selection.
///
/// Usage:
/// ```swift
/// DSIconSegmentedPicker(
///     items: [
///         DSIconSegmentedPickerItem(id: 0, icon: .female),
///         DSIconSegmentedPickerItem(id: 1, label: "Him", icon: .male)
///     ],
///     selectedId: $selectedGender
/// )
/// ```
public struct DSIconSegmentedPicker: View {
    @Environment(\.theme) private var theme

    private let items: [DSIconSegmentedPickerItem]
    @Binding private var selectedId: Int
    private let width: CGFloat

    public init(
        items: [DSIconSegmentedPickerItem],
        selectedId: Binding<Int>,
        width: CGFloat = 145
    ) {
        self.items = items
        self._selectedId = selectedId
        self.width = width
    }

    public var body: some View {
        HStack(spacing: theme.spacing.xxs) {
            ForEach(items) { item in
                segmentButton(item)
            }
        }
        .padding(theme.spacing.xs)
        .background(theme.colors.surfaceNeutral2)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))
        .frame(width: width)
    }

    private func segmentButton(_ item: DSIconSegmentedPickerItem) -> some View {
        let isSelected = item.id == selectedId

        return Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                selectedId = item.id
            }
        } label: {
            HStack(spacing: theme.spacing.xs) {
                if let label = item.label {
                    Text(label)
                        .font(theme.typography.label.font)
                        .tracking(theme.typography.label.tracking)
                }

                Image(dsIcon: item.icon)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            .foregroundStyle(
                isSelected
                    ? theme.colors.textNeutral0_5
                    : theme.colors.textNeutral9
            )
            .padding(.horizontal, theme.spacing.sm)
            .padding(.vertical, theme.spacing.xxs)
            .frame(height: 32)
            .frame(maxWidth: item.label != nil ? .infinity : nil)
            .background(
                isSelected
                    ? theme.colors.surfacePrimary120
                    : Color.clear
            )
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
