@resultBuilder
public enum ValidatorBuilder {
    @inlinable
    public static func buildExpression<V: Validator>(_ expression: V) -> V {
        expression
    }

    @inlinable
    public static func buildBlock<V: Validator>(_ validator: V) -> V {
        validator
    }

    @inlinable
    public static func buildPartialBlock<V: Validator>(first: V) -> V {
        first
    }

    @inlinable
    public static func buildPartialBlock<V0: Validator, V1: Validator>(accumulated: V0, next: V1) -> _Validators<V0, V1> {
        _Validators(v0: accumulated, v1: next)
    }

    @inlinable
    public static func buildArray<V: Validator>(_ validators: [V]) -> _ValidatorArray<V> {
        _ValidatorArray(elements: validators)
    }

    @inlinable
    public static func buildOptional<V: Validator>(_ validator: V?) -> V? {
        validator
    }

    @inlinable
    public static func buildEither<First: Validator, Second: Validator>(first: First) -> _Conditional<First, Second> {
        .first(first)
    }

    @inlinable
    public static func buildEither<First: Validator, Second: Validator>(second: Second) -> _Conditional<First, Second> {
        .second(second)
    }

    @inlinable
    public static func buildLimitedAvailability<V: Validator>(_ validator: V) -> Validate {
        Validate(using: validator)
    }

    public struct _Validators<V0: Validator, V1: Validator>: Validator {
        @usableFromInline
        let v0: V0
        @usableFromInline
        let v1: V1

        @usableFromInline
        init(v0: V0, v1: V1) {
            self.v0 = v0
            self.v1 = v1
        }

        @inlinable
        public func validate() throws {
            let errors = [
                _validate(using: v0),
                _validate(using: v1),
            ]
            .compactMap { $0 }
            .flatMap { $0 }

            if !errors.isEmpty {
                throw ValidationErrors(errors)
            }
        }

        @usableFromInline
        func _validate(using validator: some Validator) -> ValidationErrors? {
            do {
                try validator.validate()
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

    public struct _ValidatorArray<Element: Validator>: Validator {
        @usableFromInline
        let elements: [Element]

        @usableFromInline
        init(elements: [Element]) {
            self.elements = elements
        }

        @inlinable
        public func validate() throws {
            let errors = elements
                .compactMap(_validate(using:))
                .flatMap { $0 }

            if !errors.isEmpty {
                throw ValidationErrors(errors)
            }
        }

        @usableFromInline
        func _validate(using validator: some Validator) -> ValidationErrors? {
            do {
                try validator.validate()
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

    public enum _Conditional<First: Validator, Second: Validator>: Validator {
        case first(First)
        case second(Second)

        @inlinable
        public func validate() throws {
            switch self {
            case .first(let validator):
                try validator.validate()
            case .second(let validator):
                try validator.validate()
            }
        }
    }
}

@usableFromInline
func + (lhs: ValidationErrors, rhs: ValidationErrors) -> ValidationErrors {
    ValidationErrors(lhs.errors + rhs.errors)
}
