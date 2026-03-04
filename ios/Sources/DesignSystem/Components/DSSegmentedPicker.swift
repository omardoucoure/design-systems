import SwiftUI

// MARK: - DSSegmentedPickerStyle

public enum DSSegmentedPickerStyle: Sendable {
    /// Full-width tabs in a capsule container. (Figma: Segmented Picker)
    case tabs
    /// Compact pill buttons with darker selected state. (Figma: Pills)
    case pills
    /// Underline tabs with bottom border indicator. (Figma: Nav - Tab)
    case underline
}

// MARK: - DSSegmentedPicker

/// A themed segmented control with two style variants.
///
/// Usage:
/// ```swift
/// // Navigation Tabs style (default)
/// DSSegmentedPicker(items: ["Day", "Week", "Month"], selectedIndex: $index)
///
/// // Pills style
/// DSSegmentedPicker(items: ["All", "Active", "Done"], selectedIndex: $index, style: .pills)
/// ```
public struct DSSegmentedPicker: View {
    @Environment(\.theme) private var theme

    private let items: [LocalizedStringKey]
    @Binding private var selectedIndex: Int
    private let style: DSSegmentedPickerStyle

    public init(
        items: [LocalizedStringKey],
        selectedIndex: Binding<Int>,
        style: DSSegmentedPickerStyle = .tabs
    ) {
        self.items = items
        self._selectedIndex = selectedIndex
        self.style = style
    }

    public var body: some View {
        switch style {
        case .tabs:
            tabsLayout
        case .pills:
            pillsLayout
        case .underline:
            underlineLayout
        }
    }

    // MARK: - Tabs Layout

    private var tabsLayout: some View {
        HStack(spacing: theme.spacing.xxs) {
            ForEach(items.indices, id: \.self) { index in
                let isSelected = index == selectedIndex

                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedIndex = index
                    }
                } label: {
                    Text(items[index])
                        .font(theme.typography.label.font)
                        .tracking(theme.typography.label.tracking)
                        .foregroundStyle(
                            isSelected
                                ? theme.colors.textNeutral0_5
                                : theme.colors.textNeutral9
                        )
                        .frame(maxWidth: .infinity)
                        .frame(height: 32)
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
        .padding(theme.spacing.xs)
        .background(theme.colors.surfaceNeutral0_5)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))
    }

    // MARK: - Pills Layout

    private var pillsLayout: some View {
        HStack(spacing: theme.spacing.xxs) {
            ForEach(items.indices, id: \.self) { index in
                let isSelected = index == selectedIndex

                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedIndex = index
                    }
                } label: {
                    Text(items[index])
                        .font(theme.typography.label.font)
                        .tracking(theme.typography.label.tracking)
                        .foregroundStyle(
                            isSelected
                                ? theme.colors.textNeutral0_5
                                : theme.colors.textNeutral9
                        )
                        .frame(maxWidth: .infinity)
                        .frame(height: 32)
                        .padding(.horizontal, theme.spacing.sm)
                        .background(
                            isSelected
                                ? theme.colors.surfacePrimary120
                                : theme.colors.surfaceNeutral2
                        )
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(theme.spacing.xs)
        .background(theme.colors.surfaceNeutral2)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))
    }
    // MARK: - Underline Layout

    private var underlineLayout: some View {
        HStack(spacing: 0) {
            ForEach(items.indices, id: \.self) { index in
                let isSelected = index == selectedIndex

                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedIndex = index
                    }
                } label: {
                    Text(items[index])
                        .font(theme.typography.label.font)
                        .tracking(theme.typography.label.tracking)
                        .foregroundStyle(theme.colors.textNeutral9)
                        .opacity(isSelected ? 1.0 : 0.5)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .overlay(alignment: .bottom) {
                            Rectangle()
                                .fill(theme.colors.borderNeutral9_5)
                                .frame(height: isSelected ? theme.borders.widthMd : theme.borders.widthSm)
                        }
                }
                .buttonStyle(.plain)
            }
        }
    }
}

// MARK: - DSPageControl

/// A themed page control indicator (dots).
///
/// Usage:
/// ```swift
/// DSPageControl(count: 5, currentIndex: $page)
/// ```
public struct DSPageControl: View {
    @Environment(\.theme) private var theme

    private let count: Int
    @Binding private var currentIndex: Int

    public init(count: Int, currentIndex: Binding<Int>) {
        self.count = count
        self._currentIndex = currentIndex
    }

    public var body: some View {
        HStack(spacing: theme.spacing.xs) {
            ForEach(0..<count, id: \.self) { index in
                if index == currentIndex {
                    Capsule()
                        .fill(theme.colors.surfacePrimary120)
                        .frame(width: 32, height: 8)
                } else {
                    Circle()
                        .fill(theme.colors.borderNeutral9_5)
                        .frame(width: 8, height: 8)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                currentIndex = index
                            }
                        }
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: currentIndex)
    }
}
