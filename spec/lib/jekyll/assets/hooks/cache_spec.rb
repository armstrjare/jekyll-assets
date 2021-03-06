require "rspec/helper"
describe "asset caching" do
  let(:env) { Jekyll::Assets::Env.new(stub_jekyll_site) }
  it "sets up a Sprockets FileStore cache for speed" do
    expect(env.cache.instance_variable_get(:@cache_wrapper).cache).to \
      be_kind_of Sprockets::Cache::FileStore
  end
end
