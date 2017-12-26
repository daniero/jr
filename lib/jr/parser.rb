require 'parslet'
require 'jr/ast'

module Jr
  class Grammar < Parslet::Parser
    root(:expression)

    # Whitespace
    rule(:space)  { match('\s').repeat(1) }
    rule(:space?) { space.maybe }

    # Tokens
    rule(:integer) { str('_').as(:neg).maybe >>
                     match('[0-9]').repeat(1).as(:int) >>
                     space? }
    rule(:left_paren) { str('(') >> space? }
    rule(:right_paren) { str(')') >> space? }
    rule(:plus) { str('+').as(:plus) >> space? }
    rule(:minus) { str('-').as(:minus) >> space? }
    rule(:times) { str('*').as(:times) >> space? }
    rule(:divide) { str('%').as(:divide) >> space? }

    # Compounds
    rule(:array) { integer.repeat(1).as(:arr) }
    rule(:operator) { plus | minus | times | divide }

    # Grammar
    rule(:expression) { infix | prefix | term }
    rule(:term) { parens | array }

    rule(:parens) do
      left_paren >> expression.as(:parens) >> right_paren
    end

    rule(:infix) do
      term.as(:left) >> operator.as(:infix) >> expression.as(:right)
    end

    rule(:prefix) do
      operator.as(:prefix) >> expression.as(:right)
    end
  end

  class Transformer < Parslet::Transform
    rule(int: simple(:i)) { Integer(i) }
    rule(neg: simple(:_), int: simple(:i)) { -Integer(i) }

    rule(arr: sequence(:x)) { Vector[x] }

    rule(parens: subtree(:exp)) { exp }

    rule(plus: simple(:_)) { Plus }
    rule(minus: simple(:_)) { Minus }
    rule(times: simple(:_)) { Times }
    rule(divide: simple(:_)) { Over }

    rule(left: simple(:left), infix: simple(:op), right: simple(:right)) do
      op.infix(left, right)
    end

    rule(prefix: simple(:op), right: simple(:right)) do
      op.prefix(right)
    end
  end

  class Parser
    attr_reader :grammar, :transformer

    def initialize(grammar=Grammar.new, transformer=Transformer.new)
      @grammar = grammar
      @transformer = transformer
    end

    def parse(string)
      tree = grammar.parse(string)
      transformer.apply(tree)
    end
  end
end
