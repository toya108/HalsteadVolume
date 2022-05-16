import Accelerate
import SwiftSyntax
import SwiftSyntaxParser


let source = """
import Foundation

struct BlackjackCard {
  // nested Suit enumeration
  enum Suit: Character {
    case spades = "♠"
    case hearts = "♡"
    case diamonds = "♢"
    case clubs = "♣"
  }

  // nested Rank enumeration
  enum Rank: Int {
    case two = 2
    case three, four, five, six, seven, eight, nine, ten
    case jack, queen, king, ace

    struct Values {
      let first: Int, second: Int?
    }

    var values: Values {
      switch self {
      case .ace:
        return Values(first: 1, second: 11)
      case .jack, .queen, .king:
        return Values(first: 10, second: nil)
      default:
        return Values(first: self.rawValue, second: nil)
      }
    }
  }

  // BlackjackCard properties and methods
  let rank: Rank, suit: Suit
  var description: String {
    var output = "suit is"
    output += " value is"
    if let second = rank.values.second {
      output += " or"
    }
    return output
  }
}

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

    override func visit(_ node: TokenSyntax) -> SyntaxVisitorContinueKind {
        switch node.tokenKind {
            case .spacedBinaryOperator:
                operators.append(node.text)
            case .unspacedBinaryOperator:
                operators.append(node.text)
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

func run() {
    do {
        let sourceFile = try SyntaxParser.parse(source: source)
        let visitor = OperatorUsageWhitespaceVisitor()
        visitor.walk(sourceFile)
        print(visitor.calcHalsteadVolume())
    } catch {

    }
}

