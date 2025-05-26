public struct Comparison<Value: Comparable>: Validator, PresenceValidatable {
    public enum Operator {
        case greaterThan(Value)
        case lessThan(Value)
        case greaterThanOrEqualTo(Value)
        case lessThanOrEqualTo(Value)
        case otherThan(Value)
        case equalTo(Value)

        public static func greaterThan<C: Collection>(_ suppliedValue: C) -> Self
        where C.Element: Comparable, Value == _LexicographicCollection<C> {
            .greaterThan(_LexicographicCollection(collection: suppliedValue))
        }
        public static func lessThan<C: Collection>(_ suppliedValue: C) -> Self
        where C.Element: Comparable, Value == _LexicographicCollection<C> {
            .lessThan(_LexicographicCollection(collection: suppliedValue))
        }
        public static func greaterThanOrEqualTo<C: Collection>(_ suppliedValue: C) -> Self
        where C.Element: Comparable, Value == _LexicographicCollection<C> {
            .greaterThanOrEqualTo(_LexicographicCollection(collection: suppliedValue))
        }
        public static func lessThanOrEqualTo<C: Collection>(_ suppliedValue: C) -> Self
        where C.Element: Comparable, Value == _LexicographicCollection<C> {
            .lessThanOrEqualTo(_LexicographicCollection(collection: suppliedValue))
        }
        public static func otherThan<C: Collection>(_ suppliedValue: C) -> Self
        where C.Element: Comparable, Value == _LexicographicCollection<C> {
            .otherThan(_LexicographicCollection(collection: suppliedValue))
        }
        public static func equalTo<C: Collection>(_ suppliedValue: C) -> Self
        where C.Element: Comparable, Value == _LexicographicCollection<C> {
            .equalTo(_LexicographicCollection(collection: suppliedValue))
        }

        @usableFromInline
        func perform(with value: Value) throws {
            switch self {
            case .greaterThan(let suppliedValue):
                if !(value > suppliedValue) {
                    throw ValidationError(reasons: .greaterThan)
                }
            case .lessThan(let suppliedValue):
                if !(value < suppliedValue) {
                    throw ValidationError(reasons: .lessThan)
                }
            case .greaterThanOrEqualTo(let suppliedValue):
                if !(value >= suppliedValue) {
                    throw ValidationError(reasons: .greaterThanOrEqualTo)
                }
            case .lessThanOrEqualTo(let suppliedValue):
                if !(value <= suppliedValue) {
                    throw ValidationError(reasons: .lessThanOrEqualTo)
                }
            case .otherThan(let suppliedValue):
                if value == suppliedValue {
                    throw ValidationError(reasons: .otherThan)
                }
            case .equalTo(let suppliedValue):
                if value != suppliedValue {
                    throw ValidationError(reasons: .equalTo)
                }
            }
        }
    }

    public var value: Value?

    @usableFromInline
    var `operator`: Operator

    public var presenceOption: PresenceOption = .required

    @inlinable
    public init(of value: Value?, _ operator: Operator) where Value: StringProtocol {
        self.value = value
        self.operator = `operator`
    }

    @inlinable
    public init<C: Collection>(of value: C?, _ operator: Operator) where C.Element: Comparable, Value == _LexicographicCollection<C> {
        self.value = value.map(_LexicographicCollection.init(collection:))
        self.operator = `operator`
    }

    @inlinable
    public init(of value: Value?, _ operator: Operator) {
        self.value = value
        self.operator = `operator`
    }

    @inlinable
    public init<E: Equatable>(of value: E?, equalTo suppliedValue: E) where Value == _EqualityOnlyComparable<E> {
        self.value = value.map(_EqualityOnlyComparable.init)
        self.operator = .equalTo(_EqualityOnlyComparable(suppliedValue))
    }

    @inlinable
    public func validate() throws {
        guard let presenceValue = try validatePresence(resolvingErrorWithReasons: `operator`.errorReasons) else {
            return
        }

        try `operator`.perform(with: presenceValue)
    }
}

public struct _EqualityOnlyComparable<Base: Equatable>: Comparable {
    @usableFromInline
    var base: Base

    @usableFromInline
    init(_ base: Base) {
        self.base = base
    }

    @inlinable
    @inline(__always)
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.base == rhs.base
    }

    @inlinable
    @inline(__always)
    public static func != (lhs: Self, rhs: Self) -> Bool {
        lhs.base != rhs.base
    }

    public static func < (lhs: Self, rhs: Self) -> Bool {
        preconditionFailure()
    }
}

public struct _LexicographicCollection<Base: Collection>: Comparable, Collection where Base.Element: Comparable {
    @usableFromInline
    var base: Base

    @usableFromInline
    init(collection: Base) {
        self.base = collection
    }

    @inlinable
    @inline(__always)
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.base.lexicographicallyPrecedes(rhs.base)
    }
    
    @inlinable
    @inline(__always)
    public static func == (lhs: Self, rhs: Self) -> Bool {
        Array(lhs.base) == Array(rhs.base)
    }

    @inlinable
    @inline(__always)
    public var startIndex: Base.Index { base.startIndex }

    @inlinable
    @inline(__always)
    public var endIndex: Base.Index { base.endIndex }

    @inlinable
    @inline(__always)
    public func index(after i: Base.Index) -> Base.Index { base.index(after: i) }

    @inlinable
    @inline(__always)
    public subscript(position: Base.Index) -> Base.Element {
        _read { yield base[position] }
    }
}

extension Comparison.Operator {
    @usableFromInline
    var errorReasons: ValidationError.Reasons {
        switch self {
        case .greaterThan:
            .greaterThan
        case .lessThan:
            .lessThan
        case .greaterThanOrEqualTo:
            .greaterThanOrEqualTo
        case .lessThanOrEqualTo:
            .lessThanOrEqualTo
        case .otherThan:
            .otherThan
        case .equalTo:
            .equalTo
        }
    }
}

extension Comparison: Sendable where Value: Sendable {}
extension Comparison: Equatable where Value: Equatable {}
extension Comparison: Hashable where Value: Hashable {}
extension Comparison.Operator: Sendable where Value: Sendable {}
extension Comparison.Operator: Equatable where Value: Equatable {}
extension Comparison.Operator: Hashable where Value: Hashable {}
