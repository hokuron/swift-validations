import Testing
@testable import Validations

@Suite
struct InclusionTests {
    private enum Test {
        case a, b, c
    }

    @Test
    func singleValue() {
        #expect(throws: Never.self) { try Inclusion(of: Test.a, in: [.a, .c]).validate() }
        #expect(throws: ValidationError.self) { try Inclusion(of: Test.a, in: [.b, .c]).validate() }
    }

    @Test
    func singleValueWithNil() {
        #expect(throws: ValidationError.self) { try Inclusion(of: Test?.none, in: [.b, .c]).validate() }
        #expect(throws: Never.self) { try Inclusion(of: Test?.none, in: [.b, .c]).allowsNil().validate() }
    }

    @Test
    func multipleValues() {
        #expect(throws: Never.self) { try Inclusion(of: [Test.a, .b], in: [.a, .b, .c]).validate() }
        #expect(throws: ValidationError.self) { try Inclusion(of: [Test.a, .b], in: [.a, .c]).validate() }
    }

    @Test
    func multipleValuesWithNil() {
        #expect(throws: ValidationError.self) { try Inclusion(of: [Test]?.none, in: [.a, .c]).validate() }
        #expect(throws: Never.self) { try Inclusion(of: [Test]?.none, in: [.a, .c]).allowsNil().validate() }
        #expect(throws: Never.self) { try Inclusion(of: [Test]?.none, in: [.a, .c]).allowsNil().allowsEmpty().validate() }
    }

    @Test
    func multipleValuesWithEmpty() {
        #expect(throws: ValidationError.self) { try Inclusion(of: [], in: [Test.a, .c]).validate() }
        #expect(throws: Never.self) { try Inclusion(of: [], in: [Test.a, .c]).allowsEmpty().validate() }
        #expect(throws: Never.self) { try Inclusion(of: [], in: [Test.a, .c]).allowsEmpty().allowsNil().validate() }
    }

    @Test
    func string() {
        #expect(throws: Never.self) { try Inclusion(of: "S", in: "Swift").validate() }
        #expect(throws: ValidationError.self) { try Inclusion(of: "s", in: "Swift").validate() }
        #expect(throws: Never.self) { try Inclusion(of: "if", in: "Swift").validate() }
        #expect(throws: ValidationError.self) { try Inclusion(of: "St", in: "Swift").validate() }
        #expect(throws: ValidationError.self) { try Inclusion(of: "ABC", in: "Swift").validate() }
    }

    @Test
    func stringWithNil() {
        #expect(throws: ValidationError.self) { try Inclusion(of: nil, in: "Swift").validate() }
        #expect(throws: Never.self) { try Inclusion(of: nil, in: "Swift").allowsNil().validate() }
        #expect(throws: Never.self) { try Inclusion(of: String?.none, in: "Swift").allowsNil().allowsEmpty().validate() }
    }

    @Test
    func stringWithEmpty() {
        #expect(throws: ValidationError.self) { try Inclusion(of: "", in: "Swift").validate() }
        #expect(throws: Never.self) { try Inclusion(of: "", in: "Swift").allowsEmpty().validate() }
        #expect(throws: Never.self) { try Inclusion(of: "", in: "Swift").allowsEmpty().allowsNil().validate() }
    }

    @Test
    func singleValueInRange() {
        #expect(throws: Never.self) { try Inclusion(of: 5, in: 4...).validate() }
        #expect(throws: Never.self) { try Inclusion(of: 5, in: 4...5).validate() }
        #expect(throws: ValidationError.self) { try Inclusion(of: 5, in: 2...4).validate() }
    }

    @Test
    func singleValueInRangeWithNil() {
        #expect(throws: ValidationError.self) { try Inclusion(of: nil, in: ...4).validate() }
        #expect(throws: ValidationError.self) { try Inclusion(of: nil, in: 2...4).validate() }
        #expect(throws: Never.self) { try Inclusion(of: nil, in: ...4).allowsNil().validate() }
        #expect(throws: Never.self) { try Inclusion(of: nil, in: 2..<4).allowsNil().validate() }
    }

    @Test
    func multipleValueInRange() {
        #expect(throws: Never.self) { try Inclusion(of: [2, 5], in: 2...).validate() }
        #expect(throws: Never.self) { try Inclusion(of: [2, 5], in: 2...5).validate() }
        #expect(throws: ValidationError.self) { try Inclusion(of: [2, 5], in: 3...).validate() }
        #expect(throws: ValidationError.self) { try Inclusion(of: [2, 5], in: 3..<5).validate() }
    }

    @Test
    func multipleValueInRangeWithNil() {
        #expect(throws: ValidationError.self) { try Inclusion(of: [Int]?.none, in: 0...).validate() }
        #expect(throws: ValidationError.self) { try Inclusion(of: [Int]?.none, in: 0...1).validate() }
        #expect(throws: Never.self) { try Inclusion(of: [Int]?.none, in: 0...).allowsNil().validate() }
        #expect(throws: Never.self) { try Inclusion(of: [Int]?.none, in: 0..<2).allowsNil().validate() }
        #expect(throws: Never.self) { try Inclusion(of: [Int]?.none, in: 0...).allowsNil().allowsEmpty().validate() }
        #expect(throws: Never.self) { try Inclusion(of: [Int]?.none, in: ...1).allowsNil().allowsEmpty().validate() }
    }

    @Test
    func multipleValueInRangeWithEmpty() {
        #expect(throws: ValidationError.self) { try Inclusion(of: [], in: 0...).validate() }
        #expect(throws: ValidationError.self) { try Inclusion(of: [], in: 0..<2).validate() }
        #expect(throws: Never.self) { try Inclusion(of: [], in: 0...).allowsEmpty().validate() }
        #expect(throws: Never.self) { try Inclusion(of: [], in: 0...3).allowsEmpty().validate() }
        #expect(throws: Never.self) { try Inclusion(of: [], in: 0...).allowsEmpty().allowsNil().validate() }
        #expect(throws: Never.self) { try Inclusion(of: [], in: 0..<2).allowsEmpty().allowsNil().validate() }
    }
}
