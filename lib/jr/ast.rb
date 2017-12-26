module Jr
  Vector = Struct.new(:values) do
    def evaluate
      self
    end

    def inspect
      "#{self.class.name}#{values}"
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
      end
    end
  end

  Addition = Struct.new(:left, :right) do
    def evaluate
      left + right
    end
  end

  Subtraction = Struct.new(:left, :right) do
    def evaluate
      left - right
    end
  end

  Multiplication = Struct.new(:left, :right) do
    def evaluate
      left * right
    end
  end

  Division = Struct.new(:left, :right) do
    def evaluate
      left / right
    end
  end
end
