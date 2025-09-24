import Testing
import MacroTesting
import Validations
import ValidationsMacros

@Suite(.macros([ValidatableMacro.self]))
struct ValidationComparisonTests {
    @Validatable
    struct User {
        var age: Int
        var username: String
        var bio: String
        var url: String?
        var testScores: [Int]
        var averageRating: Double?
        var employeeID: Int?
        var isActive: Bool

        #Validation(\Self.age, comparison: .greaterThanOrEqualTo(13), presence: .required, where: \.isActive)
        #Validation(\Self.employeeID, comparison: .lessThan(1000), presence: .required(allowsNil: true), where: \.isActive)
        #Validation(\Self.username, \.bio, comparison: .greaterThanOrEqualTo("a"), presence: .required, where: \.isActive)
        #Validation(\Self.url, comparison: .greaterThanOrEqualTo("h"), presence: .none, where: \.isActive)
        #Validation(\Self.testScores, comparison: .greaterThanOrEqualTo([60, 70, 80]), presence: .required, where: \.isActive)
        #Validation(\Self.averageRating, equalTo: 4.5, presence: .none, where: \.isActive)
    }

    @Test func basic() {
        assertMacro {
            #"""
            @Validatable
            struct User {
                var age: Int
                var username: String
                var bio: String
                var url: String?
                var testScores: [Int]
                var averageRating: Double?
                var employeeID: Int?

                #Validation(\Self.age, comparison: .greaterThanOrEqualTo(13))
                #Validation(\Self.employeeID, comparison: .lessThan(1000))
                #Validation(\Self.username, \.bio, comparison: .greaterThanOrEqualTo("a"))
                #Validation(\Self.url, comparison: .greaterThanOrEqualTo("h"))
                #Validation(\Self.testScores, comparison: .greaterThanOrEqualTo([60, 70, 80]))
                #Validation(\Self.averageRating, equalTo: 4.5)
            }
            """#
        } expansion: {
            #"""
            struct User {
                var age: Int
                var username: String
                var bio: String
                var url: String?
                var testScores: [Int]
                var averageRating: Double?
                var employeeID: Int?

                #Validation(\Self.age, comparison: .greaterThanOrEqualTo(13))
                #Validation(\Self.employeeID, comparison: .lessThan(1000))
                #Validation(\Self.username, \.bio, comparison: .greaterThanOrEqualTo("a"))
                #Validation(\Self.url, comparison: .greaterThanOrEqualTo("h"))
                #Validation(\Self.testScores, comparison: .greaterThanOrEqualTo([60, 70, 80]))
                #Validation(\Self.averageRating, equalTo: 4.5)
            }

            extension User: Validations.Validatable {
                var validation: some Validator {
                    Comparison(of: self[keyPath: \Self.age], .greaterThanOrEqualTo(13)).errorKey(Self.self, \Self.age)
                    Comparison(of: self[keyPath: \Self.employeeID], .lessThan(1000)).errorKey(Self.self, \Self.employeeID)
                    Comparison(of: self[keyPath: \Self.username], .greaterThanOrEqualTo("a")).errorKey(Self.self, \Self.username)
                    Comparison(of: self[keyPath: \.bio], .greaterThanOrEqualTo("a")).errorKey(Self.self, \.bio)
                    Comparison(of: self[keyPath: \Self.url], .greaterThanOrEqualTo("h")).errorKey(Self.self, \Self.url)
                    Comparison(of: self[keyPath: \Self.testScores], .greaterThanOrEqualTo([60, 70, 80])).errorKey(Self.self, \Self.testScores)
                    Comparison(of: self[keyPath: \Self.averageRating], equalTo: 4.5).errorKey(Self.self, \Self.averageRating)
                }
            }
            """#
        }
    }

    @Test func withPresenceOption() {
        assertMacro {
            #"""
            @Validatable
            struct User {
                var age: Int
                var username: String
                var bio: String
                var url: String?
                var testScores: [Int]
                var averageRating: Double?
                var employeeID: Int?

                #Validation(\Self.age, comparison: .greaterThanOrEqualTo(13), presence: .required)
                #Validation(\Self.employeeID, comparison: .lessThan(1000), presence: .required(allowsNil: true))
                #Validation(\Self.username, \.bio, comparison: .greaterThanOrEqualTo("a"), presence: .required)
                #Validation(\Self.url, comparison: .greaterThanOrEqualTo("h"), presence: .none)
                #Validation(\Self.testScores, comparison: .greaterThanOrEqualTo([60, 70, 80]), presence: .required)
                #Validation(\Self.averageRating, equalTo: 4.5, presence: .none)
            }
            """#
        } expansion: {
            #"""
            struct User {
                var age: Int
                var username: String
                var bio: String
                var url: String?
                var testScores: [Int]
                var averageRating: Double?
                var employeeID: Int?

                #Validation(\Self.age, comparison: .greaterThanOrEqualTo(13), presence: .required)
                #Validation(\Self.employeeID, comparison: .lessThan(1000), presence: .required(allowsNil: true))
                #Validation(\Self.username, \.bio, comparison: .greaterThanOrEqualTo("a"), presence: .required)
                #Validation(\Self.url, comparison: .greaterThanOrEqualTo("h"), presence: .none)
                #Validation(\Self.testScores, comparison: .greaterThanOrEqualTo([60, 70, 80]), presence: .required)
                #Validation(\Self.averageRating, equalTo: 4.5, presence: .none)
            }

            extension User: Validations.Validatable {
                var validation: some Validator {
                    Comparison(of: self[keyPath: \Self.age], .greaterThanOrEqualTo(13)).presence(.required).errorKey(Self.self, \Self.age)
                    Comparison(of: self[keyPath: \Self.employeeID], .lessThan(1000)).presence(.required(allowsNil: true)).errorKey(Self.self, \Self.employeeID)
                    Comparison(of: self[keyPath: \Self.username], .greaterThanOrEqualTo("a")).presence(.required).errorKey(Self.self, \Self.username)
                    Comparison(of: self[keyPath: \.bio], .greaterThanOrEqualTo("a")).presence(.required).errorKey(Self.self, \.bio)
                    Comparison(of: self[keyPath: \Self.url], .greaterThanOrEqualTo("h")).presence(.none).errorKey(Self.self, \Self.url)
                    Comparison(of: self[keyPath: \Self.testScores], .greaterThanOrEqualTo([60, 70, 80])).presence(.required).errorKey(Self.self, \Self.testScores)
                    Comparison(of: self[keyPath: \Self.averageRating], equalTo: 4.5).presence(.none).errorKey(Self.self, \Self.averageRating)
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
                var age: Int
                var username: String
                var bio: String
                var url: String?
                var testScores: [Int]
                var averageRating: Double?
                var employeeID: Int?
                var isActive: Bool

                #Validation(\Self.age, comparison: .greaterThanOrEqualTo(13), presence: .required, where: \.isActive)
                #Validation(\Self.employeeID, comparison: .lessThan(1000), presence: .required(allowsNil: true), where: \.isActive)
                #Validation(\Self.username, \.bio, comparison: .greaterThanOrEqualTo("a"), presence: .required, where: \.isActive)
                #Validation(\Self.url, comparison: .greaterThanOrEqualTo("h"), presence: .none, where: \.isActive)
                #Validation(\Self.testScores, comparison: .greaterThanOrEqualTo([60, 70, 80]), presence: .required, where: \.isActive)
                #Validation(\Self.averageRating, equalTo: 4.5, presence: .none, where: \.isActive)
            }
            """#
        } expansion: {
            #"""
            struct User {
                var age: Int
                var username: String
                var bio: String
                var url: String?
                var testScores: [Int]
                var averageRating: Double?
                var employeeID: Int?
                var isActive: Bool

                #Validation(\Self.age, comparison: .greaterThanOrEqualTo(13), presence: .required, where: \.isActive)
                #Validation(\Self.employeeID, comparison: .lessThan(1000), presence: .required(allowsNil: true), where: \.isActive)
                #Validation(\Self.username, \.bio, comparison: .greaterThanOrEqualTo("a"), presence: .required, where: \.isActive)
                #Validation(\Self.url, comparison: .greaterThanOrEqualTo("h"), presence: .none, where: \.isActive)
                #Validation(\Self.testScores, comparison: .greaterThanOrEqualTo([60, 70, 80]), presence: .required, where: \.isActive)
                #Validation(\Self.averageRating, equalTo: 4.5, presence: .none, where: \.isActive)
            }

            extension User: Validations.Validatable {
                var validation: some Validator {
                    if self[keyPath: \.isActive] {
                        Comparison(of: self[keyPath: \Self.age], .greaterThanOrEqualTo(13)).presence(.required).errorKey(Self.self, \Self.age)
                    }
                    if self[keyPath: \.isActive] {
                        Comparison(of: self[keyPath: \Self.employeeID], .lessThan(1000)).presence(.required(allowsNil: true)).errorKey(Self.self, \Self.employeeID)
                    }
                    if self[keyPath: \.isActive] {
                        Comparison(of: self[keyPath: \Self.username], .greaterThanOrEqualTo("a")).presence(.required).errorKey(Self.self, \Self.username)
                        Comparison(of: self[keyPath: \.bio], .greaterThanOrEqualTo("a")).presence(.required).errorKey(Self.self, \.bio)
                    }
                    if self[keyPath: \.isActive] {
                        Comparison(of: self[keyPath: \Self.url], .greaterThanOrEqualTo("h")).presence(.none).errorKey(Self.self, \Self.url)
                    }
                    if self[keyPath: \.isActive] {
                        Comparison(of: self[keyPath: \Self.testScores], .greaterThanOrEqualTo([60, 70, 80])).presence(.required).errorKey(Self.self, \Self.testScores)
                    }
                    if self[keyPath: \.isActive] {
                        Comparison(of: self[keyPath: \Self.averageRating], equalTo: 4.5).presence(.none).errorKey(Self.self, \Self.averageRating)
                    }
                }
            }
            """#
        }
    }
}
