require 'spec_helper'

describe TeamPost do
  it { should belong_to :post }
  it { should belong_to :team }
end
