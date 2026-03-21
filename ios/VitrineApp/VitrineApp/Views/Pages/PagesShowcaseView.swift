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
                    LazyView(WalkthroughPage().navigationBarTitleDisplayMode(.inline))
                }

                NavigationLink("Walkthrough 2 — Stacked images") {
                    LazyView(Walkthrough2Page().navigationBarTitleDisplayMode(.inline))
                }

                NavigationLink("Walkthrough 3 — Side-by-side") {
                    LazyView(Walkthrough3Page().navigationBarTitleDisplayMode(.inline))
                }

                NavigationLink("Walkthrough 18 — Dark carousel") {
                    LazyView(Walkthrough18Page())
                }
            }

            Section("Authentication") {
                NavigationLink("Log In 1 — Capsule tabs") {
                    LazyView(LoginPage().navigationBarTitleDisplayMode(.inline))
                }

                NavigationLink("Log In 2 — Underline tabs") {
                    LazyView(Login2Page().navigationBarTitleDisplayMode(.inline))
                }

                NavigationLink("Log In 4 — Social first") {
                    LazyView(Login4Page().navigationBarTitleDisplayMode(.inline))
                }

                NavigationLink("Log In 6 — Error state") {
                    LazyView(Login6ErrorPage().navigationBarTitleDisplayMode(.inline))
                }

                NavigationLink("Biometric Login") {
                    LazyView(BiometricLoginPage().navigationBarTitleDisplayMode(.inline))
                }

                NavigationLink("Passcode Login") {
                    LazyView(PasscodeLoginPage().navigationBarTitleDisplayMode(.inline))
                }
            }

            Section("Profile") {
                NavigationLink("[Profile] 1 — Carousel & dark info card") {
                    LazyView(ProfilePage().navigationBarTitleDisplayMode(.inline))
                }
                NavigationLink("[Profile] 2 — Stats & list") {
                    LazyView(Profile2Page().navigationBarTitleDisplayMode(.inline))
                }
                NavigationLink("[Profile] 3 — Carousel & CTAs") {
                    LazyView(Profile3Page().navigationBarTitleDisplayMode(.inline))
                }
                NavigationLink("[Profile] 4 — Hero & photo grid") {
                    LazyView(Profile4Page().navigationBarTitleDisplayMode(.inline))
                }
                NavigationLink("[Profile] 8 — Coral card & photo grid") {
                    LazyView(Profile8Page().navigationBarTitleDisplayMode(.inline))
                }
                NavigationLink("[Profile] 10 — Portrait & stacked follower cards") {
                    LazyView(Profile10Page().navigationBarTitleDisplayMode(.inline))
                }
                NavigationLink("[Profile] 9 — Offset hero & info card") {
                    LazyView(Profile9Page().navigationBarTitleDisplayMode(.inline))
                }
                NavigationLink("[Profile] 5 — Dark card & photo grid") {
                    LazyView(Profile5Page().navigationBarTitleDisplayMode(.inline))
                }
                NavigationLink("[Profile] 6 — Hero image & social icons") {
                    LazyView(Profile6Page().navigationBarTitleDisplayMode(.inline))
                }
                NavigationLink("[Profile] 7 — Stats & progress circles") {
                    LazyView(Profile7Page().navigationBarTitleDisplayMode(.inline))
                }
            }

            Section("Alerts") {
                NavigationLink("[Alerts] 1 — Offline Error") {
                    LazyView(Alert1Page().navigationBarTitleDisplayMode(.inline))
                }

                NavigationLink("[Alerts] 2 — Photo Upload") {
                    LazyView(Alert2Page().navigationBarTitleDisplayMode(.inline))
                }

                NavigationLink("[Alerts] 3 - Error — Bottom Sheet") {
                    LazyView(Alert3Page().navigationBarTitleDisplayMode(.inline))
                }

                NavigationLink("[Alerts] 4 - Warning — Banner") {
                    LazyView(Alert4Page().navigationBarTitleDisplayMode(.inline))
                }

                NavigationLink("[Alerts] 5 - Success — Banner") {
                    LazyView(Alert5Page().navigationBarTitleDisplayMode(.inline))
                }

                NavigationLink("[Alerts] 6 - Info — Banner") {
                    LazyView(Alert6Page().navigationBarTitleDisplayMode(.inline))
                }

                NavigationLink("[Alerts] 7 — Battery Warning") {
                    LazyView(Alert7Page().navigationBarTitleDisplayMode(.inline))
                }

                NavigationLink("[Alerts] 8 — Contacts Access") {
                    LazyView(Alert8Page().navigationBarTitleDisplayMode(.inline))
                }

                NavigationLink("[Alerts] 9 — Notification Permission") {
                    LazyView(Alert9Page().navigationBarTitleDisplayMode(.inline))
                }

                NavigationLink("[Alerts] 10 — Server Error") {
                    LazyView(Alert10Page().navigationBarTitleDisplayMode(.inline))
                }

                NavigationLink("[Alerts] 11 — Calendar Notification") {
                    LazyView(Alert11Page().navigationBarTitleDisplayMode(.inline))
                }
            }

            Section("Stats") {
                NavigationLink("[Stats] 2 — Transaction History") {
                    LazyView(Stats2Page().navigationBarTitleDisplayMode(.inline))
                }

                NavigationLink("[Stats] 11 — Weather Dashboard") {
                    LazyView(Stats11Page().navigationBarTitleDisplayMode(.inline))
                }

                NavigationLink("[Stats] 16 — Transactions") {
                    LazyView(Stats16Page().navigationBarTitleDisplayMode(.inline))
                }

                NavigationLink("[Stats] 17 — Player Comparison") {
                    LazyView(Stats17Page().navigationBarTitleDisplayMode(.inline))
                }
            }

            Section("Feed") {
                NavigationLink("[Feed] 1 — Social Feed") {
                    LazyView(Feed1Page().navigationBarTitleDisplayMode(.inline))
                }
            }

            Section("Navigation") {
                NavigationLink("[Navigation] 3 — Icon Sidebar & Carousel") {
                    LazyView(Navigation3Page().navigationBarTitleDisplayMode(.inline))
                }

                NavigationLink("[Navigation] 7 — Bottom Nav Overlay") {
                    LazyView(Navigation7Page().navigationBarTitleDisplayMode(.inline))
                }

                NavigationLink("[Navigation] 8 — Side Menu & Carousel") {
                    LazyView(Navigation8Page().navigationBarTitleDisplayMode(.inline))
                }
            }

            Section("Shopping") {
                NavigationLink("[Shopping] Start 4 — New Arrivals & Sale") {
                    LazyView(ShoppingStart4Page().navigationBarTitleDisplayMode(.inline))
                }

                NavigationLink("[Shopping] Start 5 — Product Grid") {
                    LazyView(ShoppingStart5Page().navigationBarTitleDisplayMode(.inline))
                }
            }

            Section("Password Recovery") {
                NavigationLink("Forgot Password") {
                    LazyView(ForgotPasswordPage().navigationBarTitleDisplayMode(.inline))
                }

                NavigationLink("Verify Code") {
                    LazyView(VerifyCodePage().navigationBarTitleDisplayMode(.inline))
                }

                NavigationLink("New Password") {
                    LazyView(NewPasswordPage().navigationBarTitleDisplayMode(.inline))
                }
            }
        }
        .navigationTitle("Pages")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    PagesShowcaseView()
        .previewThemed()
}
