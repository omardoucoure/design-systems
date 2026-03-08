import SwiftUI
import DesignSystem

// MARK: - PagesShowcaseView

/// Lists all page examples. Each row navigates to a full-screen page demo.
struct PagesShowcaseView: View {
    @Environment(\.theme) private var theme

    var body: some View {
        List {
            Section("Onboarding") {
                NavigationLink("Walkthrough 1 — Text carousel") {
                    WalkthroughPage()
                        .navigationBarTitleDisplayMode(.inline)
                }

                NavigationLink("Walkthrough 2 — Stacked images") {
                    Walkthrough2Page()
                        .navigationBarTitleDisplayMode(.inline)
                }

                NavigationLink("Walkthrough 3 — Side-by-side") {
                    Walkthrough3Page()
                        .navigationBarTitleDisplayMode(.inline)
                }
            }

            Section("Authentication") {
                NavigationLink("Log In 1 — Capsule tabs") {
                    LoginPage()
                        .navigationBarTitleDisplayMode(.inline)
                }

                NavigationLink("Log In 2 — Underline tabs") {
                    Login2Page()
                        .navigationBarTitleDisplayMode(.inline)
                }

                NavigationLink("Log In 4 — Social first") {
                    Login4Page()
                        .navigationBarTitleDisplayMode(.inline)
                }

                NavigationLink("Log In 6 — Error state") {
                    Login6ErrorPage()
                        .navigationBarTitleDisplayMode(.inline)
                }

                NavigationLink("Biometric Login") {
                    BiometricLoginPage()
                        .navigationBarTitleDisplayMode(.inline)
                }

                NavigationLink("Passcode Login") {
                    PasscodeLoginPage()
                        .navigationBarTitleDisplayMode(.inline)
                }
            }

            Section("Profile") {
                NavigationLink("Profile — Photo carousel") {
                    ProfilePage()
                        .navigationBarTitleDisplayMode(.inline)
                }
                NavigationLink("Profile 2 — Stats & list") {
                    Profile2Page()
                        .navigationBarTitleDisplayMode(.inline)
                }
                NavigationLink("Profile 3 — Carousel & CTAs") {
                    Profile3Page()
                        .navigationBarTitleDisplayMode(.inline)
                }
                NavigationLink("Profile 4 — Hero & photo grid") {
                    Profile4Page()
                        .navigationBarTitleDisplayMode(.inline)
                }
            }

            Section("Alerts") {
                NavigationLink("[Alerts] 1 — Offline Error") {
                    Alert1Page()
                        .navigationBarTitleDisplayMode(.inline)
                }

                NavigationLink("[Alerts] 2 — Photo Upload") {
                    Alert2Page()
                        .navigationBarTitleDisplayMode(.inline)
                }

                NavigationLink("[Alerts] 3 - Error — Bottom Sheet") {
                    Alert3Page()
                        .navigationBarTitleDisplayMode(.inline)
                }

                NavigationLink("[Alerts] 4 - Warning — Banner") {
                    Alert4Page()
                        .navigationBarTitleDisplayMode(.inline)
                }

                NavigationLink("[Alerts] 5 - Success — Banner") {
                    Alert5Page()
                        .navigationBarTitleDisplayMode(.inline)
                }

                NavigationLink("[Alerts] 6 - Info — Banner") {
                    Alert6Page()
                        .navigationBarTitleDisplayMode(.inline)
                }

                NavigationLink("[Alerts] 7 — Battery Warning") {
                    Alert7Page()
                        .navigationBarTitleDisplayMode(.inline)
                }

                NavigationLink("[Alerts] 8 — Contacts Access") {
                    Alert8Page()
                        .navigationBarTitleDisplayMode(.inline)
                }

                NavigationLink("[Alerts] 9 — Notification Permission") {
                    Alert9Page()
                        .navigationBarTitleDisplayMode(.inline)
                }

                NavigationLink("[Alerts] 10 — Server Error") {
                    Alert10Page()
                        .navigationBarTitleDisplayMode(.inline)
                }

                NavigationLink("[Alerts] 11 — Calendar Notification") {
                    Alert11Page()
                        .navigationBarTitleDisplayMode(.inline)
                }
            }

            Section("Password Recovery") {
                NavigationLink("Forgot Password") {
                    ForgotPasswordPage()
                        .navigationBarTitleDisplayMode(.inline)
                }

                NavigationLink("Verify Code") {
                    VerifyCodePage()
                        .navigationBarTitleDisplayMode(.inline)
                }

                NavigationLink("New Password") {
                    NewPasswordPage()
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
        .navigationTitle("Pages")
    }
}

#Preview {
    PagesShowcaseView()
        .previewThemed()
}
