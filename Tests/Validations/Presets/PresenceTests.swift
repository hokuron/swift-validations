import Testing
@testable import Validations

@Suite
struct PresenceTests {
    @Test
    func notCollectionValue() {
        #expect(throws: Never.self) { try Presence(of: 2).validate() }
        #expect(throws: ValidationError.self) { try Presence(of: Int?.none).validate() }
    }

    @Test
    func nilNotCollectionValue() {
        #expect(throws: Never.self) { try Presence(of: Int?.none).allowsNil().validate() }
        #expect(throws: ValidationError.self) { try Presence(of: Int?.none).allowsNil(false).validate() }
    }

    @Test
    func string() {
        #expect(throws: Never.self) { try Presence(of: "123").validate() }
        #expect(throws: ValidationError.self) { try Presence(of: String?.none).validate() }
        #expect(throws: ValidationError.self) { try Presence(of: String?("")).validate() }
    }

    @Test
    func nilString() {
        #expect(throws: Never.self) { try Presence(of: String?.none).allowsNil().validate() }
        #expect(throws: Never.self) { try Presence(of: String?.none).allowsNil().allowsEmpty().validate() }
        #expect(throws: Never.self) { try Presence(of: String?.none).allowsNil().allowsEmpty(false).validate() }
        #expect(throws: ValidationError.self) { try Presence(of: String?.none).allowsNil(false).validate() }
        #expect(throws: ValidationError.self) { try Presence(of: String?.none).allowsNil(false).allowsEmpty().validate() }
        #expect(throws: ValidationError.self) { try Presence(of: String?.none).allowsNil(false).allowsEmpty(false).validate() }
    }

    @Test
    func emptyString() {
        #expect(throws: Never.self) { try Presence(of: "").allowsEmpty().validate() }
        #expect(throws: Never.self) { try Presence(of: "").allowsEmpty().allowsNil().validate() }
        #expect(throws: Never.self) { try Presence(of: "").allowsEmpty().allowsNil(false).validate() }
        #expect(throws: Never.self) { try Presence(of: String?("")).allowsEmpty().validate() }
        #expect(throws: Never.self) { try Presence(of: String?("")).allowsEmpty().allowsNil().validate() }
        #expect(throws: Never.self) { try Presence(of: String?("")).allowsEmpty().allowsNil(false).validate() }
        #expect(throws: ValidationError.self) { try Presence(of: "").allowsEmpty(false).validate() }
        #expect(throws: ValidationError.self) { try Presence(of: "").allowsEmpty(false).allowsNil().validate() }
        #expect(throws: ValidationError.self) { try Presence(of: "").allowsEmpty(false).allowsNil(false).validate() }
        #expect(throws: ValidationError.self) { try Presence(of: String?("")).allowsEmpty(false).validate() }
        #expect(throws: ValidationError.self) { try Presence(of: String?("")).allowsEmpty(false).allowsNil().validate() }
        #expect(throws: ValidationError.self) { try Presence(of: String?("")).allowsEmpty(false).allowsNil(false).validate() }
    }

    @Test
    func array() {
        #expect(throws: Never.self) { try Presence(of: [1, 2, 3]).validate() }
        #expect(throws: Never.self) { try Presence(of: [1, nil, 3]).validate() }
        #expect(throws: ValidationError.self) { try Presence(of: [Int]?.none).validate() }
        #expect(throws: ValidationError.self) { try Presence(of: [Int]?([])).validate() }
    }

    @Test
    func arrayWithNilElements() {
        #expect(throws: Never.self) { try Presence(of: [Int?]([nil, nil, nil])).validate() }
        #expect(throws: Never.self) { try Presence(of: [Int?]([nil, nil, nil])).allowsNil().allowsEmpty().validate() }
        #expect(throws: Never.self) { try Presence(of: [Int?]([nil, nil, nil])).allowsNil(false).allowsEmpty().validate() }
        #expect(throws: Never.self) { try Presence(of: [Int?]([nil, nil, nil])).allowsNil().allowsEmpty(false).validate() }
        #expect(throws: Never.self) { try Presence(of: [Int?]([nil, nil, nil])).allowsNil(false).allowsEmpty(false).validate() }
    }

    @Test
    func nilArray() {
        #expect(throws: Never.self) { try Presence(of: [Int]?.none).allowsNil().validate() }
        #expect(throws: Never.self) { try Presence(of: [Int]?.none).allowsNil().allowsEmpty().validate() }
        #expect(throws: Never.self) { try Presence(of: [Int]?.none).allowsNil().allowsEmpty(false).validate() }
        #expect(throws: ValidationError.self) { try Presence(of: [Int]?.none).allowsNil(false).validate() }
        #expect(throws: ValidationError.self) { try Presence(of: [Int]?.none).allowsNil(false).allowsEmpty().validate() }
        #expect(throws: ValidationError.self) { try Presence(of: [Int]?.none).allowsNil(false).allowsEmpty(false).validate() }
    }

    @Test
    func emptyArray() {
        #expect(throws: Never.self) { try Presence(of: [Int]([])).allowsEmpty().validate() }
        #expect(throws: Never.self) { try Presence(of: [Int]([])).allowsEmpty().allowsNil().validate() }
        #expect(throws: Never.self) { try Presence(of: [Int]([])).allowsEmpty().allowsNil(false).validate() }
        #expect(throws: Never.self) { try Presence(of: [Int?]([])).allowsEmpty().validate() }
        #expect(throws: Never.self) { try Presence(of: [Int?]([])).allowsEmpty().allowsNil().validate() }
        #expect(throws: Never.self) { try Presence(of: [Int?]([])).allowsEmpty().allowsNil(false).validate() }
        #expect(throws: ValidationError.self) { try Presence(of: [Int]([])).allowsEmpty(false).validate() }
        #expect(throws: ValidationError.self) { try Presence(of: [Int]([])).allowsEmpty(false).allowsNil().validate() }
        #expect(throws: ValidationError.self) { try Presence(of: [Int]([])).allowsEmpty(false).allowsNil(false).validate() }
        #expect(throws: ValidationError.self) { try Presence(of: [Int?]([])).allowsEmpty(false).validate() }
        #expect(throws: ValidationError.self) { try Presence(of: [Int?]([])).allowsEmpty(false).allowsNil().validate() }
        #expect(throws: ValidationError.self) { try Presence(of: [Int?]([])).allowsEmpty(false).allowsNil(false).validate() }
    }
}
