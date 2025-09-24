import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct ValidationsMacrosPlugin: CompilerPlugin {
    let providingMacros: [any Macro.Type] = [
        ValidatableMacro.self,
        ValidationMacro.self,
    ]
}
