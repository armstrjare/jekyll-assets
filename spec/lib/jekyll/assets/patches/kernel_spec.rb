require "rspec/helper"
describe Kernel do
  context "#has_javascript?" do
    it "runs the block if there is a JavaScript (any) available" do
      expect(has_javascript? { true }).to eq true
    end

    it "logs when it cannot load a JavaScript runtime" do
      expect(Jekyll.logger).to receive(:debug).with(any_args)
      has_javascript? do
        raise ExecJS::RuntimeUnavailable
      end
    end
  end

  context "#try_require" do
    it "does not raise when the file doesn't exist" do
      result = try_require("if_this_exists_we_are_screwed") { "hello" }
      expect(result).to be_nil
    end

    it "runs your code if the file exists" do
      result = try_require("jekyll/assets") { "hello" }
      expect(result).to eq "hello"
    end
  end

  context "#try_require_if_javascript" do
    it "runs your code if both JavaScript and the file exists" do
      result = try_require_if_javascript("jekyll/assets") { "hello" }
      expect(result).to eq "hello"
    end

    it "does not run your code if JavaScript does not exist" do
      allow(self).to receive(:require).and_raise ExecJS::RuntimeUnavailable
      result = try_require_if_javascript("jekyll/assets") { "hello" }
      expect(result).to be_nil
    end

    it "does not run or pass the error if the file does not exist" do
      allow(self).to receive(:require).and_raise LoadError
      result = try_require_if_javascript("jekyll/assets") { "hello" }
      expect(result).to be_nil
    end
  end
end
