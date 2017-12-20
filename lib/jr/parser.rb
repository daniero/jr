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

    # Compounds
    rule(:array) { integer.repeat(0).as(:arr) }
    rule(:operator) { plus }

    # Grammar
    rule(:expression) do
      infix | array
    end

    rule(:infix) do
      array.as(:left) >> operator.as(:op) >> expression.as(:right)
    end
  end

  class Transformer < Parslet::Transform
    rule(int: simple(:i)) { Integer(i) }
    rule(plus: simple(:_)) { :+ }

    # TODO: custom ast class for array, so infix left can be changed to simple

    rule(arr: sequence(:x)) { Vector[*x] }

    rule(left: sequence(:left), op: :+, right: simple(:right)) do
      Addition.new(left, right)
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
