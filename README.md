# DesignSystem

Enum-driven mobile design system with a SwiftUI package under [`ios/`](./ios) and source tokens under [`tokens/`](./tokens).

## Repo layout

- `Package.swift`: root package entrypoint for the iOS library
- `ios/Sources/DesignSystem`: Swift package source
- `ios/Tests/DesignSystemTests`: package tests
- `ios/VitrineApp`: showcase app for browsing tokens and components
- `tokens/`: extracted primitive and semantic token definitions

## Use from the repo root

```sh
xcodebuild -scheme DesignSystem-Package -destination 'generic/platform=iOS Simulator' build
```

`swift test` on macOS is not a reliable validator for this package because the component layer uses iOS-only SwiftUI APIs.

## Consume in another package

```swift
.package(path: "/path/to/design-systems")
```

Then import the package and apply a theme:

```swift
import DesignSystem

ContentView()
    .designSystem(brand: .coralCamo, style: .lightRounded)
```

## Open the showcase app

The Swift package lives at the repository root now, but the sample app remains in [`ios/VitrineApp`](./ios/VitrineApp).
