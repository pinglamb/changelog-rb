require 'spec_helper'

RSpec.describe Changelog do
  it 'has a version number' do
    expect(Changelog::VERSION).not_to be nil
  end
end
