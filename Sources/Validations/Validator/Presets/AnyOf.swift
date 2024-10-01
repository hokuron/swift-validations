public struct AnyOf: Validator {
    @usableFromInline
    let _validate: () throws -> Void

    public init<Value>(_ values: some Sequence<Value>, @ValidatorBuilder pass build: @escaping (Value) -> some Validator) {
        self._validate = {
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

    public func validate() throws {
        try _validate()
    }
}