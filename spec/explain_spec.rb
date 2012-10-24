require 'spec_helper'

class Usage
  include RspecExplain

  def square x  # the method we test
    x**2
  end

  def usage_1
    explain :square, [2,4,  3,9,  5,25,  10,100]  # 4 examples
  end

  private
  def context method
    yield
  end

  def specify method
    yield
  end

  def subject  # dont forget to set subject in your specs! #
    self                                                   #
  end                                                      #
end                                                        #
                                                           #
describe RspecExplain do                                   #
  subject { Usage.new }           # like this!          <= #

  context '.explain' do

    it 'creates context block for given method' do
      subject.should_receive(:context).with('#square').once
      subject.usage_1
    end

    it 'specifies each example inside context block' do
      subject.should_receive(:specify).exactly(4).times
      subject.usage_1
    end

    it 'invokes subject inside specify block' do
      subject.should_receive(:subject).exactly(4).times { double(square: nil) }
      subject.usage_1
    end    

    it 'invokes :method on subject' do
      subject.should_receive(:square).exactly(4).times
      #subject.should_receive(:subject).exactly(4).times { subject }
      subject.usage_1
    end
  end
end