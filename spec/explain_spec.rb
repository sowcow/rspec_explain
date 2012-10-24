require 'spec_helper'

class Usage
  include RspecExplain

  def square x  # first method we test
    x**2
  end

  def no_spaces x  # second method we test
    x.gsub(' ','_')
  end  

  def level_up x  # third method we test
    x[%r|^(/.+/)[^/]+/$|]
  end 


  def usage_1
    explain :square, [2,4,  3,9,  5,25,  10,100]  # 4 examples
  end

  def usage_2
    explain :square, %w[
      2 4
      3 9
      5 25
      6 36
      7 49
    ].map(&:to_i)
  end

  def usage_3
    explain :no_spaces, <<-EX
      one string  => one_string
      a b c       => a_b_c
      a b  c   d  => a_b__c___d
    EX
  end  

  def usage_4
    explain :level_up, <<-EX
      /x/y/z/ => /x/y/
      /x/y/   => /x/
      /one/   => /
      /       => `nil`
    EX
               # `nil` will be evaluated
  end


  # for testing
  def should_be_red
   explain :level_up, <<-EX
      /x/y/z/ => `true`
      /x/y/   => `false`
      /one/   => 123
      /       => `2*2`
    EX
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
      subject.usage_1
    end

    specify 'someday I will test `.should==output` part' do
      pending
    end


    context 'obvious testing' do

      it 'good examples should pass' do
        subject.methods.grep(/usage_\d/).size.should be >= 4
        subject.methods.grep(/usage_\d/).each { |method| subject.send method }
      end

      it 'bad examples should not pass' do
        subject.should_be_red
      end

    end
  end
end