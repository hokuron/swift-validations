extension Validator {
    @inlinable
    public func errorKey<K: Hashable & Sendable>(_ key: K) -> some Validator {
        _ErrorKeyModifier(parent: self, errorKey: key)
    }

    #if swift(>=6.0)
    @inlinable
    public func errorKey<Root>(_: Root.Type = Root.self, _ keyPath: any PartialKeyPath<Root> & Sendable) -> some Validator {
        _ErrorKeyModifier(parent: self, errorKey: keyPath)
    }
    #else
    @inlinable
    public func errorKey<Root>(_ keyPath: PartialKeyPath<Root>) -> some Validator {
        _ErrorKeyModifier(parent: self, errorKey: keyPath.hashValue)
    }
    #endif
}

@usableFromInline
struct _ErrorKeyModifier<Parent: Validator, Key: Hashable & Sendable>: Validator {
    @usableFromInline
    var parent: Parent

    @usableFromInline
    var errorKey: Key

    @usableFromInline
    init(parent: Parent, errorKey: Key) {
        self.parent = parent
        self.errorKey = errorKey
    }

    @usableFromInline
    func validate() throws {
        do {
            try parent.validate()
        } catch var error as ValidationError {
            error.setKey(errorKey)
            throw error
        } catch var errors as ValidationErrors {
            for index in errors.indices where errors[index].key == nil {
                errors[index].setKey(errorKey)
            }
            throw errors
        } catch {
            preconditionFailure("Unknown error: \(error)")
        }
    }
}
