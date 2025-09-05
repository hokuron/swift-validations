public struct Count<Value: Collection, Range: RangeExpression<Int>>: Validator, PresenceValidatable {
    public var value: Value?

    @usableFromInline
    var range: Range

    public var presenceOption: PresenceOption = .required(allowsEmpty: true)

    @inlinable
    public init(of value: Value?, within range: Range) {
        self.value = value
        self.range = range
    }

    @inlinable
    public init(of value: Value?, exact count: Int) where Range == ClosedRange<Int> {
        self.value = value
        self.range = count...count
    }

    @inlinable
    public func validate() throws {
        guard let presenceValue = try validatePresence(resolvingErrorWithReasons: .count) else {
            return
        }

        if !range.contains(presenceValue.count) {
            throw ValidationError(reasons: .count)
        }
    }
}

extension Count: Sendable where Value: Sendable, Range: Sendable {}
extension Count: Equatable where Value: Equatable, Range: Equatable {}
extension Count: Hashable where Value: Hashable, Range: Hashable {}
