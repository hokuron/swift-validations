public struct ValidationErrors: Error, Hashable, Sendable {
    @usableFromInline
    var errors: [ValidationError]

    @inlinable
    public init(_ errors: [ValidationError]) {
        precondition(!errors.isEmpty)
        self.errors = errors
    }

    @inlinable
    var reasons: ValidationError.Reasons {
        errors.reduce([]) { $0.union($1.reasons) }
    }

    @inlinable
    public func reasons(for key: AnyHashable) -> ValidationError.Reasons {
        self[key].reduce([]) { $0.union($1.reasons) }
    }

    @inlinable
    public func reasons<Root>(for keyPath: PartialKeyPath<Root>) -> ValidationError.Reasons {
        self[keyPath].reduce([]) { $0.union($1.reasons) }
    }

    @inlinable
    public subscript(_ key: AnyHashable) -> [ValidationError] {
        errors.filter { $0.key == key }
    }

    @inlinable
    public subscript<Root>(_ keyPath: PartialKeyPath<Root>) -> [ValidationError] {
        #if swift(>=6.0)
        errors.filter { $0.key == AnyHashable(keyPath) }
        #else
        errors.filter { $0.key == AnyHashable(keyPath.hashValue) }
        #endif
    }
}

extension ValidationErrors: MutableCollection {
    public typealias Element = ValidationError
    public typealias Index = [ValidationError].Index

    @inlinable
    @inline(__always)
    public var startIndex: Index { errors.startIndex }

    @inlinable
    @inline(__always)
    public var endIndex: Index { errors.endIndex }

    @inlinable
    @inline(__always)
    public func index(after i: Index) -> Index { errors.index(after: i) }

    @inlinable
    @inline(__always)
    public subscript(position: Index) -> Element {
        _read { yield errors[position] }
        _modify { yield &errors[position] }
    }
}
