import Testing
@testable import Validations

@Suite
struct ConfirmationTests {
    @Test
    func notCollection() {
        #expect(throws: Never.self) { try Confirmation(of: nil, matching: 1).validate() }
        #expect(throws: ValidationError.self) { try Confirmation(of: nil, matching: 1).presence(.required).validate() }
    }

    @Test
    func stringWithoutPresenceOptions() {
        #expect(throws: Never.self) { try Confirmation(of: nil, matching: "123").validate() }
        #expect(throws: Never.self) { try Confirmation(of: "", matching: "123").validate() }
        #expect(throws: Never.self) { try Confirmation(of: "123", matching: "123").validate() }
    }

    @Test
    func stringWithPresenceNilDisallowed() {
        #expect(throws: ValidationError.self) { try Confirmation(of: nil, matching: "123").presence(.required(allowsEmpty: true)).validate() }
        #expect(throws: ValidationError.self) { try Confirmation(of: nil, matching: "").presence(.required(allowsEmpty: true)).validate() }
        #expect(throws: Never.self) { try Confirmation(of: "", matching: "123").presence(.required(allowsEmpty: true)).validate() }
        #expect(throws: Never.self) { try Confirmation(of: "", matching: "").presence(.required(allowsEmpty: true)).validate() }
        #expect(throws: Never.self) { try Confirmation(of: "123", matching: "123").presence(.required(allowsEmpty: true)).validate() }
    }

    @Test
    func stringWithPresenceEmptyDisallowed() {
        #expect(throws: Never.self) { try Confirmation(of: nil, matching: "123").presence(.required(allowsNil: true)).validate() }
        #expect(throws: Never.self) { try Confirmation(of: nil, matching: "").presence(.required(allowsNil: true)).validate() }
        #expect(throws: ValidationError.self) { try Confirmation(of: "", matching: "123").presence(.required(allowsNil: true)).validate() }
        #expect(throws: ValidationError.self) { try Confirmation(of: "", matching: "").presence(.required(allowsNil: true)).validate() }
        #expect(throws: Never.self) { try Confirmation(of: "123", matching: "123").presence(.required(allowsNil: true)).validate() }
    }

    @Test
    func stringWithPresenceBothDisallowed() {
        #expect(throws: ValidationError.self) { try Confirmation(of: nil, matching: "123").presence(.required).validate() }
        #expect(throws: ValidationError.self) { try Confirmation(of: nil, matching: "").presence(.required).validate() }
        #expect(throws: ValidationError.self) { try Confirmation(of: "", matching: "123").presence(.required).validate() }
        #expect(throws: ValidationError.self) { try Confirmation(of: "", matching: "").presence(.required).validate() }
        #expect(throws: Never.self) { try Confirmation(of: "123", matching: "123").presence(.required).validate() }
    }

    @Test
    func arrayWithoutPresenceOptions() {
        #expect(throws: Never.self) { try Confirmation(of: nil, matching: [1, 2, 3]).validate() }
        #expect(throws: Never.self) { try Confirmation(of: [], matching: [1, 2, 3]).validate() }
        #expect(throws: ValidationError.self) { try Confirmation(of: [1, nil, 3], matching: [1, 2, 3]).validate() }
        #expect(throws: Never.self) { try Confirmation(of: [1, 2, 3], matching: [1, 2, 3]).validate() }
        #expect(throws: Never.self) { try Confirmation(of: [Int](), matching: []).validate() }
    }

    @Test
    func arrayWithPresenceNilDisallowed() {
        #expect(throws: ValidationError.self) { try Confirmation(of: nil, matching: [1, 2, 3]).presence(.required(allowsEmpty: true)).validate() }
        #expect(throws: Never.self) { try Confirmation(of: [], matching: [1, 2, 3]).presence(.required(allowsEmpty: true)).validate() }
        #expect(throws: ValidationError.self) { try Confirmation(of: [1, nil, 3], matching: [1, 2, 3]).presence(.required(allowsEmpty: true)).validate() }
        #expect(throws: Never.self) { try Confirmation(of: [1, 2, 3], matching: [1, 2, 3]).presence(.required(allowsEmpty: true)).validate() }
        #expect(throws: Never.self) { try Confirmation(of: [Int](), matching: []).presence(.required(allowsEmpty: true)).validate() }
    }

    @Test
    func arrayWithPresenceEmptyDisallowed() {
        #expect(throws: Never.self) { try Confirmation(of: nil, matching: [1, 2, 3]).presence(.required(allowsNil: true)).validate() }
        #expect(throws: ValidationError.self) { try Confirmation(of: [], matching: [1, 2, 3]).presence(.required(allowsNil: true)).validate() }
        #expect(throws: ValidationError.self) { try Confirmation(of: [1, nil, 3], matching: [1, 2, 3]).presence(.required(allowsNil: true)).validate() }
        #expect(throws: Never.self) { try Confirmation(of: [1, 2, 3], matching: [1, 2, 3]).presence(.required(allowsNil: true)).validate() }
        #expect(throws: ValidationError.self) { try Confirmation(of: [Int](), matching: []).presence(.required(allowsNil: true)).validate() }
    }

    @Test
    func arrayWithPresenceBothDisallowed() {
        #expect(throws: ValidationError.self) { try Confirmation(of: nil, matching: [1, 2, 3]).presence(.required).validate() }
        #expect(throws: ValidationError.self) { try Confirmation(of: [], matching: [1, 2, 3]).presence(.required).validate() }
        #expect(throws: ValidationError.self) { try Confirmation(of: [1, nil, 3], matching: [1, 2, 3]).presence(.required).validate() }
        #expect(throws: Never.self) { try Confirmation(of: [1, 2, 3], matching: [1, 2, 3]).presence(.required).validate() }
        #expect(throws: ValidationError.self) { try Confirmation(of: [Int](), matching: []).presence(.required).validate() }
    }

    @Test
    func sourceValueAbsence() {
        #expect(throws: ValidationError.self) { try Confirmation(of: 1, matching: nil).validate() }
        #expect(throws: ValidationError.self) { try Confirmation(of: "123", matching: "").validate() }
        #expect(throws: Never.self) { try Confirmation(of: "", matching: "").validate() }
        #expect(throws: Never.self) { try Confirmation(of: Int?.none, matching: Int?.none).validate() }
        #expect(throws: ValidationError.self) { try Confirmation(of: "", matching: "").presence(.required).validate() }
        #expect(throws: ValidationError.self) { try Confirmation(of: Int?.none, matching: Int?.none).presence(.required).validate() }
    }
}
