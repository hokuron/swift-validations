public protocol PresenceValidatable {
    associatedtype Value

    var value: Value? { get }
    var presenceOption: PresenceOption { get set }
}

extension PresenceValidatable {
    /// Returns valid _presence_ `Value`.
    @inlinable
    public func validatePresence(resolvingErrorWithReasons reasons: ValidationError.Reasons? = nil) throws -> Value? {
        if !presenceOption.allowsNil, value == nil {
            throw ValidationError(reasons: reasons ?? .nil)
        }

        guard let collection = value as? any Collection else {
            return value
        }

        if !presenceOption.allowsEmpty, collection.isEmpty {
            throw ValidationError(reasons: reasons ?? .empty)
        }

        return collection.isEmpty ? nil : value
    }
}

public struct PresenceOption: Sendable, Hashable {
    public var allowsNil: Bool
    public var allowsEmpty: Bool

    @usableFromInline
    init(allowsNil: Bool, allowsEmpty: Bool) {
        self.allowsNil = allowsNil
        self.allowsEmpty = allowsEmpty
    }

    @inlinable
    public static func required(allowsNil: Bool = false, allowsEmpty: Bool = false) -> Self {
        Self(allowsNil: allowsNil, allowsEmpty: allowsEmpty)
    }

    public static let required = Self(allowsNil: false, allowsEmpty: false)
    public static let none = Self(allowsNil: true, allowsEmpty: true)
}

extension Validator where Self: PresenceValidatable {
    @inlinable
    public func presence(_ option: PresenceOption) -> Self {
        var `self` = self
        self.presenceOption = option
        return self
    }

    @inlinable
    public func allowsNil(_ enabled: Bool = true) -> Self {
        var `self` = self
        self.presenceOption.allowsNil = enabled
        return self
    }

    @inlinable
    public func allowsEmpty(_ enabled: Bool = true) -> Self where Value: Collection {
        var `self` = self
        self.presenceOption.allowsEmpty = enabled
        return self
    }
}
