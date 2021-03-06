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

    def sign
      Vector[values.map { |v| v.clamp(-1,1) }]
    end

    def +(other)
      infix(other) { |x,y| x + y }
    end

    def -(other)
      infix(other) { |x,y| x - y }
    end

    def *(other)
      infix(other) { |x,y| x * y }
    end

    def /(other)
      infix(other) { |x,y| x / y }
    end

    private
    def infix(other)
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

  # Prefix operators

  Negation = Struct.new(:exp) do
    def evaluate
      -exp.evaluate
    end
  end

  Sign = Struct.new(:exp) do
    def evaluate
      exp.evaluate.sign
    end
  end

end
