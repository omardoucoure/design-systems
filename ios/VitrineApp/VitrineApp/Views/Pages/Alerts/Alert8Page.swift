import SwiftUI
import DesignSystem

/// Figma: [Alerts] 8 (node 1023:88032)
struct Alert8Page: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss
    @State private var showDialog = false

    @State private var country = "Bulgaria"
    @State private var fullName = "Hristo Hristov"
    @State private var street = "Kostaki Peev 5 Str."
    @State private var postalCode = "4000"
    @State private var city = "Plovdiv"
    @State private var phone = "01234/56789010"
    @State private var email = "hristov123@gmail.com"

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                DSTopAppBar(title: "Change Address") {
                    DSButton { }.buttonStyle(.neutral).buttonSize(.medium).icon(.bellNotification)
                    DSButton { }.buttonStyle(.text).buttonSize(.medium).systemIcon("ellipsis")
                }.onBack { dismiss() }
                ScrollView {
                    VStack(spacing: theme.spacing.sm) { formCard }
                        .padding(.horizontal, theme.spacing.sm)
                }
            }
            .background(theme.colors.surfaceNeutral05.ignoresSafeArea())

            DSAlertDialog(
                isPresented: $showDialog,
                title: "Access to Your Contacts",
                message: "HaHo wants to explore your 578 contacts—birthdays, photos, and more. Dive in?",
                severity: .info,
                icon: .group
            ) {
                contactCardsStack
            } actions: {
                DSButton("Select Contacts...") { }
                    .buttonStyle(.text).buttonSize(.medium)
                    .icon(.group, position: .right)
                DSDivider()
                DSButton("Allow Full Access") { }
                    .buttonStyle(.text).buttonSize(.medium)
                    .icon(.magicWand, position: .right)
                DSDivider()
                DSButton("Don't Allow") { }
                    .buttonStyle(.text).buttonSize(.medium)
                    .icon(.trash, position: .right)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .dsTabBarHidden()
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.4)) { showDialog = true }
        }
    }

    private var formCard: some View {
        DSCard {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                DSText("Moving on up?", style: theme.typography.h4, color: theme.colors.textNeutral9)
                DSText("Update your address here!",
                       style: theme.typography.caption, color: theme.colors.textNeutral9.opacity(0.75))
                DSTextField(text: $country, placeholder: "Country")
                    .label("Country*")
                    .inputState(.filled)
                DSTextField(text: $fullName, placeholder: "Full Name")
                    .label("Full Name*")
                    .inputState(.filled)
                    .icon(.user)
                DSTextField(text: $street, placeholder: "Street Address")
                    .label("Street Address*")
                    .inputState(.filled)
                HStack(spacing: theme.spacing.sm) {
                    DSTextField(text: $postalCode, placeholder: "Postal Code")
                        .label("Postal Code*")
                        .inputState(.filled)
                    DSTextField(text: $city, placeholder: "City")
                        .label("City*")
                        .inputState(.filled)
                }
                DSTextField(text: $phone, placeholder: "Phone Number")
                    .label("Phone Number*")
                    .inputState(.filled)
                DSTextField(text: $email, placeholder: "Email")
                    .label("Your Email")
                    .inputState(.filled)
                    .icon(.mail)
                DSButton("Change Address") { }
                    .buttonStyle(.filledA)
                    .systemIcon("arrow.right", position: .right)
                    .fullWidth()
            }
            .padding(.horizontal, theme.spacing.xl)
            .padding(.vertical, theme.spacing.xxl)
        }
        .cardPadding(0)
    }

    private var contactCardsStack: some View {
        VStack(spacing: 0) {
            HStack(spacing: theme.spacing.sm) {
                DSAvatar(style: .image(Image("avatar_contact")), size: 40)
                VStack(alignment: .leading, spacing: 2) {
                    DSText("Kiko Valentino", style: theme.typography.label, color: theme.colors.textNeutral9)
                    DSText("6 phone numbers, email, location, birthday",
                           style: theme.typography.small, color: theme.colors.textNeutral8)
                }
            }
            .padding(theme.spacing.sm)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(theme.colors.surfaceNeutral05)
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.lg))
            .shadow(color: .black.opacity(0.06), radius: 2, x: 0, y: 2)
            .shadow(color: .black.opacity(0.10), radius: 4, x: 0, y: 4)
            .zIndex(3)

            RoundedRectangle(cornerRadius: theme.radius.lg)
                .fill(theme.colors.surfaceNeutral2)
                .frame(width: 208, height: 66)
                .padding(.top, -40)
                .zIndex(2)

            RoundedRectangle(cornerRadius: theme.radius.lg)
                .fill(theme.colors.surfaceNeutral3)
                .frame(width: 151, height: 66)
                .padding(.top, -40)
                .zIndex(1)
        }
        .padding(.top, theme.spacing.md)
        .padding(.bottom, 56)
    }
}

#Preview {
    Alert8Page()
        .previewThemed()
}
