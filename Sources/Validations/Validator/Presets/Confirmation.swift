public struct Confirmation<Value: Equatable>: Validator, PresenceValidatable, Equatable {
    public var value: Value?
    public var sourceValue: Value?
    public var presenceOption: PresenceOption = .none

    @inlinable
    public init(of value: Value?, matching sourceValue: Value?) {
        self.value = value
        self.sourceValue = sourceValue
    }

    @inlinable
    public func validate() throws {
        guard let presenceValue = try validatePresence(resolvingErrorWithReasons: .confirmation) else {
            return
        }

        if presenceValue != sourceValue {
            throw ValidationError(reasons: .confirmation)
        }
    }
}

extension Confirmation: Sendable where Value: Sendable {}
extension Confirmation: Hashable where Value: Hashable {}
