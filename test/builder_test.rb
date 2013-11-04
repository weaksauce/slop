require "test_helper"

describe Slop::Builder do
  subject      { Slop::Builder.new }

  describe "#on" do
    it "returns a Slop::Option" do
      subject.on("foo").must_be_kind_of Slop::Option
    end

    it "appends a new option to options attribute" do
      subject.options.must_equal []
      option = subject.on("foo")
      subject.options.must_equal [option]
    end

    it "defaults type attribute to :string" do
      subject.on("foo").attributes[:type].must_equal :string
    end
  end

  describe "find_option" do
    before do
      subject.on "f", "foo"
    end

    describe "with a present option" do
      it "returns the option" do
        subject.find_option("f").must_be_kind_of Slop::Option
        subject.find_option("foo").must_be_kind_of Slop::Option
      end
    end

    describe "with no present option" do
      it "returns nil" do
        subject.find_option("bar").must_equal nil
      end
    end
  end

  describe "method_missing" do
    it "sets the Type config attribute" do
      option = subject.string("foo")
      option.attributes[:type].must_equal :string
      option.type_class.must_equal Slop::Types::StringType
      option.attributes.must_equal({ argument: true,
        type: :string, long: "foo" })
    end
  end
end
