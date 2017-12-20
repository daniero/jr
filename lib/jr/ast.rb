module Jr
  class Vector < Array
    def self.[](*x)
      super(*x)
    end
  end

  Addition = Struct.new(:left, :right) do
    def evaluate
      left + right
    end
  end
end
