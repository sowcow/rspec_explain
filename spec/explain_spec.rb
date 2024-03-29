require 'spec_helper'

class Usage
  include RSpecExplain


#####################
#  Methods we test  #
#####################

  def square x
    x**2
  end

  def no_spaces x
    x.gsub(' ','_')
  end  

  DROP_LAST = [%r|^(.*/)[^/]+/$|, 1]

  def level_up x
    x[*DROP_LAST]
  end 

  def equal x
    x
  end 


##############
#  Examples  #
##############

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
      a_b c_d     => a_b_c_d
    EX
  end  

  def usage_4
    explain :level_up, <<-EX
      /x/y/z/ => /x/y/
      /x/y/   => /x/
      /one/   => /
      /       => `nil`
    EX
  end

  def usage_5
    explain :equal, <<-EX
      `2*2` => `2+2`
      `3*2` => `2*3`
      `1*1` => `1**1`
    EX
  end  

  def usage_6
    explain :equal, <<-EX.strip.split(/$|=>/).map { |x| '`%s`' % x.strip }
      2*2 => 2+2
      3*2 => 2*3
      1*1 => 1**1
    EX
  end   

  def usage_7
    point = Struct.new(:x,:y) do
      def to_s
        "(#{x}, #{y})"
      end
    end
    p = ->(x,y){ point.new x, y }

    explain     :equal, [p.(1,1),p.(1,1),  p.(10,10),p.(10,10)]
    explain_not :equal, [p.(1,1),p.(2,2),  p.(30,30),p.(40,40)] # stupid idea:)
  end

  def should_be_red
    explain :equal, <<-EX
      2*2 => `2*2`
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
describe RSpecExplain do                                   #
  subject { Usage.new }           # like this!          <= #

  def usages
    subject.methods.grep(/usage_\d/).map { |name| subject.method name }
  end

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
      subject.should_receive(:subject).exactly(4).times { subject }
      subject.usage_1
    end    

    it 'invokes :method on subject' do
      subject.should_receive(:square).exactly(4).times { |x| x**2 }
      subject.usage_1
    end

    it 'runs input.should==output' do
      string = Class.new(String)
      test = -> do
        subject.explain :equal, [string.new('one'), string.new('another')]
      end

      expect { test.() }.to raise_error
      string.any_instance.stub(:==) { true }
      expect { test.() }.not_to raise_error
    end

    it 'aligns columns' do
      specs = []
      Usage.any_instance.stub(:specify) { |text| specs << text }

      usages.each do |usage|
        specs = []
        usage.call
        
        first_column = specs.map { |spec| spec.index ' => ' }
        same = first_column.first
        first_column.each { |width| width.should == same }
      end
    end

    it 'left justifies 1st column' do
      specs = []
      Usage.any_instance.stub(:specify) { |text| specs << text }

      data = usages.map do |usage|
        specs = []
        usage.call
        
        specs
      end

      data.flatten.select { |x| x[/^\s.* => /] }.should be_empty
    end    

    context 'obvious testing' do

      it 'good examples should pass' do
        usages.size.should be >= 4
        usages.each { |method| method.call }
      end

      it 'bad examples should not pass' do
        expect { subject.should_be_red }.to raise_error
      end

    end

    context 'the most obvious usage example:' do
      extend RSpecExplain

      describe 'Usage' do
        subject { Usage.new }         

        explain :square, %w[
          2   4
          10  100
          25  625
          30  900
          100 10000
        ].map(&:to_i)

      end
    end
  end
end