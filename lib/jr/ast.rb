module Jr
  Vector = Struct.new(:values) do
    def evaluate
      self
    end

    def inspect
      values.map { |v| v.to_s.sub('-', '_') } * ' '
    end

    def +@
      self
    end

    def -@
      Vector[values.map { |v| -v }]
    end

    def clamp_values
      Vector[values.map { |v| v.clamp(-1,1) }]
    end

    def +(other)
      apply_infix(other) { |x,y| x + y }
    end

    def -(other)
      apply_infix(other) { |x,y| x - y }
    end

    def *(other)
      apply_infix(other) { |x,y| x * y }
    end

    def /(other)
      apply_infix(other) { |x,y| x / y }
    end

    private
    def apply_infix(other)
      y = other.evaluate

      if values.length == 1
        v = values.first
        Vector[y.values.map { |x| yield v,x }]
      elsif values.length == y.values.length
        Vector[values.zip(y.values).map { |a,b| yield a,b }]
      elsif y.values.length == 1
        v = y.values.first
        Vector[values.map { |z| yield z,v }]
      else
        raise "length error"
      end
    end
  end

  # Generic operators

  class Plus
    def self.infix(left, right)
      Addition.new(left, right)
    end

    def self.prefix(right)
      +right.evaluate
    end
  end

  class Minus
    def self.infix(left, right)
      Subtraction.new(left, right)
    end

    def self.prefix(right)
      -right.evaluate
    end
  end

  class Times
    def self.infix(left, right)
      Multiplication.new(left, right)
    end

    def self.prefix(right)
      right.evaluate.clamp_values
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

  # Infix operators

  Addition = Struct.new(:left, :right) do
    def evaluate
      left.evaluate + right
    end
  end

  Subtraction = Struct.new(:left, :right) do
    def evaluate
      left.evaluate - right
    end
  end

  Multiplication = Struct.new(:left, :right) do
    def evaluate
      left.evaluate * right
    end
  end

  Division = Struct.new(:left, :right) do
    def evaluate
      left.evaluate / right
    end
  end

end
