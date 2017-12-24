module Jr
  Vector = Struct.new(:values) do
    def evaluate
      self
    end

    def inspect
      "#{self.class.name}#{values}"
    end

    def + other
      y = other.evaluate

      if values.length == 1
        v = values.first
        Vector[y.values.map { |x| v+x }]
      elsif values.length == y.values.length
        Vector[values.zip(y.values).map { |a,b| a + b }]
      elsif y.values.length == 1
        v = y.values.first
        Vector[values.map { |z| z+v }]
      end
    end
  end

  Addition = Struct.new(:left, :right) do
    def evaluate
      left + right
    end
  end
end
