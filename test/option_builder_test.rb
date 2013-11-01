require "test_helper"

describe Slop::OptionBuilder do
  let(:parser) { Slop::Parser.new }
  subject      { Slop::OptionBuilder.new(parser) }

  describe "#on" do
    it "returns a Slop::Option" do
      subject.on("foo").must_be_kind_of Slop::Option
    end

    it "appends a new option to options attribute" do
      subject.options.options.must_equal []
      option = subject.on("foo")
      subject.options.options.must_equal [option]
    end
  end
end
