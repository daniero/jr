module Jr

  ##
  # Intermediate objects to help construct the AST for infixed and prefixed
  # operators
  module Operators

    class Plus
      def self.infix(left, right)
        Addition.new(left, right)
      end

      def self.prefix(right)
        right
      end
    end

    class Minus
      def self.infix(left, right)
        Subtraction.new(left, right)
      end

      def self.prefix(right)
        Negation.new(right)
      end
    end

    class Times
      def self.infix(left, right)
        Multiplication.new(left, right)
      end

      def self.prefix(right)
        Sign.new(right)
      end
    end

    class Over
      def self.infix(left, right)
        Division.new(left, right)
      end

      def self.prefix(right)
        raise "TODO"
      end
    end

  end
end
