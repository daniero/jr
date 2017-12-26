require 'spec_helper'
require "jr"

module Jr
  RSpec.describe Parser  do
    subject { Parser.new }

    it "parses arrays" do
      expect(subject.parse("1 23 456")).to eql Vector[[1, 23, 456]]
    end

    it "parses infix expressions" do
      expect(subject.parse("1 2 + 3 4")).to eql Addition.new(Vector[[1, 2]], Vector[[3, 4]])
    end

    it "is right recursive" do
      expect(subject.parse("1 + 2 + 3 4")).to eql Addition.new(Vector[[1]], Addition.new(Vector[[2]], Vector[[3, 4]]))
    end

    it "parses parens" do
      expect(subject.parse("1 * (2 - 3) % 4")).to eql Multiplication.new(Vector[[1]], Division.new(Subtraction.new(Vector[[2]], Vector[[3]]), Vector[[4]]))
    end
  end
end
