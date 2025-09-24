import RegexBuilder

@attached(extension, conformances: Validatable, names: named(validation))
public macro Validatable() = #externalMacro(module: "ValidationsMacros", type: "ValidatableMacro")

// MARK: - Presence

@freestanding(declaration)
public macro Validation<V: Validatable, T>(
    _ targets: KeyPath<V, T>...,
    presence: PresenceOption,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, T>(
    _ targets: KeyPath<V, T?>...,
    presence: PresenceOption,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

// MARK: - Absence

public enum AbsenceMacroOption {
    case required
}

@freestanding(declaration)
public macro Validation<V: Validatable, T>(
    _ targets: KeyPath<V, T>...,
    absence: AbsenceMacroOption,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, T>(
    _ targets: KeyPath<V, T?>...,
    absence: AbsenceMacroOption,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

// MARK: - Format

@freestanding(declaration)
public macro Validation<V: Validatable, each T: StringProtocol, O>(
    _ targets: repeat KeyPath<V, (each T)?>,
    format: Regex<O>,
    presence: PresenceOption = .required,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<
    V: Validatable,
    each T: StringProtocol,
    O
>(
    _ targets: repeat KeyPath<V, each T>,
    format: Regex<O>,
    presence: PresenceOption = .required,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

// MARK: - Comparison

public enum ComparisonMacroOperator<Value> {
    case greaterThan(Value)
    case lessThan(Value)
    case greaterThanOrEqualTo(Value)
    case lessThanOrEqualTo(Value)
    case otherThan(Value)
    case equalTo(Value)
}

@freestanding(declaration)
public macro Validation<V: Validatable, T: Comparable>(
    _ targets: KeyPath<V, T>...,
    comparison : ComparisonMacroOperator<T>,
    presence: PresenceOption = .required,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, T: Comparable>(
    _ targets: KeyPath<V, T?>...,
    comparison : ComparisonMacroOperator<T>,
    presence: PresenceOption = .required,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, S: StringProtocol>(
    _ targets: KeyPath<V, S>...,
    comparison : ComparisonMacroOperator<S>,
    presence: PresenceOption = .required,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, S: StringProtocol>(
    _ targets: KeyPath<V, S?>...,
    comparison : ComparisonMacroOperator<S>,
    presence: PresenceOption = .required,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, C: Collection<E>, E: Comparable>(
    _ targets: KeyPath<V, C>...,
    comparison: ComparisonMacroOperator<C>,
    presence: PresenceOption = .required,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, C: Collection<E>, E: Comparable>(
    _ targets: KeyPath<V, C?>...,
    comparison: ComparisonMacroOperator<C>,
    presence: PresenceOption = .required,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, E: Equatable>(
    _ targets: KeyPath<V, E>...,
    equalTo: E,
    presence: PresenceOption = .required,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, E: Equatable>(
    _ targets: KeyPath<V, E?>...,
    equalTo: E,
    presence: PresenceOption = .required,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

// MARK: - Inclusion

@freestanding(declaration)
public macro Validation<V: Validatable, T, M: Collection<T>>(
    _ targets: KeyPath<V, T>...,
    inclusion: M,
    presence: PresenceOption = .required,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, T, M: Collection<T>>(
    _ targets: KeyPath<V, T?>...,
    inclusion: M,
    presence: PresenceOption = .required,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, T: Collection, M: Collection<T.Element>>(
    _ targets: KeyPath<V, T>...,
    inclusion: M,
    presence: PresenceOption = .required,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, T: Collection, M: Collection<T.Element>>(
    _ targets: KeyPath<V, T?>...,
    inclusion: M,
    presence: PresenceOption = .required,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

// MARK: For `Range` and `ClosedRange`

@freestanding(declaration)
public macro Validation<V: Validatable, T, R: RangeExpression<T> & Collection<T>>(
    _ targets: KeyPath<V, T>...,
    inclusion: R,
    presence: PresenceOption = .required,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, T, R: RangeExpression<T> & Collection<T>>(
    _ targets: KeyPath<V, T?>...,
    inclusion: R,
    presence: PresenceOption = .required,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, T: Collection, R: RangeExpression<T.Element> & Collection<T.Element>>(
    _ targets: KeyPath<V, T>...,
    inclusion: R,
    presence: PresenceOption = .required,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, T: Collection, R: RangeExpression<T.Element> & Collection<T.Element>>(
    _ targets: KeyPath<V, T?>...,
    inclusion: R,
    presence: PresenceOption = .required,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

// MARK: For other ranges

@freestanding(declaration)
public macro Validation<V: Validatable, T, R: RangeExpression<T>>(
    _ targets: KeyPath<V, T>...,
    inclusion: R,
    presence: PresenceOption = .required,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, T, R: RangeExpression<T>>(
    _ targets: KeyPath<V, T?>...,
    inclusion: R,
    presence: PresenceOption = .required,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, T: Collection, R: RangeExpression<T.Element>>(
    _ targets: KeyPath<V, T>...,
    inclusion: R,
    presence: PresenceOption = .required,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, T: Collection, R: RangeExpression<T.Element>>(
    _ targets: KeyPath<V, T?>...,
    inclusion: R,
    presence: PresenceOption = .required,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

// MARK: - Exclusion

@freestanding(declaration)
public macro Validation<V: Validatable, T, M: Collection<T>>(
    _ targets: KeyPath<V, T>...,
    exclusion: M,
    presence: PresenceOption = .required,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, T, M: Collection<T>>(
    _ targets: KeyPath<V, T?>...,
    exclusion: M,
    presence: PresenceOption = .required,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, T: Collection, M: Collection<T.Element>>(
    _ targets: KeyPath<V, T>...,
    exclusion: M,
    presence: PresenceOption = .required,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, T: Collection, M: Collection<T.Element>>(
    _ targets: KeyPath<V, T?>...,
    exclusion: M,
    presence: PresenceOption = .required,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

// MARK: For `Range` and `ClosedRange`

@freestanding(declaration)
public macro Validation<V: Validatable, T, R: RangeExpression<T> & Collection<T>>(
    _ targets: KeyPath<V, T>...,
    exclusion: R,
    presence: PresenceOption = .required,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, T, R: RangeExpression<T> & Collection<T>>(
    _ targets: KeyPath<V, T?>...,
    exclusion: R,
    presence: PresenceOption = .required,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, T: Collection, R: RangeExpression<T.Element> & Collection<T.Element>>(
    _ targets: KeyPath<V, T>...,
    exclusion: R,
    presence: PresenceOption = .required,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, T: Collection, R: RangeExpression<T.Element> & Collection<T.Element>>(
    _ targets: KeyPath<V, T?>...,
    exclusion: R,
    presence: PresenceOption = .required,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

// MARK: For other ranges

@freestanding(declaration)
public macro Validation<V: Validatable, T, R: RangeExpression<T>>(
    _ targets: KeyPath<V, T>...,
    exclusion: R,
    presence: PresenceOption = .required,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, T, R: RangeExpression<T>>(
    _ targets: KeyPath<V, T?>...,
    exclusion: R,
    presence: PresenceOption = .required,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, T: Collection, R: RangeExpression<T.Element>>(
    _ targets: KeyPath<V, T>...,
    exclusion: R,
    presence: PresenceOption = .required,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, T: Collection, R: RangeExpression<T.Element>>(
    _ targets: KeyPath<V, T?>...,
    exclusion: R,
    presence: PresenceOption = .required,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

// MARK: - Count

@freestanding(declaration)
public macro Validation<V: Validatable, T: Collection, R: RangeExpression<Int>>(
    _ targets: KeyPath<V, T>...,
    countWithin: R,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, T: Collection, R: RangeExpression<Int>>(
    _ targets: KeyPath<V, T?>...,
    countWithin: R,
    allowsNil: Bool = false,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, T: Collection>(
    _ targets: KeyPath<V, T>...,
    countExact: Int,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, T: Collection>(
    _ targets: KeyPath<V, T?>...,
    countExact: Int,
    allowsNil: Bool = false,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

// MARK: - AnyOf

@freestanding(declaration)
public macro Validation<V: Validatable, T, K: Hashable & Sendable>(
    anyOf targets: KeyPath<V, T>...,
    errorKey: K,
    where: KeyPath<V, Bool>? = nil,
    @ValidatorBuilder pass: @escaping (T) -> any Validator
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, T>(
    anyOf targets: KeyPath<V, T>...,
    where: KeyPath<V, Bool>? = nil,
    @ValidatorBuilder pass: @escaping (T) -> any Validator
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, T, K: Hashable & Sendable>(
    anyOf targets: KeyPath<V, T?>...,
    errorKey: K,
    where: KeyPath<V, Bool>? = nil,
    @ValidatorBuilder pass: @escaping (T?) -> any Validator
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, T>(
    anyOf targets: KeyPath<V, T?>...,
    where: KeyPath<V, Bool>? = nil,
    @ValidatorBuilder pass: @escaping (T?) -> any Validator
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, T: Validator, K: Hashable & Sendable>(
    anyOf targets: KeyPath<V, T>...,
    errorKey: K,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, T: Validator>(
    anyOf targets: KeyPath<V, T>...,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, T: Validator, K: Hashable & Sendable>(
    anyOf targets: KeyPath<V, T?>...,
    errorKey: K,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

@freestanding(declaration)
public macro Validation<V: Validatable, T: Validator>(
    anyOf targets: KeyPath<V, T?>...,
    where: KeyPath<V, Bool>? = nil
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")

// MARK: - Custom Validator

@freestanding(declaration)
public macro Validation<V: Validatable, each T: Validator>(
    _ targets: repeat KeyPath<V, each T>
) = #externalMacro(module: "ValidationsMacros", type: "ValidationMacro")
