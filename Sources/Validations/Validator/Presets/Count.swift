public struct Count<Value: Collection, Range: RangeExpression<Int>>: Validator {
    public var value: Value?

    @usableFromInline
    var range: Range

    @usableFromInline
    var allowsNil = false

    @inlinable
    public init(_ value: Value?, within range: Range) {
        self.value = value
        self.range = range
    }

    @inlinable
    public init(_ value: Value?, exact count: Int) where Range == ClosedRange<Int> {
        self.value = value
        self.range = count...count
    }

    @inlinable
    public func validate() throws {
        guard let value else {
            if !allowsNil {
                throw ValidationError(reasons: .count)
            }
            return
        }

        if !range.contains(value.count) {
            throw ValidationError(reasons: .count)
        }
    }

    func allowsNil(_ enabled: Bool = true) -> Self {
        var `self` = self
        self.allowsNil = enabled
        return self
    }
}

extension Count: Sendable where Value: Sendable, Range: Sendable {}
