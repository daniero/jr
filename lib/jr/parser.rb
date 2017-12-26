require 'parslet'
require 'jr/ast'

module Jr
  class Grammar < Parslet::Parser
    root(:expression)

    # Whitespace
    rule(:space)  { match('\s').repeat(1) }
    rule(:space?) { space.maybe }

    # Tokens
    rule(:integer) { match('[0-9]').repeat(1).as(:int) >> space? }
    rule(:plus) { str('+').as(:plus) >> space? }
    rule(:minus) { str('-').as(:minus) >> space? }
    rule(:times) { str('*').as(:times) >> space? }
    rule(:divide) { str('%').as(:divide) >> space? }

    # Compounds
    rule(:array) { integer.repeat(0).as(:arr) }
    rule(:operator) { plus | minus | times | divide }

    # Grammar
    rule(:expression) do
      infix | array
    end

    rule(:infix) do
      array.as(:left) >> operator.as(:infix) >> expression.as(:right)
    end
  end

  class Transformer < Parslet::Transform
    rule(int: simple(:i)) { Integer(i) }
    rule(arr: sequence(:x)) { Vector[x] }

    rule(plus: simple(:_)) { Addition }
    rule(minus: simple(:_)) { Subtraction }
    rule(times: simple(:_)) { Multiplication }
    rule(divide: simple(:_)) { Division }

    rule(left: simple(:left), infix: simple(:op), right: simple(:right)) do
      op.new(left, right)
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
