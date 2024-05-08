public struct Absence<Value>: Validator {
    public var value: Value?

    @inlinable
    public init(_ value: Value?) {
        self.value = value
    }

    @inlinable
    public func validate() throws {
        if !( (value as? any Collection)?.isEmpty ?? (value == nil) ) {
            throw ValidationError(reasons: .present)
        }
    }
}

extension Absence: Sendable where Value: Sendable {}
extension Absence: Equatable where Value: Equatable {}
extension Absence: Hashable where Value: Hashable {}
