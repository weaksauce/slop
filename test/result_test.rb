require "test_helper"

describe Slop::Result do
  subject { Slop.parse(%w"--name Lee") { |o| o.string :name } }

  describe "to_h" do
    it "returns option => arguments in hash form" do
      subject.to_hash.must_equal({ name: "Lee" })
    end
  end

  describe "#[]" do
    it "fetches the option and calls .value on it" do
      subject["name"].must_equal "Lee"
    end

  end

  describe "method_missing" do
    it "checks an options count" do
      subject.name?.must_equal true
      subject.find_option("name").count = 0
      subject.name?.must_equal false
    end

    it "raises if not a valid option" do
      -> { subject.bar? }.must_raise(NoMethodError)
    end

  end

end

