# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "rspec/helper"

# --
module Jekyll
  module Assets
    class Default
      class Test1 < Default
        static hello: :world
        content_types :test
      end

      class Test2 < Default
        static world: :hello
        content_types :test

        def run
          @args.update({
            hello: :world,
          })
        end
      end
    end
  end
end

describe Jekyll::Assets::Default do
  before do
    allow(asset).to(receive(:content_type).and_return(:test))
  end

  let :asset do
    env.find_asset!("img.png")
  end

  describe "get" do
    subject do
      described_class.get({
        type: :test,
        args: {
          #
        },
      })
    end

    it "should give an indifferent hash" do
      expect(subject).to(be_a(HashWithIndifferentAccess))
    end

    it "should merge values" do
      expect(subject).to(eq({
        "hello" => :world,
        "world" => :hello,
      }))
    end
  end

  describe "set_defaults" do
    it "should run and set defaults" do
      result = {}
      subject.set(result, {
        asset: asset,
        env: env,
      })

      expect(result[:hello]).to(eq(:world))
    end
  end
end
