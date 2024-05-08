public struct Validate: Validator {
    @usableFromInline
    let _validate: () throws -> Void

    @inlinable
    @_disfavoredOverload
    public init(validate: @escaping () throws -> Void) {
        self._validate = validate
    }

    @inlinable
    public init(@ValidatorBuilder _ build: @escaping () -> some Validator) {
        self.init(validate: build().validate)
    }

    @inlinable
    public init(using validator: some Validator) {
        self.init(validate: validator.validate)
    }

    @inlinable
    public func validate() throws {
        try _validate()
    }
}
