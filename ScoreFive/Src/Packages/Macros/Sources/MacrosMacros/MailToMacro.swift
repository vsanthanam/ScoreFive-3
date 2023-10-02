// ScoreFive
// MailToMacro.swift
//
// MIT License
//
// Copyright (c) 2021 Varun Santhanam
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the  Software), to deal
//
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct MailToMacro: ExpressionMacro {

    // MARK: - ExpressionMacro

    public static func expansion<Node, Context>(
        of node: Node,
        in context: Context
    ) throws -> ExprSyntax where Node: FreestandingMacroExpansionSyntax, Context: MacroExpansionContext {
        guard let argument = node.argumentList.first?.expression,
              let segments = argument.as(StringLiteralExprSyntax.self)?.segments,
              segments.count == 1,
              case let .stringSegment(literal) = segments.first else {
            throw MacroError("The #mailTo macro requires a single string literal argument")
        }
        guard literal.content.text.isValidEmail else {
            throw MacroError("The provided value \(argument) is invalid")
        }
        return "URL(string: \"mailto:\(raw: literal.content.text)\")!"

    }

}

private extension String {
    var isValidEmail: Bool {
        let link = "mailto:\(self)"
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        guard let match = detector.firstMatch(in: link, options: [], range: NSRange(location: 0, length: link.utf16.count)) else {
            return false
        }
        return match.range.length == link.utf16.count
    }
}
