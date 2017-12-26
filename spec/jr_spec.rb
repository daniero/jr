require 'spec_helper'
require "jr"

RSpec.describe Jr do
  it "has a version number" do
    expect(Jr::VERSION).not_to be nil
  end
end

module Jr
  RSpec.describe Runtime do
    subject { Runtime.new }

    describe "addition" do
      it "adds two numbers" do
        expect(subject.evaluate('1 + 2')).to eql Vector[[3]]
      end

      it "adds two arrays" do
        expect(subject.evaluate('1 2 + 4 5')).to eql Vector[[5, 7]]
      end

      it "adds an array to a number" do
        expect(subject.evaluate('1 2 4 + 8')).to eql Vector[[9, 10, 12]]
      end

      it "adds a number to an array" do
        expect(subject.evaluate('10 + 1 2 3')).to eql Vector[[11, 12, 13]]
      end

      it "evalutes a nested expression" do
        expect(subject.evaluate('1 2 + 4 + 8')).to eql Vector[[13, 14]]
      end
    end

    describe "subtraction" do
      it "works" do
        expect(subject.evaluate('10 - 1 2 3')).to eql Vector[[9, 8, 7]]
      end
    end

    describe "multiplication" do
      it "works" do
        expect(subject.evaluate('1 2 3 * 4 5 6')).to eql Vector[[4, 10, 18]]
      end
    end

    describe "division" do
      it "works" do
        expect(subject.evaluate('10 20 30 % 5')).to eql Vector[[2, 4, 6]]
      end
    end

    describe "expressions" do
      it "are always parsed from right to left" do
        expect(subject.evaluate('1 2 3 * 2 + 8')).to eql Vector[[10, 20, 30]]
      end
    end

  end
end
