public struct AnyOf: Validator {
    @usableFromInline
    let _validate: () throws -> Void

    @inlinable
    public init<Value>(_ values: some Collection<Value>, @ValidatorBuilder pass build: @escaping (Value) -> some Validator) {
        self._validate = {
            guard !values.isEmpty else { return }

            var errors = [ValidationError]()

            for value in values {
                do {
                    try build(value).validate()
                    return
                } catch let error as ValidationError {
                    errors.append(error)
                } catch let error as ValidationErrors {
                    errors.append(contentsOf: error.errors)
                } catch {
                    preconditionFailure("Unknown error: \(error)")
                }
            }

            throw ValidationErrors(errors)
        }
    }

    @inlinable
    public init<Value>(_ values: some Collection<Value>, pass keyPath: KeyPath<Value, some Validator>) {
        self.init(values) { $0[keyPath: keyPath] }
    }

    @inlinable
    public init(_ values: some Collection<some Validator>) {
        self.init(values, pass: \.self)
    }

    @inlinable
    public func validate() throws {
        try _validate()
    }
}
