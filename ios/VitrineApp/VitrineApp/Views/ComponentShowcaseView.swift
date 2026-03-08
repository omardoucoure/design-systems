import SwiftUI
import DesignSystem

// MARK: - Component Catalog

struct ComponentShowcaseView: View {
    @Environment(\.theme) private var theme

    var body: some View {
        List {
            Section("Actions") {
                NavigationLink("Buttons — Filled, outlined, text, icons") {
                    ButtonDetailView()
                }

                NavigationLink("Chips & Badges — Tags, dots, counts") {
                    ChipBadgeDetailView()
                }
            }

            Section("Selection") {
                NavigationLink("Checkbox, Radio & Toggle") {
                    SelectionDetailView()
                }
            }

            Section("Forms") {
                NavigationLink("Text Fields — Filled, lined, search") {
                    TextFieldDetailView()
                }

                NavigationLink("Dropdown, Text Area & Code Input") {
                    FormExtrasDetailView()
                }

                NavigationLink("Date Picker — Single & range") {
                    DatePickerDetailView()
                }
            }

            Section("Lists & Dividers") {
                NavigationLink("List Item & Divider") {
                    ListDividerDetailView()
                }
            }

            Section("Navigation") {
                NavigationLink("App Bars — Top & bottom") {
                    AppBarDetailView()
                }

                NavigationLink("Segmented Picker & Page Control") {
                    PickerControlDetailView()
                }
            }

            Section("Feedback") {
                NavigationLink("Alert, Banner & Dialog") {
                    FeedbackDetailView()
                }

                NavigationLink("Tooltip — Simple & rich") {
                    TooltipDetailView()
                }
            }

            Section("Data Visualization") {
                NavigationLink("Charts — Bar, line, lollipop, stacked") {
                    ChartsDetailView()
                }

                NavigationLink("Gauge & Progress — Circle, semi-circular") {
                    GaugeProgressDetailView()
                }
            }

            Section("Calendar") {
                NavigationLink("Calendar, Day Picker & Timeline") {
                    CalendarDetailView()
                }
            }

            Section("Layout") {
                NavigationLink("Cards — Standard & metric") {
                    CardDetailView()
                }

                NavigationLink("Carousel & Deck") {
                    CarouselDetailView()
                }
            }

            Section("Media & Typography") {
                NavigationLink("Avatar & Icon Image") {
                    AvatarIconDetailView()
                }

                NavigationLink("Typography — All text styles") {
                    TextDetailView()
                }
            }
        }
        .navigationTitle("Components")
    }
}

// MARK: - Detail Views

private struct ButtonDetailView: View {
    @Environment(\.theme) private var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacing.lg) {
                DSButton("Filled A", style: .filledA, size: .big, isFullWidth: true) {}
                DSButton("Filled B", style: .filledB, size: .big, isFullWidth: true) {}
                DSButton("Filled C", style: .filledC, size: .big, isFullWidth: true) {}
                DSButton("Neutral", style: .neutral, size: .big, isFullWidth: true) {}
                DSButton("Outlined", style: .outlined, size: .big, isFullWidth: true) {}
                DSButton("Text", style: .text, size: .big) {}

                DSDivider(style: .subheader("Sizes"))

                HStack(spacing: theme.spacing.sm) {
                    DSButton("Small", style: .filledA, size: .small) {}
                    DSButton("Medium", style: .filledA, size: .medium) {}
                    DSButton("Big", style: .filledA, size: .big) {}
                }

                DSDivider(style: .subheader("With Icons"))

                HStack(spacing: theme.spacing.sm) {
                    DSButton("Left", style: .filledA, size: .medium, iconLeft: "arrow.left") {}
                    DSButton("Right", style: .filledA, size: .medium, iconRight: "arrow.right") {}
                    DSButton(style: .filledA, size: .medium, systemIcon: "plus") {}
                }
            }
            .padding(theme.spacing.lg)
        }
        .navigationTitle("Buttons")
    }
}

private struct ChipBadgeDetailView: View {
    @Environment(\.theme) private var theme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: theme.spacing.xl) {
                DSDivider(style: .subheader("Chips"))

                HStack(spacing: theme.spacing.xs) {
                    DSChip("Filled A", style: .filledA)
                    DSChip("Filled B", style: .filledB)
                    DSChip("Neutral", style: .neutral)
                }
                HStack(spacing: theme.spacing.xs) {
                    DSChip("Outlined", style: .outlined)
                    DSChip("Filled C", style: .filledC)
                }

                DSDivider(style: .subheader("Badges"))

                HStack(spacing: theme.spacing.xl) {
                    DSBadge(variant: .dot)
                    DSBadge(variant: .numberBrand, count: 3)
                    DSBadge(variant: .numberSemantic, count: 12)
                }
                HStack(spacing: theme.spacing.sm) {
                    DSBadge(variant: .tagSemantic, text: "Info")
                    DSBadge(variant: .tagBrand, text: "New")
                }
            }
            .padding(theme.spacing.lg)
        }
        .navigationTitle("Chips & Badges")
    }
}

private struct SelectionDetailView: View {
    @State private var checkOn = true
    @State private var selected = 0
    @State private var toggleOn = true

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                DSDivider(style: .subheader("Checkbox"))
                DSCheckbox(isOn: $checkOn, label: "Accept terms")
                DSCheckbox(isOn: .constant(false), label: "Unchecked")

                DSDivider(style: .subheader("Radio"))
                DSRadio(isSelected: selected == 0, label: "Option A") { selected = 0 }
                DSRadio(isSelected: selected == 1, label: "Option B") { selected = 1 }
                DSRadio(isSelected: selected == 2, label: "Option C") { selected = 2 }

                DSDivider(style: .subheader("Toggle"))
                DSToggle(isOn: $toggleOn, label: "Dark mode")
                DSToggle(isOn: .constant(false), label: "Notifications")
            }
            .padding(24)
        }
        .navigationTitle("Selection Controls")
    }
}

private struct TextFieldDetailView: View {
    @State private var text = ""
    @Environment(\.theme) private var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacing.lg) {
                DSDivider(style: .subheader("Text Field"))

                DSTextField(text: $text, placeholder: "Empty", variant: .filled, state: .empty)
                DSTextField(text: .constant("Hello"), placeholder: "Filled", variant: .filled, state: .filled)
                DSTextField(text: .constant("Error"), placeholder: "Error", variant: .filled, state: .error)
                DSTextField(text: .constant("OK"), placeholder: "Validated", variant: .filled, state: .validated)
                DSTextField(text: .constant("Lined"), placeholder: "Lined", variant: .lined, state: .filled)

                DSDivider(style: .subheader("Search Field"))

                DSSearchField(text: .constant(""), placeholder: "Search...")
            }
            .padding(theme.spacing.lg)
        }
        .navigationTitle("Text Fields")
    }
}

private struct FormExtrasDetailView: View {
    @State private var areaText = ""
    @State private var code = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                DSDivider(style: .subheader("Dropdown"))

                DSDropdown(
                    items: [
                        DSDropdownItem(id: "s", label: "Small"),
                        DSDropdownItem(id: "m", label: "Medium"),
                        DSDropdownItem(id: "l", label: "Large"),
                    ],
                    selectedId: .constant("m"),
                    placeholder: "Size"
                )

                DSDivider(style: .subheader("Text Area"))

                DSTextArea(text: $areaText, title: "Notes", placeholder: "Write something...")

                DSDivider(style: .subheader("Code Input"))

                DSCodeInput(code: $code, digitCount: 6)
            }
            .padding(24)
        }
        .navigationTitle("Dropdown, Area & Code")
    }
}

private struct DatePickerDetailView: View {
    @State private var date = Date()

    var body: some View {
        ScrollView {
            DSDatePicker(startDate: $date)
                .padding(24)
        }
        .navigationTitle("Date Picker")
    }
}

private struct ListDividerDetailView: View {
    @Environment(\.theme) private var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacing.xl) {
                DSDivider(style: .subheader("List Items"))

                DSListItem(overline: "Category", headline: "Item Title", metadata: "3m ago") {
                    Image(systemName: "star.fill")
                        .foregroundStyle(theme.colors.surfaceSecondary100)
                } trailing: {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(theme.colors.textNeutral8)
                }

                DSListItem(headline: "Simple row") {
                    EmptyView()
                } trailing: {
                    EmptyView()
                }

                DSDivider(style: .subheader("Divider Styles"))

                DSDivider(style: .fullBleed)
                DSDivider(style: .inset)
                DSDivider(style: .middle)
                DSDivider(style: .subheader("Section Header"))
            }
            .padding(theme.spacing.lg)
        }
        .navigationTitle("Lists & Dividers")
    }
}

private struct AppBarDetailView: View {
    @Environment(\.theme) private var theme
    @State private var selected = "home"

    private let items = [
        DSBottomBarItem(id: "home", label: "Home", systemIcon: "house"),
        DSBottomBarItem(id: "search", label: "Search", systemIcon: "magnifyingglass"),
        DSBottomBarItem(id: "profile", label: "Profile", systemIcon: "person"),
    ]

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: theme.spacing.xl) {
                    DSDivider(style: .subheader("Top App Bar"))

                    DSTopAppBar(title: "Small", style: .small, onBack: {}) {
                        EmptyView()
                    }

                    DSTopAppBar(title: "Centered", style: .smallCentered, onBack: {}) {
                        DSButton(style: .text, size: .small, systemIcon: "bell") {}
                    }

                    DSTopAppBar(title: "Medium", style: .medium, onBack: {}) {
                        EmptyView()
                    }
                }
            }

            DSDivider(style: .subheader("Bottom App Bar"))

            DSBottomAppBar(items: items, selectedId: $selected, style: .labeled)
        }
        .navigationTitle("App Bars")
    }
}

private struct PickerControlDetailView: View {
    @State private var index = 0
    @State private var current = 2

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                DSDivider(style: .subheader("Segmented Picker"))
                DSSegmentedPicker(items: ["Day", "Week", "Month"], selectedIndex: $index)

                DSDivider(style: .subheader("Page Control"))
                DSPageControl(count: 5, currentIndex: $current)
            }
            .padding(24)
        }
        .navigationTitle("Picker & Page Control")
    }
}

private struct FeedbackDetailView: View {
    @Environment(\.theme) private var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacing.lg) {
                DSDivider(style: .subheader("Alerts"))

                DSAlert(
                    title: "Something went wrong",
                    message: "Please try again later.",
                    severity: .error
                ) {
                    EmptyView()
                } actions: {
                    DSButton("Retry", style: .filledA, size: .small) {}
                }

                DSAlert(
                    title: "Update available",
                    message: "A new version is ready.",
                    severity: .neutral
                ) {
                    EmptyView()
                } actions: {
                    DSButton("Update", style: .filledB, size: .small) {}
                }

                DSDivider(style: .subheader("Banners"))

                DSBanner(title: "Success!", message: "Operation completed.", severity: .success, onDismiss: {})
                DSBanner(title: "Warning", message: "Check your input.", severity: .warning, onDismiss: {})
                DSBanner(title: "Error", message: "Something failed.", severity: .error, onDismiss: {})
            }
            .padding(theme.spacing.lg)
        }
        .navigationTitle("Alerts & Banners")
    }
}

private struct TooltipDetailView: View {
    @Environment(\.theme) private var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacing.xl) {
                DSTooltip(style: .simple("Top tooltip"), direction: .top)
                DSTooltip(style: .simple("Bottom tooltip"), direction: .bottom)
            }
            .padding(theme.spacing.lg)
        }
        .navigationTitle("Tooltip")
    }
}

private struct ChartsDetailView: View {
    @Environment(\.theme) private var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacing.xl) {
                DSDivider(style: .subheader("Line Chart"))

                DSLineChart(
                    points: [
                        .init(x: 0, y: 0.3), .init(x: 0.25, y: 0.7),
                        .init(x: 0.5, y: 0.4), .init(x: 0.75, y: 0.8), .init(x: 1, y: 0.5),
                    ],
                    lineColor: theme.colors.surfacePrimary100,
                    shadowColor: theme.colors.surfacePrimary100.opacity(0.3)
                )
                .frame(height: 160)

                DSDivider(style: .subheader("Lollipop Chart"))

                DSLollipopChart(
                    data: [
                        .init(label: "Jan", height: 20), .init(label: "Feb", height: 35),
                        .init(label: "Mar", height: 55), .init(label: "Apr", height: 40),
                        .init(label: "May", height: 25), .init(label: "Jun", height: 60),
                    ],
                    highlightIndex: 2,
                    highlightLabel: "$55"
                )
                .frame(height: 160)
            }
            .padding(theme.spacing.lg)
        }
        .navigationTitle("Charts")
    }
}

private struct GaugeProgressDetailView: View {
    @Environment(\.theme) private var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacing.xl) {
                DSDivider(style: .subheader("Progress Circle"))

                HStack(spacing: theme.spacing.xl) {
                    DSProgressCircle(progress: 0.25, size: 80)
                    DSProgressCircle(progress: 0.6, size: 80)
                    DSProgressCircle(progress: 1.0, size: 80)
                }

                DSDivider(style: .subheader("Semi-Circular Gauge"))

                DSSemiCircularGauge(segments: [
                    .init(fraction: 0.6, color: theme.colors.textNeutral9),
                    .init(fraction: 0.2, color: theme.colors.surfaceSecondary100),
                    .init(fraction: 0.2, color: theme.colors.surfaceNeutral2),
                ]) {
                    EmptyView()
                }
                .frame(height: 160)
            }
            .padding(theme.spacing.lg)
        }
        .navigationTitle("Gauge & Progress")
    }
}

private struct CalendarDetailView: View {
    @State private var date = Date()
    @State private var selectedDay = "2"
    @Environment(\.theme) private var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacing.xl) {
                DSDivider(style: .subheader("Date Picker"))

                DSDatePicker(startDate: $date)

                DSDivider(style: .subheader("Day Picker"))

                DSDayPicker(
                    items: [
                        .init(id: "1", label: "Mon"),
                        .init(id: "2", label: "Tue"),
                        .init(id: "3", label: "Wed"),
                        .init(id: "4", label: "Thu"),
                        .init(id: "5", label: "Fri"),
                    ],
                    selectedId: $selectedDay
                )
            }
            .padding(theme.spacing.lg)
        }
        .navigationTitle("Calendar")
    }
}

private struct CardDetailView: View {
    @Environment(\.theme) private var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacing.lg) {
                DSDivider(style: .subheader("Cards"))

                DSCard(
                    background: theme.colors.surfaceNeutral2,
                    radius: theme.radius.xl,
                    padding: theme.spacing.xl
                ) {
                    DSText("Neutral card", style: theme.typography.bodyRegular, color: theme.colors.textNeutral9)
                }

                DSCard(
                    background: theme.colors.surfacePrimary100,
                    radius: theme.radius.xl,
                    padding: theme.spacing.xl
                ) {
                    DSText("Primary card", style: theme.typography.bodyRegular, color: theme.colors.textNeutral0_5)
                }

                DSDivider(style: .subheader("Metric Cards"))

                DSMetricCard(
                    title: "Walk",
                    icon: .walking,
                    value: "6,560",
                    unit: "steps",
                    background: theme.colors.surfacePrimary100,
                    foreground: theme.colors.textNeutral0_5
                )

                DSMetricCard(
                    title: "Calories",
                    icon: .fireFlame,
                    value: "1,248",
                    unit: "kcal",
                    background: theme.colors.surfaceSecondary100,
                    foreground: theme.colors.textNeutral0_5
                )
            }
            .padding(theme.spacing.lg)
        }
        .navigationTitle("Cards")
    }
}

private struct CarouselDetailView: View {
    @Environment(\.theme) private var theme

    var body: some View {
        ScrollView {
            DSText(
                "Horizontal image carousel with spotlight, standard, and deck styles",
                style: theme.typography.bodyRegular,
                color: theme.colors.textNeutral8
            )
            .padding(24)
        }
        .navigationTitle("Carousel & Deck")
    }
}

private struct AvatarIconDetailView: View {
    @Environment(\.theme) private var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacing.xl) {
                DSDivider(style: .subheader("Avatars"))

                HStack(spacing: theme.spacing.lg) {
                    DSAvatar(style: .monogram("H"), size: 56)
                    DSAvatar(style: .monogram("AB"), size: 56)
                    DSAvatar(style: .icon("star.fill"), size: 56)
                }

                HStack(spacing: theme.spacing.lg) {
                    DSAvatar(style: .monogram("S"), size: 32)
                    DSAvatar(style: .monogram("M"), size: 48)
                    DSAvatar(style: .monogram("L"), size: 64)
                }

                DSDivider(style: .subheader("Icon Images"))

                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 60))
                ], spacing: theme.spacing.lg) {
                    DSIconImage(.heart, size: 32, color: theme.colors.textNeutral9)
                    DSIconImage(.bellNotification, size: 32, color: theme.colors.textNeutral9)
                    DSIconImage(.camera, size: 32, color: theme.colors.textNeutral9)
                    DSIconImage(.home, size: 32, color: theme.colors.textNeutral9)
                    DSIconImage(.calendar, size: 32, color: theme.colors.textNeutral9)
                    DSIconImage(.user, size: 32, color: theme.colors.textNeutral9)
                    DSIconImage(.walking, size: 32, color: theme.colors.textNeutral9)
                    DSIconImage(.fireFlame, size: 32, color: theme.colors.textNeutral9)
                    DSIconImage(.server, size: 32, color: theme.colors.textNeutral9)
                    DSIconImage(.graphUp, size: 32, color: theme.colors.textNeutral9)
                    DSIconImage(.plus, size: 32, color: theme.colors.textNeutral9)
                    DSIconImage(.xmark, size: 32, color: theme.colors.textNeutral9)
                }
            }
            .padding(theme.spacing.lg)
        }
        .navigationTitle("Avatars & Icons")
    }
}

private struct TextDetailView: View {
    @Environment(\.theme) private var theme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                DSText("Display 1", style: theme.typography.display1, color: theme.colors.textNeutral9)
                DSText("Display 2", style: theme.typography.display2, color: theme.colors.textNeutral9)
                DSText("Heading 2", style: theme.typography.h2, color: theme.colors.textNeutral9)
                DSText("Heading 4", style: theme.typography.h4, color: theme.colors.textNeutral9)
                DSText("Heading 5", style: theme.typography.h5, color: theme.colors.textNeutral9)
                DSText("Heading 6", style: theme.typography.h6, color: theme.colors.textNeutral9)
                DSText("Body Semi Bold", style: theme.typography.bodySemiBold, color: theme.colors.textNeutral9)
                DSText("Body Medium", style: theme.typography.body, color: theme.colors.textNeutral9)
                DSText("Body Regular", style: theme.typography.bodyRegular, color: theme.colors.textNeutral9)
                DSText("Label", style: theme.typography.label, color: theme.colors.textNeutral9)
                DSText("Caption", style: theme.typography.caption, color: theme.colors.textNeutral9)
                DSText("Small", style: theme.typography.small, color: theme.colors.textNeutral9)
            }
            .padding(theme.spacing.lg)
        }
        .navigationTitle("Typography")
    }
}

#Preview {
    NavigationStack {
        ComponentShowcaseView()
    }
    .previewThemed()
}
