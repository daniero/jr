require 'parslet'

module Jr
  class Grammar < Parslet::Parser
    # Whitespace
    rule(:space)  { match('\s').repeat(1) }
    rule(:space?) { space.maybe }

    # Tokens
    rule(:integer) { match('[0-9]').repeat(1).as(:int) >> space? }

    # Stuff
    rule(:array) { integer.repeat(0) >> space? }

    root(:array)
  end

  class Transformer < Parslet::Transform
    rule(int: simple(:i)) {
      i.to_i
    }
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
