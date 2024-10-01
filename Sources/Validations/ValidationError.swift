public struct ValidationError: Error, Hashable, @unchecked Sendable {
    public var reasons: Reasons
    public private(set) var key: AnyHashable?

    @inlinable
    public init(reasons: Reasons) {
        self.reasons = reasons
    }

    #if DEBUG && swift(>=6.0) // https://github.com/apple/swift/issues/57560
    @usableFromInline
    mutating func setKey<R, V>(_ keyPath: KeyPath<R, V>) {
        self.key = keyPath
    }
    #else
    @usableFromInline
    mutating func setKey<T: Hashable & Sendable>(_ key: T) {
        self.key = key
    }
    #endif
}

extension ValidationError {
    public struct Reasons: OptionSet, Hashable, Sendable {
        public static let `nil` = Self(rawValue: 1 << 0)
        public static let empty = Self(rawValue: 1 << 1)
        public static let present = Self(rawValue: 1 << 2)

        public static let greaterThan = Self(rawValue: 1 << 3)
        public static let lessThan = Self(rawValue: 1 << 4)
        public static let greaterThanOrEqualTo = Self(rawValue: 1 << 5)
        public static let lessThanOrEqualTo = Self(rawValue: 1 << 6)
        public static let otherThan = Self(rawValue: 1 << 7)
        public static let equalTo = Self(rawValue: 1 << 8)

        public static let confirmation = Self(rawValue: 1 << 9)
        public static let format = Self(rawValue: 1 << 10)
        public static let exclusion = Self(rawValue: 1 << 11)
        public static let inclusion = Self(rawValue: 1 << 12)
        public static let count = Self(rawValue: 1 << 13)

        public static let `any` = Self(rawValue: 1 << 14)

        public let rawValue: Int
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }
}
