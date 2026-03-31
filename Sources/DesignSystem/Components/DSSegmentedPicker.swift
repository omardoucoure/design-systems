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

/// A themed segmented control with three style variants.
///
/// Usage:
/// ```swift
/// // Navigation Tabs style (default)
/// DSSegmentedPicker(items: ["Day", "Week", "Month"], selectedIndex: $index)
///
/// // Pills style with custom background
/// DSSegmentedPicker(items: ["All", "Active", "Done"], selectedIndex: $index)
///     .pickerStyle(.pills)
///     .containerBackground(.white)
/// ```
public struct DSSegmentedPicker: View {
    @Environment(\.theme) private var theme
    @Namespace private var segmentAnimation

    // Core (required)
    private let items: [LocalizedStringKey]
    @Binding private var selectedIndex: Int

    // Modifier-based (optional)
    private var _pickerStyle: DSSegmentedPickerStyle = .tabs
    private var _containerBackground: Color?

    // MARK: - Minimal Init

    public init(
        items: [LocalizedStringKey],
        selectedIndex: Binding<Int>
    ) {
        self.items = items
        self._selectedIndex = selectedIndex
    }

    // MARK: - Deprecated Init

    @available(*, deprecated, message: "Use .pickerStyle() and .containerBackground() modifiers instead")
    public init(
        items: [LocalizedStringKey],
        selectedIndex: Binding<Int>,
        style: DSSegmentedPickerStyle,
        containerBackground: Color? = nil
    ) {
        self.items = items
        self._selectedIndex = selectedIndex
        self._pickerStyle = style
        self._containerBackground = containerBackground
    }

    // MARK: - Modifiers

    /// Sets the visual style of the segmented picker.
    public func pickerStyle(_ style: DSSegmentedPickerStyle) -> Self {
        var copy = self
        copy._pickerStyle = style
        return copy
    }

    /// Overrides the container background color.
    public func containerBackground(_ color: Color?) -> Self {
        var copy = self
        copy._containerBackground = color
        return copy
    }

    public var body: some View {
        switch _pickerStyle {
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
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        selectedIndex = index
                    }
                } label: {
                    Text(items[index])
                        .font(theme.typography.label.font)
                        .tracking(theme.typography.label.tracking)
                        .foregroundStyle(
                            isSelected
                                ? theme.colors.textNeutral05
                                : theme.colors.textNeutral9
                        )
                        .frame(maxWidth: .infinity)
                        .frame(height: 32)
                        .background {
                            if isSelected {
                                Capsule()
                                    .fill(theme.colors.surfacePrimary120)
                                    .matchedGeometryEffect(id: "tabIndicator", in: segmentAnimation)
                            }
                        }
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(theme.spacing.xs)
        .background(_containerBackground ?? theme.colors.surfaceNeutral2)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.xl))
    }

    // MARK: - Pills Layout

    private var pillsLayout: some View {
        HStack(spacing: theme.spacing.xxs) {
            ForEach(items.indices, id: \.self) { index in
                let isSelected = index == selectedIndex

                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        selectedIndex = index
                    }
                } label: {
                    Text(items[index])
                        .font(theme.typography.label.font)
                        .tracking(theme.typography.label.tracking)
                        .foregroundStyle(
                            isSelected
                                ? theme.colors.textNeutral05
                                : theme.colors.textNeutral9
                        )
                        .frame(maxWidth: .infinity)
                        .frame(height: 32)
                        .padding(.horizontal, theme.spacing.sm)
                        .background {
                            if isSelected {
                                Capsule()
                                    .fill(theme.colors.surfacePrimary120)
                                    .matchedGeometryEffect(id: "pillIndicator", in: segmentAnimation)
                            }
                        }
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(theme.spacing.xs)
        .background(_containerBackground ?? theme.colors.surfaceNeutral2)
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
                                .fill(theme.colors.borderNeutral95)
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
                        .fill(theme.colors.borderNeutral95)
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
