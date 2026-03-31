import SwiftUI

// MARK: - Validation Rule

/// A single validation rule for a form field.
public struct DSValidationRule {
    public let message: LocalizedStringKey
    public let validate: (String) -> Bool

    public init(_ message: LocalizedStringKey, validate: @escaping (String) -> Bool) {
        self.message = message
        self.validate = validate
    }

    // MARK: - Built-in Rules

    /// Field must not be empty.
    public static func required(_ message: LocalizedStringKey = "This field is required") -> DSValidationRule {
        DSValidationRule(message) { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
    }

    /// Field must be a valid email.
    public static func email(_ message: LocalizedStringKey = "Enter a valid email") -> DSValidationRule {
        DSValidationRule(message) { $0.contains("@") && $0.contains(".") }
    }

    /// Field must have at least N characters.
    public static func minLength(_ n: Int, message: LocalizedStringKey? = nil) -> DSValidationRule {
        DSValidationRule(message ?? "Must be at least \(n) characters") { $0.count >= n }
    }

    /// Field must match another field's current value.
    public static func matches(_ other: DSFormField, message: LocalizedStringKey = "Fields do not match") -> DSValidationRule {
        DSValidationRule(message) { $0 == other.text }
    }
}

// MARK: - Form Field

/// Observable form field with built-in validation.
///
/// Usage:
/// ```swift
/// @StateObject private var email = DSFormField(rules: [.required(), .email()])
/// @StateObject private var password = DSFormField(rules: [.required(), .minLength(8)])
///
/// // In body:
/// DSTextField(field: email, placeholder: "Enter email")
///     .label("Email")
///     .icon(.mailOpen)
///
/// DSButton("Submit") { DSFormField.validateAll(email, password) }
/// ```
public final class DSFormField: ObservableObject {
    @Published public var text: String
    @Published public var didAttemptSubmit: Bool = false

    private let rules: [DSValidationRule]

    public init(_ initialText: String = "", rules: [DSValidationRule] = []) {
        self.text = initialText
        self.rules = rules
    }

    /// First failing rule's message, or nil if all pass.
    public var errorMessage: LocalizedStringKey? {
        guard didAttemptSubmit else { return nil }
        for rule in rules {
            if !rule.validate(text) { return rule.message }
        }
        return nil
    }

    /// Computed input state based on validation.
    public var inputState: InputState {
        if didAttemptSubmit && errorMessage != nil { return .error }
        return text.isEmpty ? .empty : .filled
    }

    /// Helper text — returns error message or empty string.
    public var helperText: LocalizedStringKey {
        errorMessage ?? ""
    }

    /// Whether this field passes all rules.
    public var isValid: Bool { errorMessage == nil }

    /// Validate multiple fields at once. Returns true if all pass.
    @discardableResult
    public static func validateAll(_ fields: DSFormField...) -> Bool {
        for field in fields { field.didAttemptSubmit = true }
        return fields.allSatisfy { $0.isValid }
    }

    /// Reset validation state.
    public func reset() {
        didAttemptSubmit = false
    }

    /// Reset all fields.
    public static func resetAll(_ fields: DSFormField...) {
        for field in fields { field.reset() }
    }
}

// MARK: - DSTextField + DSFormField

public extension DSTextField {
    /// Create a text field bound to a DSFormField with auto-validation.
    init(field: DSFormField, placeholder: LocalizedStringKey) {
        self.init(text: Binding(
            get: { field.text },
            set: { field.text = $0 }
        ), placeholder: placeholder)
        self = self
            .inputState(field.inputState)
            .helperText(field.helperText)
    }
}
