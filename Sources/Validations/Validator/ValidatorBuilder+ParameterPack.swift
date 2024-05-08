//// TODO: _TupleValidatorや_ConditionalValidatorをArray<any Validator>で置き換えられないか検証。
//
//@resultBuilder
//public enum ValidatorBuilder {
//    public static func buildExpression<V: Validator>(_ validator: V) -> V {
//        validator
//    }
//
//    public static func buildBlock<V: Validator>(_ validator: V) -> V {
//        validator
//    }
//
//    @_disfavoredOverload
//    public static func buildBlock<each V: Validator>(_ validator: repeat each V) -> _TupleValidator<(repeat each V)> {
//        let a = _TupleValidator((repeat each validator))
//        f(a)
//        return a
//    }
//
//    public static func buildOptional<V: Validator>(_ validator: V?) -> V? {
//        validator
//    }
//
//    public static func buildEither<V1: Validator, V2: Validator>(first: V1) -> _ConditionalValidator<V1, V2> {
//        _ConditionalValidator(storage: .first(first))
//    }
//
//    public static func buildEither<V1: Validator, V2: Validator>(second: V2) -> _ConditionalValidator<V1, V2> {
//        _ConditionalValidator(storage: .second(second))
//    }
//
//    public static func buildLimitedAvailability<V: Validator>(_ validator: V) -> Validate {
//        Validate(validator)
//    }
//
//    public struct _TupleValidator<T>: Validator {
//        var value: T
//
//        init<each U>(_ value: repeat each U) {
//            repeat print("🍎", each value)
////            self.value = repeat each value
//        }
//
//        public func validate() throws {
////            validateEach(for: self)
////            g1(t: self)
//        }
//
////        private func validateEach<each U>(for tuple: _TupleValidator<(repeat each U)>) throws {
////            print(type(of: tuple.value))
////            func perform<S>(with s: S, errors: inout [ValidationError]) {
////                print(type(of: s))
////                guard let s = s as? any Validator else {
////                    preconditionFailure("Type parameter `T` of _TupleValidator must conform to `Validator` protocol: \(S.self)")
////                }
////
////                do {
////                    try s.validate()
////                } catch let error as ValidationError {
////                    errors.append(error)
////                } catch {
////                    preconditionFailure("Unknown error: \(error)")
////                }
////            }
////
////            var errors = [ValidationError]()
////            repeat perform(with: each tuple.value, errors: &errors)
////        }
//    }
//
//    private static func g1<each T>(t: _TupleValidator<(repeat each T)>) {
//        print(type(of: t.value))
//        func p<U>(_ u: U) {
//            if let v = u as? any Validator {
//                print("👺", v)
//            }
//            print(type(of: u), terminator: " ")
//        }
//        repeat p(each t.value)
//        print()
//    }
//
//    public struct _ConditionalValidator<V1: Validator, V2: Validator>: Validator {
//        enum Storage {
//            case first(V1)
//            case second(V2)
//        }
//
//        let storage: Storage
//
//        public func validate() throws {
//            switch storage {
//            case .first(let validator):
//                try validator.validate()
//            case .second(let validator):
//                try validator.validate()
//            }
//        }
//    }
//}
//
//private func f<T>(_ tuple: ValidatorBuilder._TupleValidator<T>, line: UInt = #line) {
//    func g<each U>(_ u: (repeat each U)) {
//        repeat print(each u)
//    }
//
//    g(tuple.value)
//}
//
//private func validateEach2<each T>(validator: (repeat each T)) {
//    func validate<U>(with validate: U) {
//        guard let validator = validator as? any Validator else {
//            preconditionFailure("Type parameter `T` of _TupleValidator must conform to `Validator` protocol: \(U.self)")
//        }
//
//        try? validator.validate()
//    }
//}
//
//private func validateEach<each T>(for tuple: ValidatorBuilder._TupleValidator<(repeat each T)>, line: UInt = #line) {
//    func perform<V>(with validator: V) {
//        guard let validator = validator as? any Validator else {
//            preconditionFailure("line: \(line); Type parameter `T` of _TupleValidator must conform to `Validator` protocol: \(V.self)")
//        }
//
//        do {
//            try validator.validate()
//        } catch let error as ValidationError {
//            //                errors.append(error)
//        } catch {
//            //                preconditionFailure("Unknown error: \(error)")
//        }
//        print("✅", line)
//    }
//
//    print("🍎", tuple.value)
//    repeat perform(with: each tuple.value)
//}
//
//struct S: Validator {
//    var name: String?
//    var numbers: [Int?]
//
//    var validation: some Validator {
//        Presence(name)
//        if let name {
//            Count(name, exact: 2)
//        }
//
//        if #available(iOS 17.0, *), let name {
//            Count(name, exact: 2)
//            Count(name, exact: 2)
//        } else {
//            Count(numbers, exact: 2)
//        }
//
//        if true {
//            Count(numbers, exact: 2)
//        }
//    }
//}
//
//
////extension Validator {
////    public static func presence() -> PresenceValidator<Value> {
////        KeyPathValidator(keyPath, using: PresenceValidator())
////    }
////}
