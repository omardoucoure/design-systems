import SwiftUI
import DesignSystem

// MARK: - Component Category

private enum ComponentCategory: String, CaseIterable, Identifiable {
    case buttons = "Buttons"
    case chips = "Chips, Tags & Badges"
    case selectionControls = "Selection Controls"
    case forms = "Forms & Inputs"
    case lists = "Lists"
    case navigation = "Navigation"
    case misc = "Avatars, Dividers & More"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .buttons: return "hand.tap"
        case .chips: return "tag"
        case .selectionControls: return "checkmark.circle"
        case .forms: return "text.cursor"
        case .lists: return "list.bullet"
        case .navigation: return "sidebar.left"
        case .misc: return "circle.grid.2x2"
        }
    }
}

// MARK: - Component Showcase

struct ComponentShowcaseView: View {
    @Environment(\.theme) private var theme

    var body: some View {
        List(ComponentCategory.allCases) { category in
            NavigationLink(value: category) {
                Label(category.rawValue, systemImage: category.icon)
                    .font(theme.typography.body.font)
                    .tracking(theme.typography.body.tracking)
                    .foregroundStyle(theme.colors.textNeutral9)
            }
            .listRowBackground(theme.colors.surfaceNeutral0_5)
        }
        .listStyle(.plain)
        .background(theme.colors.surfaceNeutral0_5)
        .navigationTitle("Components")
        .navigationDestination(for: ComponentCategory.self) { category in
            categoryDetailView(category)
        }
    }

    @ViewBuilder
    private func categoryDetailView(_ category: ComponentCategory) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                switch category {
                case .buttons: ButtonShowcase()
                case .chips: ChipsBadgesShowcase()
                case .selectionControls: SelectionControlsShowcase()
                case .forms: FormsShowcase()
                case .lists: ListShowcase()
                case .navigation: NavigationShowcase()
                case .misc: MiscShowcase()
                }
            }
            .padding()
        }
        .background(theme.colors.surfaceNeutral0_5)
        .navigationTitle(category.rawValue)
    }
}

// MARK: - Button Showcase

private struct ButtonShowcase: View {
    @Environment(\.theme) private var theme

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            sectionTitle("Filled A (Secondary)")
            HStack(spacing: 12) {
                DSButton("Big", style: .filledA, size: .big) {}
                DSButton("Med", style: .filledA, size: .medium) {}
                DSButton("Sm", style: .filledA, size: .small) {}
            }

            sectionTitle("Filled B (Primary)")
            HStack(spacing: 12) {
                DSButton("Big", style: .filledB, size: .big) {}
                DSButton("Med", style: .filledB, size: .medium) {}
                DSButton("Sm", style: .filledB, size: .small) {}
            }

            sectionTitle("Filled C (Primary 120)")
            HStack(spacing: 12) {
                DSButton("Big", style: .filledC, size: .big) {}
                DSButton("Med", style: .filledC, size: .medium) {}
                DSButton("Sm", style: .filledC, size: .small) {}
            }

            sectionTitle("Neutral")
            HStack(spacing: 12) {
                DSButton("Big", style: .neutral, size: .big) {}
                DSButton("Med", style: .neutral, size: .medium) {}
                DSButton("Sm", style: .neutral, size: .small) {}
            }

            sectionTitle("Outlined")
            HStack(spacing: 12) {
                DSButton("Big", style: .outlined, size: .big) {}
                DSButton("Med", style: .outlined, size: .medium) {}
                DSButton("Sm", style: .outlined, size: .small) {}
            }

            sectionTitle("Text")
            HStack(spacing: 12) {
                DSButton("Big", style: .text, size: .big) {}
                DSButton("Med", style: .text, size: .medium) {}
                DSButton("Sm", style: .text, size: .small) {}
            }

            sectionTitle("With Icons")
            DSButton("Continue", style: .filledB, size: .big, iconRight: "arrow.right") {}
            DSButton("Back", style: .outlined, size: .medium, iconLeft: "arrow.left") {}

            sectionTitle("Full Width")
            DSButton("Full Width Primary", style: .filledB, size: .big, isFullWidth: true) {}
            DSButton("Full Width Outlined", style: .outlined, size: .big, isFullWidth: true) {}

            sectionTitle("Disabled State")
            DSButton("Disabled", style: .filledB, size: .big) {}
                .disabled(true)
        }
    }

    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(theme.typography.label.font)
            .foregroundStyle(theme.colors.textNeutral8)
    }
}

// MARK: - Chips, Badges & Tags Showcase

private struct ChipsBadgesShowcase: View {
    @Environment(\.theme) private var theme

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            sectionTitle("Chips")
            FlowLayout(spacing: 8) {
                DSChip("Swift", style: .filledA)
                DSChip("iOS", style: .filledB)
                DSChip("SwiftUI", style: .filledC)
                DSChip("UIKit", style: .neutral)
                DSChip("Xcode", style: .outlined)
            }

            sectionTitle("Chips with dismiss")
            FlowLayout(spacing: 8) {
                DSChip("Removable", style: .filledA, onDismiss: {})
                DSChip("Removable", style: .filledB, onDismiss: {})
                DSChip("Removable", style: .neutral, onDismiss: {})
                DSChip("Removable", style: .outlined, onDismiss: {})
            }

            sectionTitle("Disabled Chips")
            FlowLayout(spacing: 8) {
                DSChip("Disabled", style: .filledA).disabled(true)
                DSChip("Disabled", style: .outlined).disabled(true)
            }

            sectionTitle("Badges")
            HStack(spacing: 24) {
                VStack(spacing: 4) {
                    DSBadge(variant: .dot)
                    Text("Dot").font(theme.typography.small.font)
                }
                VStack(spacing: 4) {
                    DSBadge(variant: .numberBrand, count: 9)
                    Text("Number").font(theme.typography.small.font)
                }
                VStack(spacing: 4) {
                    DSBadge(variant: .numberSemantic, count: 3)
                    Text("Semantic").font(theme.typography.small.font)
                }
            }
            .foregroundStyle(theme.colors.textNeutral9)

            sectionTitle("Tags")
            HStack(spacing: 12) {
                DSBadge(variant: .tagBrand, text: "Brand")
                DSBadge(variant: .tagSemantic, text: "Info")
            }
        }
    }

    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(theme.typography.label.font)
            .foregroundStyle(theme.colors.textNeutral8)
    }
}

// MARK: - Flow Layout (horizontal wrapping)

private struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = layout(in: proposal.width ?? 0, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(in: bounds.width, subviews: subviews)
        for (index, offset) in result.offsets.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + offset.x, y: bounds.minY + offset.y),
                proposal: .unspecified
            )
        }
    }

    private func layout(in width: CGFloat, subviews: Subviews) -> (size: CGSize, offsets: [CGPoint]) {
        var offsets: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var maxWidth: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > width, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            offsets.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
            maxWidth = max(maxWidth, x)
        }

        return (CGSize(width: maxWidth, height: y + rowHeight), offsets)
    }
}

// MARK: - Selection Controls Showcase

private struct SelectionControlsShowcase: View {
    @Environment(\.theme) private var theme

    @State private var check1 = true
    @State private var check2 = false
    @State private var radioOption = 0
    @State private var toggle1 = true
    @State private var toggle2 = false

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            sectionTitle("Checkboxes")
            DSCheckbox(isOn: $check1, label: "Accepted terms", description: "You agree to our terms and conditions")
            DSCheckbox(isOn: $check2, label: "Subscribe to newsletter")

            sectionTitle("Radio Buttons")
            DSRadio(isSelected: radioOption == 0, label: "Option A", description: "First option") { radioOption = 0 }
            DSRadio(isSelected: radioOption == 1, label: "Option B", description: "Second option") { radioOption = 1 }
            DSRadio(isSelected: radioOption == 2, label: "Option C") { radioOption = 2 }

            sectionTitle("Toggles")
            DSToggle(isOn: $toggle1, label: "Dark mode", description: "Switch between light and dark themes")
            DSToggle(isOn: $toggle2, label: "Notifications")
        }
    }

    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(theme.typography.label.font)
            .foregroundStyle(theme.colors.textNeutral8)
    }
}

// MARK: - Forms Showcase

private struct FormsShowcase: View {
    @Environment(\.theme) private var theme

    @State private var textEmpty = ""
    @State private var textFilled = "John Doe"
    @State private var textError = "bad@"
    @State private var searchText = ""
    @State private var textAreaText = ""
    @State private var dropdownSelection: String? = nil
    @State private var dateStart = Date()
    @State private var dateEnd = Date().addingTimeInterval(86400 * 7)

    private let dropdownItems = [
        DSDropdownItem(id: "1", label: "Option 1"),
        DSDropdownItem(id: "2", label: "Option 2"),
        DSDropdownItem(id: "3", label: "Option 3"),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            sectionTitle("Text Fields — Filled")
            DSTextField(text: $textEmpty, placeholder: "Empty state", variant: .filled, state: .empty, iconLeft: "person")
            DSTextField(text: $textFilled, placeholder: "Full name", label: "Name", variant: .filled, state: .filled, iconLeft: "person.fill")
            DSTextField(text: $textError, placeholder: "Email", label: "Email", helperText: "Invalid email format", variant: .filled, state: .error, iconLeft: "envelope")
            DSTextField(text: .constant("verified@email.com"), placeholder: "Email", label: "Email", variant: .filled, state: .validated, iconLeft: "envelope.fill", iconRight: "checkmark.circle.fill")

            sectionTitle("Text Fields — Lined")
            DSTextField(text: $textEmpty, placeholder: "Lined empty", variant: .lined, state: .empty)
            DSTextField(text: $textFilled, placeholder: "Lined filled", label: "Name", variant: .lined, state: .filled)

            sectionTitle("Search")
            DSSearchField(text: $searchText, placeholder: "Search components...")

            sectionTitle("Dropdown")
            DSDropdown(items: dropdownItems, selectedId: $dropdownSelection, placeholder: "Choose an option", label: "Selection")

            sectionTitle("Text Area")
            DSTextArea(text: $textAreaText, title: "Notes", placeholder: "Write your notes here...")

            sectionTitle("Date Picker — Single")
            DSDatePicker(startDate: $dateStart, variant: .single, title: "Select date")

            sectionTitle("Date Picker — Range")
            DSDatePicker(startDate: $dateStart, endDate: $dateEnd, variant: .range, title: "Select range")
        }
    }

    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(theme.typography.label.font)
            .foregroundStyle(theme.colors.textNeutral8)
    }
}

// MARK: - List Showcase

private struct ListShowcase: View {
    @Environment(\.theme) private var theme

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            sectionTitle("Minimal")
            DSListItem(headline: "Headline")

            sectionTitle("With Trailing Arrow")
            DSListItem(headline: "Headline", showTrailingArrow: true)

            sectionTitle("With Leading Icon")
            DSListItem(headline: "Headline", leadingIcon: "eye", showTrailingArrow: true)

            sectionTitle("With Metadata")
            DSListItem(headline: "Headline", metadata: "Label", showTrailingArrow: true)

            sectionTitle("With Supporting Text")
            DSListItem(
                headline: "Headline",
                supportingText: "Supporting Text",
                leadingIcon: "eye",
                showTrailingArrow: true
            )

            sectionTitle("With Overline")
            DSListItem(
                overline: "Overline",
                headline: "Headline",
                leadingIcon: "eye",
                metadata: "Label",
                showTrailingArrow: true
            )

            sectionTitle("Full (All Options)")
            DSListItem(
                overline: "Overline",
                headline: "Headline",
                supportingText: "Supporting Text",
                leadingIcon: "eye",
                metadata: "Label",
                showTrailingArrow: true,
                showDivider: true
            )

            sectionTitle("List Group with Dividers")
            VStack(spacing: 0) {
                DSListItem(headline: "Notifications", leadingIcon: "bell", showTrailingArrow: true, showDivider: true)
                DSListItem(headline: "Privacy", leadingIcon: "lock", showTrailingArrow: true, showDivider: true)
                DSListItem(headline: "Appearance", leadingIcon: "paintbrush", showTrailingArrow: true)
            }
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.md))

            // MARK: - Generic Leading/Trailing Content

            sectionTitle("Leading: Checkbox")
            DSListItem(headline: "Pickled Cucumber", showDivider: true, leading: {
                DSCheckbox(isOn: .constant(true))
            }, trailing: {
                EmptyView()
            })

            sectionTitle("Leading: Radio")
            DSListItem(headline: "Option A", leading: {
                DSRadio(isSelected: true) {}
            }, trailing: {
                EmptyView()
            })

            sectionTitle("Leading: Toggle")
            DSListItem(headline: "Dark Mode", leading: {
                DSToggle(isOn: .constant(true))
            }, trailing: {
                EmptyView()
            })

            sectionTitle("Leading: Avatar")
            DSListItem(headline: "John Doe", supportingText: "Online", leading: {
                DSAvatar(style: .monogram("J"))
            }, trailing: {
                Image(systemName: "arrow.right")
                    .font(.system(size: 20))
                    .foregroundStyle(theme.colors.textNeutral9)
                    .padding(8)
            })

            sectionTitle("Leading: Progress Circle")
            DSListItem(headline: "Uploading file...", supportingText: "3 of 10 items", leading: {
                DSProgressCircle(progress: 0.3)
            }, trailing: {
                EmptyView()
            })

            sectionTitle("Leading: Image")
            DSListItem(headline: "Mountain View", supportingText: "Landscape photo", leading: {
                RoundedRectangle(cornerRadius: theme.radius.sm)
                    .fill(theme.colors.surfaceSecondary100)
                    .frame(width: 56, height: 48)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundStyle(theme.colors.textNeutral0_5)
                    )
            }, trailing: {
                Image(systemName: "arrow.right")
                    .font(.system(size: 20))
                    .foregroundStyle(theme.colors.textNeutral9)
                    .padding(8)
            })

            sectionTitle("Leading: Video")
            DSListItem(headline: "Tutorial", supportingText: "12 min", leading: {
                RoundedRectangle(cornerRadius: theme.radius.sm)
                    .fill(theme.colors.surfacePrimary100)
                    .frame(width: 96, height: 56)
                    .overlay(
                        Image(systemName: "play.fill")
                            .foregroundStyle(theme.colors.textNeutral0_5)
                    )
            }, trailing: {
                EmptyView()
            })

            sectionTitle("Trailing: Button")
            DSListItem(headline: "Invite Friend", leading: {
                DSAvatar(style: .icon("person"))
            }, trailing: {
                DSButton("Follow", style: .filledA, size: .small) {}
            })

            sectionTitle("Full Combo: Avatar + Metadata + Arrow")
            DSListItem(
                overline: "Team Lead",
                headline: "Sarah Connor",
                supportingText: "Last active 2h ago",
                metadata: "Admin",
                leading: {
                    DSAvatar(style: .monogram("SC"))
                }, trailing: {
                    Image(systemName: "arrow.right")
                        .font(.system(size: 20))
                        .foregroundStyle(theme.colors.textNeutral9)
                        .padding(8)
                }
            )

            sectionTitle("Group: Checkbox List")
            VStack(spacing: 0) {
                DSListItem(headline: "Tomatoes", showDivider: true, leading: {
                    DSCheckbox(isOn: .constant(true))
                }, trailing: { EmptyView() })
                DSListItem(headline: "Lettuce", showDivider: true, leading: {
                    DSCheckbox(isOn: .constant(false))
                }, trailing: { EmptyView() })
                DSListItem(headline: "Cucumber", leading: {
                    DSCheckbox(isOn: .constant(true))
                }, trailing: { EmptyView() })
            }
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.md))
        }
    }

    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(theme.typography.label.font)
            .foregroundStyle(theme.colors.textNeutral8)
    }
}

// MARK: - Navigation Showcase

private struct NavigationShowcase: View {
    @Environment(\.theme) private var theme

    @State private var segmentIndex = 0
    @State private var pillsIndex = 1
    @State private var pageIndex = 0
    @State private var fullTab = "home"
    @State private var floatingTab = "home"
    @State private var labeledTab = "calendar"

    private let iconItems = [
        DSBottomBarItem(id: "home", label: "Home", systemIcon: "house"),
        DSBottomBarItem(id: "person", label: "Profile", systemIcon: "person"),
        DSBottomBarItem(id: "calendar", label: "Calendar", systemIcon: "calendar"),
        DSBottomBarItem(id: "bell", label: "Alerts", systemIcon: "bell"),
    ]

    private let labeledItems = [
        DSBottomBarItem(id: "home", label: "Home", systemIcon: "house", badgeCount: 12),
        DSBottomBarItem(id: "person", label: "Profile", systemIcon: "person", badgeCount: 9),
        DSBottomBarItem(id: "docs", label: "Docs", systemIcon: "doc.on.doc", badgeCount: 9),
        DSBottomBarItem(id: "calendar", label: "Calendar", systemIcon: "calendar", badgeCount: 9),
        DSBottomBarItem(id: "bell", label: "Alerts", systemIcon: "bell", badgeCount: 12),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            sectionTitle("Top App Bar — Small")
            DSTopAppBar(title: "Settings", style: .small, onBack: {}) {
                DSButton(style: .neutral, size: .medium, systemIcon: "bell") {}
            }
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.lg))

            sectionTitle("Top App Bar — Small Centered")
            DSTopAppBar(title: "Profile", style: .smallCentered, onBack: {}) {
                DSButton(style: .neutral, size: .medium, systemIcon: "person.circle") {}
            }
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.lg))

            sectionTitle("Top App Bar — Medium")
            DSTopAppBar(title: "Documents", style: .medium, onBack: {}) {
                DSButton(style: .neutral, size: .medium, systemIcon: "paperclip") {}
                DSButton(style: .neutral, size: .medium, systemIcon: "ellipsis") {}
            }
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.lg))

            sectionTitle("Top App Bar — Large")
            DSTopAppBar(title: "Explore", style: .large, onBack: {}) {
                DSButton(style: .neutral, size: .medium, systemIcon: "paperclip") {}
                DSButton(style: .neutral, size: .medium, systemIcon: "ellipsis") {}
            }
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.lg))

            sectionTitle("Top App Bar — Logo")
            DSTopAppBar(leadingIcon: "person.circle", onLeadingTap: {}) {
                HStack(spacing: 8) {
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(theme.colors.surfacePrimary100)
                    Text("haho")
                        .font(theme.typography.bodySemiBold.font)
                        .tracking(theme.typography.bodySemiBold.tracking)
                        .foregroundStyle(theme.colors.textNeutral9)
                }
            } actions: {
                DSButton(style: .neutral, size: .medium, systemIcon: "line.3.horizontal") {}
            }
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.lg))

            sectionTitle("Top App Bar — Search")
            DSTopAppBar(searchPlaceholder: "Search...", onSearchTap: {}, leadingIcon: "line.3.horizontal", onLeadingTap: {}) {
                Button {} label: {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 24))
                        .foregroundStyle(theme.colors.textNeutral9)
                }
                .buttonStyle(.plain)
            }
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.lg))

            sectionTitle("Top App Bar — Image-Title")
            DSTopAppBar(title: "User Name") {
                RoundedRectangle(cornerRadius: theme.radius.sm)
                    .fill(theme.colors.surfaceSecondary100)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundStyle(theme.colors.textNeutral9.opacity(0.5))
                    )
            } actions: {
                DSButton("Follow", style: .neutral, size: .medium, iconRight: "plus") {}
            }
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.lg))

            sectionTitle("Bottom App Bar — Full")
            DSBottomAppBar(
                items: iconItems,
                selectedId: $fullTab,
                style: .full,
                fabIcon: "plus",
                onFabTap: {}
            )

            sectionTitle("Bottom App Bar — Floating")
            DSBottomAppBar(
                items: iconItems,
                selectedId: $floatingTab,
                style: .floating,
                fabIcon: "plus",
                onFabTap: {}
            )

            sectionTitle("Bottom App Bar — Labeled")
            DSBottomAppBar(
                items: labeledItems,
                selectedId: $labeledTab,
                style: .labeled
            )

            sectionTitle("Segmented Picker — Tabs")
            DSSegmentedPicker(items: ["Day", "Week", "Month"], selectedIndex: $segmentIndex)

            sectionTitle("Segmented Picker — Pills")
            DSSegmentedPicker(items: ["All", "Active", "Archived", "Done"], selectedIndex: $pillsIndex, style: .pills)

            sectionTitle("Page Control")
            HStack {
                Spacer()
                DSPageControl(count: 5, currentIndex: $pageIndex)
                Spacer()
            }
        }
    }

    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(theme.typography.label.font)
            .foregroundStyle(theme.colors.textNeutral8)
    }
}

// MARK: - Misc Showcase (Avatar, ProgressCircle, Divider, Tooltip)

private struct MiscShowcase: View {
    @Environment(\.theme) private var theme

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // MARK: Avatars
            sectionTitle("Avatars — Monogram")
            HStack(spacing: 16) {
                DSAvatar(style: .monogram("H"))
                DSAvatar(style: .monogram("AB"), size: 48)
                DSAvatar(style: .monogram("Z"), size: 56)
            }

            sectionTitle("Avatars — Icon")
            HStack(spacing: 16) {
                DSAvatar(style: .icon("person"))
                DSAvatar(style: .icon("star.fill"), size: 48)
            }

            sectionTitle("Avatars — Image")
            HStack(spacing: 16) {
                DSAvatar(style: .image(Image(systemName: "photo.fill")))
                DSAvatar(style: .image(Image(systemName: "mountain.2.fill")), size: 56)
            }

            // MARK: Progress Circles
            sectionTitle("Progress Circle")
            HStack(spacing: 12) {
                DSProgressCircle(progress: 0.1)
                DSProgressCircle(progress: 0.3)
                DSProgressCircle(progress: 0.5)
                DSProgressCircle(progress: 0.7)
                DSProgressCircle(progress: 1.0)
            }

            sectionTitle("Progress Circle — Large")
            HStack(spacing: 16) {
                DSProgressCircle(progress: 0.25, size: 56, lineWidth: 4)
                DSProgressCircle(progress: 0.65, size: 56, lineWidth: 4)
                DSProgressCircle(progress: 0.9, size: 56, lineWidth: 4)
            }

            // MARK: Dividers
            sectionTitle("Dividers")

            VStack(alignment: .leading, spacing: 4) {
                Text("Full-bleed")
                    .font(theme.typography.small.font)
                    .foregroundStyle(theme.colors.textNeutral8)
                DSDivider(style: .fullBleed)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Inset")
                    .font(theme.typography.small.font)
                    .foregroundStyle(theme.colors.textNeutral8)
                DSDivider(style: .inset)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Middle")
                    .font(theme.typography.small.font)
                    .foregroundStyle(theme.colors.textNeutral8)
                DSDivider(style: .middle)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Subheader")
                    .font(theme.typography.small.font)
                    .foregroundStyle(theme.colors.textNeutral8)
                DSDivider(style: .subheader("Section Title"))
            }

            // MARK: Tooltips
            sectionTitle("Tooltips — Simple")
            HStack(spacing: 24) {
                VStack(spacing: 4) {
                    DSTooltip(style: .simple("Hint text here."), direction: .top)
                    Text("Top").font(theme.typography.small.font)
                }
                VStack(spacing: 4) {
                    DSTooltip(style: .simple("Hint text here."), direction: .bottom)
                    Text("Bottom").font(theme.typography.small.font)
                }
            }
            .foregroundStyle(theme.colors.textNeutral8)

            sectionTitle("Tooltips — Rich")
            DSTooltip(
                style: .rich(
                    title: "Tooltip Title",
                    body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                    actionLabel: "Find out more",
                    onAction: {}
                ),
                direction: .top
            )

            DSTooltip(
                style: .rich(
                    title: "Tooltip Title",
                    body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                    image: AnyView(
                        LinearGradient(
                            colors: [Color(red: 1.0, green: 0.42, blue: 0.37), Color(red: 0.4, green: 0.35, blue: 0.35)],
                            startPoint: .topTrailing,
                            endPoint: .bottomLeading
                        )
                    ),
                    actionLabel: "Find out more",
                    onAction: {}
                ),
                direction: .bottom
            )
        }
    }

    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(theme.typography.label.font)
            .foregroundStyle(theme.colors.textNeutral8)
    }
}

// MARK: - Previews

#Preview("Light Rounded") {
    ComponentShowcaseView()
        .previewThemed(brand: .coralCamo, style: .lightRounded)
}

#Preview("Dark Sharp") {
    ComponentShowcaseView()
        .previewThemed(brand: .blueHaze, style: .darkSharp)
}
