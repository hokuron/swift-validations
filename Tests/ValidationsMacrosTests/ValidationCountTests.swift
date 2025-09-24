import Testing
import MacroTesting
import Validations
import ValidationsMacros

@Suite(.macros([ValidatableMacro.self]))
struct ValidationCountTests {
    @Validatable
    struct User {
        var tags: [String]
        var scores: [Int]?
        var nicknames: Set<String>
        var metadata: [String: Any]?
        var ratings: [Double]
        var categories: Set<String>?
        var isActive: Bool

        #Validation(\Self.tags, countWithin: 1...5, where: \.isActive)
        #Validation(\Self.scores, countExact: 3, allowsNil: true, where: \.isActive)
        #Validation(\Self.nicknames, countWithin: 2..<10, where: \.isActive)
        #Validation(\Self.metadata, countWithin: ...100, allowsNil: false, where: \.isActive)
        #Validation(\Self.ratings, countWithin: 3..., where: \.isActive)
        #Validation(\Self.categories, countWithin: ..<50, allowsNil: true, where: \.isActive)
    }

    @Test func basic() {
        assertMacro {
            #"""
            @Validatable
            struct User {
                var tags: [String]
                var categories: [String]
                var scores: [Int]?
                var ratings: [Double]?
                var nicknames: Set<String>
                var metadata: [String: Any]?
                var partialThrough: [String]
                var partialFrom: [String]
                var partialUpTo: [String]

                #Validation(\Self.tags, \Self.categories, countWithin: 1...5)
                #Validation(\Self.scores, countExact: 3)
                #Validation(\Self.ratings, countWithin: 2..<10)
                #Validation(\Self.nicknames, \Self.metadata, \Self.partialThrough, countWithin: ...100)
                #Validation(\Self.partialFrom, countWithin: 3...)
                #Validation(\Self.partialUpTo, countWithin: ..<50)
            }
            """#
        } expansion: {
            #"""
            struct User {
                var tags: [String]
                var categories: [String]
                var scores: [Int]?
                var ratings: [Double]?
                var nicknames: Set<String>
                var metadata: [String: Any]?
                var partialThrough: [String]
                var partialFrom: [String]
                var partialUpTo: [String]

                #Validation(\Self.tags, \Self.categories, countWithin: 1...5)
                #Validation(\Self.scores, countExact: 3)
                #Validation(\Self.ratings, countWithin: 2..<10)
                #Validation(\Self.nicknames, \Self.metadata, \Self.partialThrough, countWithin: ...100)
                #Validation(\Self.partialFrom, countWithin: 3...)
                #Validation(\Self.partialUpTo, countWithin: ..<50)
            }

            extension User: Validations.Validatable {
                var validation: some Validator {
                    Count(of: self[keyPath: \Self.tags], within: 1 ... 5).errorKey(Self.self, \Self.tags)
                    Count(of: self[keyPath: \Self.categories], within: 1 ... 5).errorKey(Self.self, \Self.categories)
                    Count(of: self[keyPath: \Self.scores], exact: 3).errorKey(Self.self, \Self.scores)
                    Count(of: self[keyPath: \Self.ratings], within: 2 ..< 10).errorKey(Self.self, \Self.ratings)
                    Count(of: self[keyPath: \Self.nicknames], within: ...100).errorKey(Self.self, \Self.nicknames)
                    Count(of: self[keyPath: \Self.metadata], within: ...100).errorKey(Self.self, \Self.metadata)
                    Count(of: self[keyPath: \Self.partialThrough], within: ...100).errorKey(Self.self, \Self.partialThrough)
                    Count(of: self[keyPath: \Self.partialFrom], within: 3...).errorKey(Self.self, \Self.partialFrom)
                    Count(of: self[keyPath: \Self.partialUpTo], within: ..<50).errorKey(Self.self, \Self.partialUpTo)
                }
            }
            """#
        }
    }

    @Test func withAllowsNil() {
        assertMacro {
            #"""
            @Validatable
            struct User {
                var tags: [String]?
                var categories: [String]?
                var scores: [Int]?
                var ratings: [Double]?
                var nicknames: Set<String>?
                var metadata: [String: Any]?
                var partialFrom: [String]?
                var partialUpTo: [String]?

                #Validation(\Self.tags, \Self.categories, countWithin: 1...5, allowsNil: false)
                #Validation(\Self.scores, \Self.ratings, countExact: 3, allowsNil: true)
                #Validation(\Self.nicknames, countWithin: 2..<10, allowsNil: false)
                #Validation(\Self.metadata, countWithin: ...100, allowsNil: true)
                #Validation(\Self.partialFrom, countWithin: 3..., allowsNil: false)
                #Validation(\Self.partialUpTo, countWithin: ..<50, allowsNil: true)
            }
            """#
        } expansion: {
            #"""
            struct User {
                var tags: [String]?
                var categories: [String]?
                var scores: [Int]?
                var ratings: [Double]?
                var nicknames: Set<String>?
                var metadata: [String: Any]?
                var partialFrom: [String]?
                var partialUpTo: [String]?

                #Validation(\Self.tags, \Self.categories, countWithin: 1...5, allowsNil: false)
                #Validation(\Self.scores, \Self.ratings, countExact: 3, allowsNil: true)
                #Validation(\Self.nicknames, countWithin: 2..<10, allowsNil: false)
                #Validation(\Self.metadata, countWithin: ...100, allowsNil: true)
                #Validation(\Self.partialFrom, countWithin: 3..., allowsNil: false)
                #Validation(\Self.partialUpTo, countWithin: ..<50, allowsNil: true)
            }

            extension User: Validations.Validatable {
                var validation: some Validator {
                    Count(of: self[keyPath: \Self.tags], within: 1 ... 5).allowsNil(false).errorKey(Self.self, \Self.tags)
                    Count(of: self[keyPath: \Self.categories], within: 1 ... 5).allowsNil(false).errorKey(Self.self, \Self.categories)
                    Count(of: self[keyPath: \Self.scores], exact: 3).allowsNil(true).errorKey(Self.self, \Self.scores)
                    Count(of: self[keyPath: \Self.ratings], exact: 3).allowsNil(true).errorKey(Self.self, \Self.ratings)
                    Count(of: self[keyPath: \Self.nicknames], within: 2 ..< 10).allowsNil(false).errorKey(Self.self, \Self.nicknames)
                    Count(of: self[keyPath: \Self.metadata], within: ...100).allowsNil(true).errorKey(Self.self, \Self.metadata)
                    Count(of: self[keyPath: \Self.partialFrom], within: 3...).allowsNil(false).errorKey(Self.self, \Self.partialFrom)
                    Count(of: self[keyPath: \Self.partialUpTo], within: ..<50).allowsNil(true).errorKey(Self.self, \Self.partialUpTo)
                }
            }
            """#
        }
    }

    @Test func withCondition() {
        assertMacro {
            #"""
            @Validatable
            struct User {
                var tags: [String]
                var categories: [String]
                var scores: [Int]?
                var ratings: [Double]?
                var nicknames: Set<String>
                var metadata: [String: Any]?
                var partialFrom: [String]
                var partialUpTo: [String]?
                var isActive: Bool

                #Validation(\Self.tags, \Self.categories, countWithin: 1...5, where: \.isActive)
                #Validation(\Self.scores, countExact: 3, allowsNil: true, where: \.isActive)
                #Validation(\Self.ratings, countWithin: 2..<10, allowsNil: false, where: \.isActive)
                #Validation(\Self.nicknames, \Self.metadata, countWithin: ...100, where: \.isActive)
                #Validation(\Self.partialFrom, countWithin: 3..., where: \.isActive)
                #Validation(\Self.partialUpTo, countWithin: ..<50, allowsNil: true, where: \.isActive)
            }
            """#
        } expansion: {
            #"""
            struct User {
                var tags: [String]
                var categories: [String]
                var scores: [Int]?
                var ratings: [Double]?
                var nicknames: Set<String>
                var metadata: [String: Any]?
                var partialFrom: [String]
                var partialUpTo: [String]?
                var isActive: Bool

                #Validation(\Self.tags, \Self.categories, countWithin: 1...5, where: \.isActive)
                #Validation(\Self.scores, countExact: 3, allowsNil: true, where: \.isActive)
                #Validation(\Self.ratings, countWithin: 2..<10, allowsNil: false, where: \.isActive)
                #Validation(\Self.nicknames, \Self.metadata, countWithin: ...100, where: \.isActive)
                #Validation(\Self.partialFrom, countWithin: 3..., where: \.isActive)
                #Validation(\Self.partialUpTo, countWithin: ..<50, allowsNil: true, where: \.isActive)
            }

            extension User: Validations.Validatable {
                var validation: some Validator {
                    if self[keyPath: \.isActive] {
                        Count(of: self[keyPath: \Self.tags], within: 1 ... 5).errorKey(Self.self, \Self.tags)
                        Count(of: self[keyPath: \Self.categories], within: 1 ... 5).errorKey(Self.self, \Self.categories)
                    }
                    if self[keyPath: \.isActive] {
                        Count(of: self[keyPath: \Self.scores], exact: 3).allowsNil(true).errorKey(Self.self, \Self.scores)
                    }
                    if self[keyPath: \.isActive] {
                        Count(of: self[keyPath: \Self.ratings], within: 2 ..< 10).allowsNil(false).errorKey(Self.self, \Self.ratings)
                    }
                    if self[keyPath: \.isActive] {
                        Count(of: self[keyPath: \Self.nicknames], within: ...100).errorKey(Self.self, \Self.nicknames)
                        Count(of: self[keyPath: \Self.metadata], within: ...100).errorKey(Self.self, \Self.metadata)
                    }
                    if self[keyPath: \.isActive] {
                        Count(of: self[keyPath: \Self.partialFrom], within: 3...).errorKey(Self.self, \Self.partialFrom)
                    }
                    if self[keyPath: \.isActive] {
                        Count(of: self[keyPath: \Self.partialUpTo], within: ..<50).allowsNil(true).errorKey(Self.self, \Self.partialUpTo)
                    }
                }
            }
            """#
        }
    }
}
