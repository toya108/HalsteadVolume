import Accelerate
import SwiftSyntax
import SwiftSyntaxParser

let source = """

"""

private class OperatorUsageWhitespaceVisitor: SyntaxVisitor {

    var operators: [String] = []
    var distinctOperators: Set<String> {
        Set(operators)
    }
    var operands: [String] = []
    var distinctOperands: Set<String> {
        Set(operands)
    }

    var cyclomaticComplecity = 1

    override func visit(_ node: TokenSyntax) -> SyntaxVisitorContinueKind {
        switch node.tokenKind {
            case .spacedBinaryOperator:
                operators.append(node.text)
            case .unspacedBinaryOperator:
                operators.append(node.text)
            case .ifKeyword, .switchKeyword, .forKeyword, .whileKeyword, .guardKeyword, .caseKeyword, .repeatKeyword:
                cyclomaticComplecity += 1
            case .identifier(let identifier):
                if identifier == "forEach" {
                    cyclomaticComplecity += 1
                }
            default:
                operands.append(node.text)
        }
        return .skipChildren
    }

    func calcHalsteadVolume() -> Float {
        let calculatar = HalseadVolumeCalculatar(
            operators: operators,
            distinctOperators: distinctOperators,
            operands: operands,
            distinctOperands: distinctOperands
        )
        return calculatar.halsteadVolume
    }
}

struct HalseadVolumeCalculatar {
    let operators: [String]
    let distinctOperators: Set<String>
    let operands: [String]
    let distinctOperands: Set<String>

    var vocabulary: Float {
        Float(distinctOperators.count + distinctOperands.count)
    }

    var length: Float {
        Float(operators.count + operands.count)
    }

    var halsteadVolume: Float {
        length * log2(vocabulary)
    }
}

func measureHalsteadVolume() {
    do {
        let sourceFile = try SyntaxParser.parse(source: source)
        let visitor = OperatorUsageWhitespaceVisitor()
        visitor.walk(sourceFile)
        let halsteadVolume = visitor.calcHalsteadVolume()
        print("halstead volume \(halsteadVolume)")
        let cyclomaticComplexity = visitor.cyclomaticComplecity
        print("cyclomatic complecity \(cyclomaticComplexity)")
        let lineOfCode = source.split(separator: "\n").count
        print("line of code \(lineOfCode)")
        let halstead = 5.2 * log(Double(halsteadVolume))
        let cyclomatic = 0.23 * Double(cyclomaticComplexity)
        let line = 16.2 * log(Double(lineOfCode))
        let maitainabilityIndex = max(0, CGFloat(171 - halstead - cyclomatic - line) * 100 / 171)
        print("maitainability index \(maitainabilityIndex)")
    } catch {

    }
}
