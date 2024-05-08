public protocol Validator {
    associatedtype Validation

    func validate() throws

    @ValidatorBuilder
    var validation: Validation { get }
}

extension Validator {
    @inlinable
    public var isValid: Bool {
        switch result {
        case .success:
            true
        case .failure:
            false
        }
    }

    @inlinable
    public var result: Result<Void, ValidationErrors> {
        if let validationErrors {
            .failure(validationErrors)
        } else {
            .success(())
        }
    }

    @inlinable
    public var validationErrors: ValidationErrors? {
        do {
            try validate()
            return nil
        } catch let error as ValidationError {
            return ValidationErrors([error])
        } catch let errors as ValidationErrors {
            return errors
        } catch {
            preconditionFailure("Unknown error: \(error)")
        }
    }
}

extension Validator where Validation == Never {
    @_transparent
    public var validation: Validation { fatalError() }
}

extension Validator where Validation: Validator {
    @inlinable
    public func validate() throws {
        try validation.validate()
    }
}
