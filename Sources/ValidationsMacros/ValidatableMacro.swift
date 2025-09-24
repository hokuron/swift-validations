import Algorithms
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftBasicFormat

public struct ValidatableMacro: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        let validationArguments = validationArguments(in: declaration)

        if validationArguments.isEmpty {
            context.diagnose(
                Diagnostic(
                    node: Syntax(node),
                    message: MacroExpansionErrorMessage("'@Validatable' requires at least one '#Validation' macro as a member.")
                )
            )
        }

        let accessModifier = declaration.modifiers.first { [.keyword(.public), .keyword(.package)].contains($0.name.tokenKind) }
        let validationBody = validationBody(for: validationArguments)

        let decl: DeclSyntax = """
            extension \(type.trimmed): Validations.Validatable {
            \(accessModifier?.trimmed.with(\.trailingTrivia, .space))var validation: some Validator {
            \(validationBody.formatted())
            }
            }
            """
        let ext = decl.cast(ExtensionDeclSyntax.self)
        return [ext.with(\.attributes, declaration.attributes.availability ?? "")]
    }
    
    private static func validationArguments(in declaration: some DeclGroupSyntax) -> [ValidationMacroArgument] {
        declaration.memberBlock.members
            .compactMap { $0.decl.as(MacroExpansionDeclSyntax.self) }
            .filter { $0.macroName.text == "Validation" }
            .map { ValidationMacroArgument($0.arguments, trailingClosure: $0.trailingClosure) }
    }
    
    private static func validationBody(for arguments: [ValidationMacroArgument]) -> CodeBlockItemListSyntax {
        let body = arguments
            .compactMap { argument -> CodeBlockItemSyntax? in
                let validatorComponents: [ValidatorComponents]

                switch argument.validator {
                case .format(let expression):
                    validatorComponents = argument.keyPaths.map { keyPath in
                        ValidatorComponents(
                            body: "Format(of: self[keyPath: \(keyPath)], with: \(expression))",
                            modifiers: [
                                argument.presenceOption.map { "presence(\($0))" },
                                "errorKey(Self.self, \(keyPath))",
                            ]
                            .compactMap(\.self)
                        )
                    }
                case .inclusion(let expression):
                    validatorComponents = argument.keyPaths.map { keyPath in
                        ValidatorComponents(
                            body: "Inclusion(of: self[keyPath: \(keyPath)], in: \(expression))",
                            modifiers: [
                                argument.presenceOption.map { "presence(\($0))" },
                                "errorKey(Self.self, \(keyPath))",
                            ]
                            .compactMap(\.self)
                        )
                    }
                case .exclusion(let expression):
                    validatorComponents = argument.keyPaths.map { keyPath in
                        ValidatorComponents(
                            body: "Exclusion(of: self[keyPath: \(keyPath)], from: \(expression))",
                            modifiers: [
                                argument.presenceOption.map { "presence(\($0))" },
                                "errorKey(Self.self, \(keyPath))",
                            ]
                            .compactMap(\.self)
                        )
                    }
                case .comparison(.equalTo(let expression)):
                    validatorComponents = argument.keyPaths.map { keyPath in
                        ValidatorComponents(
                            body: "Comparison(of: self[keyPath: \(keyPath)], equalTo: \(expression))",
                            modifiers: [
                                argument.presenceOption.map { "presence(\($0))" },
                                "errorKey(Self.self, \(keyPath))",
                            ]
                            .compactMap(\.self)
                        )
                    }
                case .comparison(.any(let expression)):
                    validatorComponents = argument.keyPaths.map { keyPath in
                        ValidatorComponents(
                            body: "Comparison(of: self[keyPath: \(keyPath)], \(expression))",
                            modifiers: [
                                argument.presenceOption.map { "presence(\($0))" },
                                "errorKey(Self.self, \(keyPath))",
                            ]
                            .compactMap(\.self)
                        )
                    }
                case .count(.within(let expression)):
                    validatorComponents = argument.keyPaths.map { keyPath in
                        ValidatorComponents(
                            body: "Count(of: self[keyPath: \(keyPath)], within: \(expression))",
                            modifiers: [
                                argument.presenceOption.map { "allowsNil(\($0))" },
                                "errorKey(Self.self, \(keyPath))",
                            ]
                            .compactMap(\.self)
                        )
                    }
                case .count(.exact(let expression)):
                    validatorComponents = argument.keyPaths.map { keyPath in
                        ValidatorComponents(
                            body: "Count(of: self[keyPath: \(keyPath)], exact: \(expression))",
                            modifiers: [
                                argument.presenceOption.map { "allowsNil(\($0))" },
                                "errorKey(Self.self, \(keyPath))",
                            ]
                            .compactMap(\.self)
                        )
                    }
                case .presence(let expression):
                    validatorComponents = argument.keyPaths.map { keyPath in
                        ValidatorComponents(
                            body: "Presence(of: self[keyPath: \(keyPath)])",
                            modifiers: [
                                "presence(\(expression))",
                                "errorKey(Self.self, \(keyPath))",
                            ]
                        )
                    }
                case .absence:
                    validatorComponents = argument.keyPaths.map { keyPath in
                        ValidatorComponents(
                            body: "Absence(of: self[keyPath: \(keyPath)])",
                            modifiers: [
                                "errorKey(Self.self, \(keyPath))",
                            ]
                        )
                    }
                case .anyOf(let pass, let errorKey):
                    let firstArg: ExprSyntax = "[\(raw: argument.keyPaths.map { "self[keyPath: \($0)]" }.joined(separator: ", "))]"
                    let body = switch pass {
                    case .expression(let expr):
                        "AnyOf(\(firstArg), pass: \(expr))"
                    case .closure(let closure):
                        """
                        AnyOf(\(firstArg))\(closure)
                        """
                    case .none:
                        "AnyOf(\(firstArg))"
                    }
                    validatorComponents = [
                        ValidatorComponents(
                            body: body,
                            hasTrailingClosure: pass?.isClosure ?? false,
                            modifiers: [
                                errorKey.map { "errorKey(\($0))" },
                            ]
                            .compactMap(\.self)
                        )
                    ]
                case .custom:
                    validatorComponents = argument.keyPaths.map { keyPath in
                        ValidatorComponents(
                            body: "self[keyPath: \(keyPath)]",
                            modifiers: []
                        )
                    }
                case .unknown:
                    validatorComponents = []
                }

                guard !validatorComponents.isEmpty else { return nil }

                return if let condition = argument.condition {
                    """
                    if self[keyPath: \(condition)] {
                    \(raw: validatorComponents.map(\.description).joined(separator: "\n"))
                    }
                    """
                } else {
                    "\(raw: validatorComponents.map(\.description).joined(separator: "\n"))"
                }
            }

        return CodeBlockItemListSyntax(body)
    }
}

public struct ValidationMacro: DeclarationMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        return []
    }
}

struct ValidationMacroArgument {
    enum Validator {
        case format(ExprSyntax)
        case inclusion(ExprSyntax)
        case exclusion(ExprSyntax)
        case comparison(ComparisonOperator)
        case count(Count)
        case presence(ExprSyntax)
        case absence
        case anyOf(pass: AnyOfPass?, errorKey: ExprSyntax?)
        case custom
        case unknown(label: TokenSyntax)

        enum ComparisonOperator {
            case equalTo(ExprSyntax)
            case any(ExprSyntax)
        }

        enum Count {
            case within(ExprSyntax)
            case exact(ExprSyntax)
        }

        enum AnyOfPass {
            case expression(ExprSyntax)
            case closure(ClosureExprSyntax)

            var isClosure: Bool {
                if case .closure = self { return true }
                return false
            }
        }
    }

    var keyPaths: [ExprSyntax]
    var validator: Validator
    var presenceOption: ExprSyntax?
    var condition: ExprSyntax?

    init(_ allArguments: LabeledExprListSyntax, trailingClosure: ClosureExprSyntax?) {
        if allArguments.first!.label?.text == "anyOf" {
            let firstKeyPath = allArguments.first!.expression.trimmed
            let (remainingArguments, keyPaths) = allArguments.dropFirst().partitioned { $0.label == nil }
            self.keyPaths = [firstKeyPath] + keyPaths.map(\.expression.trimmed)

            var (pass, errorKey): (Validator.AnyOfPass?, ExprSyntax?)
            if let trailingClosure {
                pass = .closure(
                    trailingClosure
                        .with(
                            \.statements,
                             CodeBlockItemListSyntax(trailingClosure.statements.map(\.trimmed))
                                .formatted()
                                .cast(CodeBlockItemListSyntax.self)
                        )
                        .with(\.rightBrace, trailingClosure.rightBrace.trimmed)
                )
            }

            for argument in remainingArguments {
                switch argument.label!.text {
                case "pass":
                    assert(pass == nil)
                    pass = .expression(argument.expression.trimmed)
                case "errorKey":
                    errorKey = argument.expression.trimmed
                case "where":
                    self.condition = argument.expression.trimmed
                default:
                    continue
                }
            }

            self.validator = .anyOf(pass: pass, errorKey: errorKey)
        } else {
            let (arguments, keyPaths) = allArguments.partitioned { $0.label == nil }
            self.keyPaths = keyPaths.map(\.expression.trimmed)

            if arguments.isEmpty {
                self.validator = .custom
                return
            }

            let firstArgument = arguments[0]
            self.validator = switch firstArgument.label!.text {
            case "format":
                .format(firstArgument.expression.trimmed)
            case "inclusion":
                .inclusion(firstArgument.expression.trimmed)
            case "exclusion":
                .exclusion(firstArgument.expression.trimmed)
            case "comparison":
                .comparison(.any(firstArgument.expression.trimmed))
            case "equalTo":
                .comparison(.equalTo(firstArgument.expression.trimmed))
            case "countWithin":
                .count(.within(firstArgument.expression.trimmed))
            case "countExact":
                .count(.exact(firstArgument.expression.trimmed))
            case "presence":
                .presence(firstArgument.expression.trimmed)
            case "absence":
                .absence
            default:
                .unknown(label: firstArgument.label!)
            }

            for argument in arguments.dropFirst() {
                switch argument.label!.text {
                case "presence":
                    assert(self.presenceOption == nil)
                    self.presenceOption = argument.expression.trimmed
                case "allowsNil":
                    assert(self.presenceOption == nil)
                    self.presenceOption = argument.expression.trimmed
                case "where":
                    self.condition = argument.expression.trimmed
                default:
                    continue
                }
            }
        }
    }
}

struct ValidatorComponents {
    var body: String
    var hasTrailingClosure = false
    var modifiers: [String]

    var description: String {
        let modifiers = modifiers.joined(separator: ".")

        return if hasTrailingClosure {
            "\(body)\(modifiers.isEmpty ? "" : "\n." + modifiers)"
        } else {
            // FIXME: Method chains should ideally be formatted with line breaks and proper indentation.
            "\(body)\(modifiers.isEmpty ? "" : "." + modifiers)"
        }
    }

    var codeBlockItem: CodeBlockItemSyntax {
        let modifiers = modifiers.joined(separator: ".")

        return if hasTrailingClosure {
            "\(raw: body)\(raw: modifiers.isEmpty ? "" : "\n." + modifiers)"
        } else {
            // FIXME: Method chains should ideally be formatted with line breaks and proper indentation.
            "\(raw: body)\(raw: modifiers.isEmpty ? "" : "." + modifiers)"
        }
    }
}
