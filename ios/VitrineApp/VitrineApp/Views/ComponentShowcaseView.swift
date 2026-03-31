import SwiftUI
import DesignSystem

// MARK: - Component Catalog

struct ComponentShowcaseView: View {
    @Environment(\.theme) private var theme

    var body: some View {
        List {
            Section("Actions") {
                NavigationLink("Buttons — Filled, outlined, text, icons") {
                    LazyView(ButtonDetailView())
                }

                NavigationLink("Chips & Badges — Tags, dots, counts") {
                    LazyView(ChipBadgeDetailView())
                }
            }

            Section("Selection") {
                NavigationLink("Checkbox, Radio & Toggle") {
                    LazyView(SelectionDetailView())
                }
            }

            Section("Forms") {
                NavigationLink("Text Fields — Filled, lined, search") {
                    LazyView(TextFieldDetailView())
                }

                NavigationLink("Dropdown, Text Area & Code Input") {
                    LazyView(FormExtrasDetailView())
                }

                NavigationLink("Date Picker — Single & range") {
                    LazyView(DatePickerDetailView())
                }
            }

            Section("Lists & Dividers") {
                NavigationLink("List Item & Divider") {
                    LazyView(ListDividerDetailView())
                }
            }

            Section("Navigation") {
                NavigationLink("App Bars — Top & bottom") {
                    LazyView(AppBarDetailView())
                }

                NavigationLink("Segmented Picker & Page Control") {
                    LazyView(PickerControlDetailView())
                }
            }

            Section("Feedback") {
                NavigationLink("Alert, Banner & Dialog") {
                    LazyView(FeedbackDetailView())
                }

                NavigationLink("Tooltip — Simple & rich") {
                    LazyView(TooltipDetailView())
                }
            }

            Section("Data Visualization") {
                NavigationLink("Charts — Bar, line, lollipop, stacked") {
                    LazyView(ChartsDetailView())
                }

                NavigationLink("Gauge & Progress — Circle, semi-circular") {
                    LazyView(GaugeProgressDetailView())
                }
            }

            Section("Calendar") {
                NavigationLink("Calendar, Day Picker & Timeline") {
                    LazyView(CalendarDetailView())
                }
            }

            Section("Layout") {
                NavigationLink("Cards — Standard & metric") {
                    LazyView(CardDetailView())
                }

                NavigationLink("Carousel & Deck") {
                    LazyView(CarouselDetailView())
                }
            }

            Section("Media & Typography") {
                NavigationLink("Avatar & Icon Image") {
                    LazyView(AvatarIconDetailView())
                }

                NavigationLink("Typography — All text styles") {
                    LazyView(TextDetailView())
                }
            }
        }
        .navigationTitle("Components")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Detail Views

private struct ButtonDetailView: View {
    @Environment(\.theme) private var theme

    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacing.lg) {
                DSButton("Filled A") {}.buttonStyle(.filledA).fullWidth()
                DSButton("Filled B") {}.fullWidth()
                DSButton("Filled C") {}.buttonStyle(.filledC).fullWidth()
                DSButton("Neutral") {}.buttonStyle(.neutral).fullWidth()
                DSButton("Outlined") {}.buttonStyle(.outlined).fullWidth()
                DSButton("Text") {}.buttonStyle(.text)

                DSDivider().dividerStyle(.subheader("Sizes"))

                HStack(spacing: theme.spacing.sm) {
                    DSButton("Small") {}.buttonStyle(.filledA).buttonSize(.small)
                    DSButton("Medium") {}.buttonStyle(.filledA).buttonSize(.medium)
                    DSButton("Big") {}.buttonStyle(.filledA)
                }

                DSDivider().dividerStyle(.subheader("With Icons"))

                HStack(spacing: theme.spacing.sm) {
                    DSButton("Left") {}.buttonStyle(.filledA).buttonSize(.medium).systemIcon("arrow.left", position: .left)
                    DSButton("Right") {}.buttonStyle(.filledA).buttonSize(.medium).systemIcon("arrow.right", position: .right)
                    DSButton {}.buttonStyle(.filledA).buttonSize(.medium).systemIcon("plus")
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
                DSDivider().dividerStyle(.subheader("Chips"))

                HStack(spacing: theme.spacing.xs) {
                    DSChip("Filled A").chipStyle(.filledA)
                    DSChip("Filled B").chipStyle(.filledB)
                    DSChip("Neutral").chipStyle(.neutral)
                }
                HStack(spacing: theme.spacing.xs) {
                    DSChip("Outlined").chipStyle(.outlined)
                    DSChip("Filled C").chipStyle(.filledC)
                }

                DSDivider().dividerStyle(.subheader("Badges"))

                HStack(spacing: theme.spacing.xl) {
                    DSBadge(.dot)
                    DSBadge(.numberBrand).count(3)
                    DSBadge(.numberSemantic).count(12)
                }
                HStack(spacing: theme.spacing.sm) {
                    DSBadge(.tagSemantic).text("Info")
                    DSBadge(.tagBrand).text("New")
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
                DSDivider().dividerStyle(.subheader("Checkbox"))
                DSCheckbox(isOn: $checkOn).label("Accept terms")
                DSCheckbox(isOn: .constant(false)).label("Unchecked")

                DSDivider().dividerStyle(.subheader("Radio"))
                DSRadio(isSelected: selected == 0) { selected = 0 }.label("Option A")
                DSRadio(isSelected: selected == 1) { selected = 1 }.label("Option B")
                DSRadio(isSelected: selected == 2) { selected = 2 }.label("Option C")

                DSDivider().dividerStyle(.subheader("Toggle"))
                DSToggle(isOn: $toggleOn).label("Dark mode")
                DSToggle(isOn: .constant(false)).label("Notifications")
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
                DSDivider().dividerStyle(.subheader("Text Field"))

                DSTextField(text: $text, placeholder: "Empty")
                DSTextField(text: .constant("Hello"), placeholder: "Filled")
                    .inputState(.filled)
                DSTextField(text: .constant("Error"), placeholder: "Error")
                    .inputState(.error)
                DSTextField(text: .constant("OK"), placeholder: "Validated")
                    .inputState(.validated)
                DSTextField(text: .constant("Lined"), placeholder: "Lined")
                    .variant(.lined)
                    .inputState(.filled)

                DSDivider().dividerStyle(.subheader("Search Field"))

                DSSearchField(text: .constant(""))
                    .placeholder("Search...")
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
                DSDivider().dividerStyle(.subheader("Dropdown"))

                DSDropdown(
                    items: [
                        DSDropdownItem(id: "s", label: "Small"),
                        DSDropdownItem(id: "m", label: "Medium"),
                        DSDropdownItem(id: "l", label: "Large"),
                    ],
                    selectedId: .constant("m")
                )
                .placeholder("Size")

                DSDivider().dividerStyle(.subheader("Text Area"))

                DSTextArea(text: $areaText)
                    .title("Notes")
                    .placeholder("Write something...")

                DSDivider().dividerStyle(.subheader("Code Input"))

                DSCodeInput(code: $code)
                    .digitCount(6)
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
                DSDivider().dividerStyle(.subheader("List Items"))

                DSListItem("Item Title") {
                    Image(systemName: "star.fill")
                        .foregroundStyle(theme.colors.surfaceSecondary100)
                } trailing: {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(theme.colors.textNeutral8)
                }
                .overline("Category")
                .metadata("3m ago")

                DSListItem("Simple row")

                DSDivider().dividerStyle(.subheader("Divider Styles"))

                DSDivider()
                DSDivider().dividerStyle(.inset)
                DSDivider().dividerStyle(.middle)
                DSDivider().dividerStyle(.subheader("Section Header"))
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
                    DSDivider().dividerStyle(.subheader("Top App Bar"))

                    DSTopAppBar(title: "Small").onBack {}

                    DSTopAppBar(title: "Centered") {
                        DSButton {}.buttonStyle(.text).buttonSize(.small).systemIcon("bell")
                    }.appBarStyle(.smallCentered).onBack {}

                    DSTopAppBar(title: "Medium").appBarStyle(.medium).onBack {}
                }
            }

            DSDivider().dividerStyle(.subheader("Bottom App Bar"))

            DSBottomAppBar(items: items, selectedId: $selected)
                .barStyle(.labeled)
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
                DSDivider().dividerStyle(.subheader("Segmented Picker"))
                DSSegmentedPicker(items: ["Day", "Week", "Month"], selectedIndex: $index)

                DSDivider().dividerStyle(.subheader("Page Control"))
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
                DSDivider().dividerStyle(.subheader("Alerts"))

                DSAlert(
                    title: "Something went wrong",
                    severity: .error
                ) {
                    EmptyView()
                } actions: {
                    DSButton("Retry") {}.buttonStyle(.filledA).buttonSize(.small)
                }
                .message("Please try again later.")

                DSAlert(
                    title: "Update available",
                    severity: .neutral
                ) {
                    EmptyView()
                } actions: {
                    DSButton("Update") {}.buttonSize(.small)
                }
                .message("A new version is ready.")

                DSDivider().dividerStyle(.subheader("Banners"))

                DSBanner(severity: .success).title("Success!").message("Operation completed.").onDismiss {}
                DSBanner(severity: .warning).title("Warning").message("Check your input.").onDismiss {}
                DSBanner(severity: .error).title("Error").message("Something failed.").onDismiss {}
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
                DSTooltip(style: .simple("Top tooltip")).tooltipDirection(.top)
                DSTooltip(style: .simple("Bottom tooltip")).tooltipDirection(.bottom)
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
                DSDivider().dividerStyle(.subheader("Line Chart"))

                DSLineChart(points: [
                    .init(x: 0, y: 0.3), .init(x: 0.25, y: 0.7),
                    .init(x: 0.5, y: 0.4), .init(x: 0.75, y: 0.8), .init(x: 1, y: 0.5),
                ])
                .lineColor(theme.colors.surfacePrimary100)
                .shadowColor(theme.colors.surfacePrimary100.opacity(0.3))
                .frame(height: 160)

                DSDivider().dividerStyle(.subheader("Lollipop Chart"))

                DSLollipopChart(data: [
                    .init(label: "Jan", height: 20), .init(label: "Feb", height: 35),
                    .init(label: "Mar", height: 55), .init(label: "Apr", height: 40),
                    .init(label: "May", height: 25), .init(label: "Jun", height: 60),
                ])
                .highlightIndex(2)
                .highlightLabel("$55")
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
                DSDivider().dividerStyle(.subheader("Progress Circle"))

                HStack(spacing: theme.spacing.xl) {
                    DSProgressCircle(progress: 0.25).circleSize(80)
                    DSProgressCircle(progress: 0.6).circleSize(80)
                    DSProgressCircle(progress: 1.0).circleSize(80)
                }

                DSDivider().dividerStyle(.subheader("Semi-Circular Gauge"))

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
                DSDivider().dividerStyle(.subheader("Date Picker"))

                DSDatePicker(startDate: $date)

                DSDivider().dividerStyle(.subheader("Day Picker"))

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
                DSDivider().dividerStyle(.subheader("Cards"))

                DSCard {
                    DSText("Neutral card", style: theme.typography.bodyRegular, color: theme.colors.textNeutral9)
                }

                DSCard {
                    DSText("Primary card", style: theme.typography.bodyRegular, color: theme.colors.textNeutral05)
                }
                .cardBackground(theme.colors.surfacePrimary100)

                DSDivider().dividerStyle(.subheader("Metric Cards"))

                DSMetricCard(title: "Walk", icon: .walking)
                    .metricValue("6,560", unit: "steps")
                    .metricBackground(theme.colors.surfacePrimary100)
                    .metricForeground(theme.colors.textNeutral05)

                DSMetricCard(title: "Calories", icon: .fireFlame)
                    .metricValue("1,248", unit: "kcal")
                    .metricBackground(theme.colors.surfaceSecondary100)
                    .metricForeground(theme.colors.textNeutral05)
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
                DSDivider().dividerStyle(.subheader("Avatars"))

                HStack(spacing: theme.spacing.lg) {
                    DSAvatar(style: .monogram("H")).avatarSize(56)
                    DSAvatar(style: .monogram("AB")).avatarSize(56)
                    DSAvatar(style: .icon("star.fill")).avatarSize(56)
                }

                HStack(spacing: theme.spacing.lg) {
                    DSAvatar(style: .monogram("S")).avatarSize(32)
                    DSAvatar(style: .monogram("M")).avatarSize(48)
                    DSAvatar(style: .monogram("L")).avatarSize(64)
                }

                DSDivider().dividerStyle(.subheader("Icon Images"))

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
