import SwiftUI

/// Wraps a view so its body is only evaluated when the view actually appears.
/// Use this in NavigationLink destinations to avoid stack overflows from
/// SwiftUI eagerly evaluating all destination bodies in a large List.
struct LazyView<Content: View>: View {
    let build: () -> Content

    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }

    var body: Content {
        build()
    }
}
