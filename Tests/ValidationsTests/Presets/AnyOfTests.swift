import Testing
@testable import Validations

@Suite
struct AnyOfTests {
    @Test
    func success() {
        #expect(throws: Never.self) {
            try AnyOf(["123", "456789"]) {
                Presence(of: $0)
                Count(of: $0, within: 3...)
            }
            .validate()
        }
        #expect(throws: Never.self) {
            try AnyOf(["", "456789"]) {
                Presence(of: $0)
                Count(of: $0, within: 3...)
            }
            .validate()
        }
        #expect(throws: Never.self) {
            try AnyOf(["123", ""]) {
                Presence(of: $0)
                Count(of: $0, within: 3...)
            }
            .validate()
        }
    }

    @Test
    func failure() {
        #expect(throws: ValidationErrors.self) {
            try AnyOf(["123", "456789"]) {
                Presence(of: $0)
                Count(of: $0, exact: 2)
            }
            .validate()
        }
        #expect(throws: ValidationErrors.self) {
            try AnyOf(["", "456789"]) {
                Presence(of: $0)
                Count(of: $0, exact: 2)
            }
            .validate()
        }
        #expect(throws: ValidationErrors.self) {
            try AnyOf(["123", ""]) {
                Presence(of: $0)
                Count(of: $0, exact: 2)
            }
            .validate()
        }
    }

    @Test
    func emptyValues() {
        #expect(throws: Never.self) { try AnyOf([String](), pass: Presence.init).validate() }
    }

    @Test
    func initWithValidatorValues() {
        struct Value: Validator {
            var validation: some Validator { Presence(of: "") }
        }

        #expect(throws: ValidationErrors.self) { try AnyOf([Value(), Value()]).validate() }
    }

    @Test
    func initWithKeyPath() {
        struct Value {
            var inner: Inner

            struct Inner: Validator {
                var value: String
                var validation: some Validator { Presence(of: value) }
            }
        }

        #expect(throws: Never.self) { try AnyOf([Value(inner: .init(value: "")), Value(inner: .init(value: "A"))], pass: \.inner).validate() }
    }

    @Test
    func outerErrorKey() {
        let errorKey = "ErrorKey"
        let sut = AnyOf(["", ""]) {
            Presence(of: $0)
            Count(of: $0, exact: 2)
        }
        .errorKey(errorKey)

        #expect(sut.validationErrors?.errors == sut.validationErrors?[errorKey])
        #expect(sut.validationErrors?.reasons(for: errorKey) == [.empty, .count, .empty, .count])
    }

    @Test
    func innerErrorKey() {
        let errorKey1 = "ErrorKey1"
        let errorKey2 = "ErrorKey2"
        let sut = AnyOf(["", ""]) {
            Presence(of: $0)
                .errorKey(errorKey1)
            Count(of: $0, exact: 2)
                .errorKey(errorKey2)
        }

        #expect(sut.validationErrors?.count == 4)
        #expect(sut.validationErrors?.errors.map(\.reasons) == [.empty, .count, .empty, .count])

        #expect(sut.validationErrors?[errorKey1].count == 2)
        #expect(sut.validationErrors?.reasons(for: errorKey1) == [.empty])

        #expect(sut.validationErrors?[errorKey2].count == 2)
        #expect(sut.validationErrors?.reasons(for: errorKey2) == [.count])
    }

    @Test
    func outerAndInnerErrorKey() {
        let outerErrorKey = "OuterErrorKey"
        let innerErrorKey1 = "InnerErrorKey1"
        let innerErrorKey2 = "InnerErrorKey2"
        let sut = AnyOf(["", ""]) {
            Presence(of: $0)
                .errorKey(innerErrorKey1)
            Count(of: $0, exact: 2)
                .errorKey(innerErrorKey2)
        }
        .errorKey(outerErrorKey)

        // The appropriateness of this behavior is open to discussion.
        #expect(sut.validationErrors?[outerErrorKey].count == 0)

        #expect(sut.validationErrors?[innerErrorKey1].count == 2)
        #expect(sut.validationErrors?.reasons(for: innerErrorKey1) == [.empty])

        #expect(sut.validationErrors?[innerErrorKey2].count == 2)
        #expect(sut.validationErrors?.reasons(for: innerErrorKey2) == [.count])
    }
}
