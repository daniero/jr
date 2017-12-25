require "jr/version"
require "jr/parser"
require "jr/ast"

module Jr
  class Runtime
    def initialize(parser=Parser.new)
      @parser = parser
    end

    def evaluate(string)
      ast = @parser.parse(string)
      ast.evaluate
    end
  end
end
