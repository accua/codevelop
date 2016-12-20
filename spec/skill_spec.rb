require 'spec_helper'

describe Skill do
  it { should belong_to :language}
  it { should belong_to :user}
end
