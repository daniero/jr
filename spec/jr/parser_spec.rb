require 'spec_helper'
require "jr"

RSpec.describe Jr::Parser  do
  subject { Jr::Parser.new }

  it "works" do
    expect(subject.parse("1 23 456")).to eql [1, 23, 456]
  end
end
