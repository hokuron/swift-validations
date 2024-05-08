public struct Presence<Value>: Validator, PresenceValidatable {
    public var value: Value?
    public var presenceOption: PresenceOption = .required

    @inlinable
    public init(_ value: Value?) {
        self.value = value
    }

    @inlinable
    public func validate() throws {
        _ = try validatePresence()
    }
}

extension Presence: Sendable where Value: Sendable {}
extension Presence: Equatable where Value: Equatable {}
extension Presence: Hashable where Value: Hashable {}
