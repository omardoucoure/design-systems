import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension View {
    func flattenedTextContainerInset() -> some View {
        modifier(FlattenedTextContainerInset())
    }
}

private struct FlattenedTextContainerInset: ViewModifier {
    func body(content: Content) -> some View {
        content.background(TextContainerInsetFlattener())
    }
}

#if canImport(UIKit)
private struct TextContainerInsetFlattener: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let probe = UIView(frame: .zero)
        probe.isUserInteractionEnabled = false
        return probe
    }

    func updateUIView(_ probe: UIView, context: Context) {
        DispatchQueue.main.async {
            guard let textView = probe.enclosingTextView else { return }
            let inset = DSTextArea.Geometry.editorTextContainerInset
            textView.textContainerInset = UIEdgeInsets(top: inset.height, left: inset.width,
                                                       bottom: inset.height, right: inset.width)
            textView.textContainer.lineFragmentPadding = DSTextArea.Geometry.editorLineFragmentPadding
        }
    }
}

private extension UIView {
    var enclosingTextView: UITextView? {
        var candidate: UIView? = superview
        while let view = candidate {
            if let textView = view as? UITextView { return textView }
            candidate = view.superview
        }
        return nil
    }
}
#elseif canImport(AppKit)
private struct TextContainerInsetFlattener: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        NSView(frame: .zero)
    }

    func updateNSView(_ probe: NSView, context: Context) {
        DispatchQueue.main.async {
            guard let textView = probe.enclosingTextView else { return }
            textView.textContainerInset = DSTextArea.Geometry.editorTextContainerInset
            textView.textContainer?.lineFragmentPadding = DSTextArea.Geometry.editorLineFragmentPadding
        }
    }
}

private extension NSView {
    var enclosingTextView: NSTextView? {
        var candidate: NSView? = superview
        while let view = candidate {
            if let textView = view as? NSTextView { return textView }
            if let scrollView = view as? NSScrollView,
               let textView = scrollView.documentView as? NSTextView {
                return textView
            }
            candidate = view.superview
        }
        return nil
    }
}
#endif
