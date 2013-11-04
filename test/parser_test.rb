require "test_helper"

describe Slop::Parser do
  let(:builder) { Slop::Builder.new }
  subject { Slop::Parser.new(builder) }

  describe "#parse" do
    it "returns a Result instance" do
      items = %w(foo bar)
      subject.parse(items).must_be_kind_of Slop::Result
    end

    # it "defaults to parsing ARGV" do
    #   begin
    #     old_argv = ARGV.clone
    #     ARGV.replace %w(foo bar)
    #     subject.parse
    #   ensure
    #     ARGV.replace old_argv
    #   end
    # end

    it "raises if an option expects an argument and none is given" do
      subject.builder.string "name"
      -> { subject.parse %w"--name" }.must_raise(Slop::MissingArgument)
    end

    describe "with valid options" do
      before do
        subject.builder.string "foo"
        subject.builder.boolean "bar"
      end

      let(:result) { subject.parse %w(--foo hello --bar) }

      it "increments the option count" do
        result.find_option("foo").count.must_equal 1
      end

      it "sets the options argument" do
        result.find_option("foo").argument.must_equal "hello"
        result.find_option("bar").argument.must_equal nil
      end
    end

    describe "option=argument" do
      before do
        subject.builder.string "foo"
      end

      let(:result) { subject.parse %w(--foo=hello) }

      it "assigns the argument" do
        result.find_option("foo").argument.must_equal "hello"
      end
    end

    describe "multiple options" do
      before do
        subject.builder.boolean "a"
        subject.builder.boolean "b"
        subject.builder.string "c"
      end

      let(:result) { subject.parse %w(-abc foo) }

      it "sets the boolean options to true" do
        result.a?.must_equal true
        result.b?.must_equal true
        result["c"].must_equal "foo"
      end

      it "raises for unknown options" do
        -> { subject.parse %w(-abd) }.must_raise(Slop::UnknownOption)
      end
    end
  end

end
