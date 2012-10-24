require 'spec_helper'

class Usage
  include RspecExplain

  def square x
    x**2
  end

  def usage_1
    explain :square, [2,4,  3,9,  5,25,  10,100]
  end
end

describe RspecExplain do

  context '.explain' do
    let(:test) { Usage.new }

    it 'creates context block for given method' do
      test.should_receive(:context).exactly(1).times
      test.usage_1
    end
    
  end
end