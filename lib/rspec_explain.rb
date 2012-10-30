require 'rspec_explain/version'

RSpec.configure do |config|
  config.extend RSpecExplain
end

module RSpecExplain
  def explain method, examples, shoulder=:should  ##, run='subject.%s(%s)'

    examples = prepare examples

    context "##{method}" do
      examples.each do |input,output|
        specify "#{input} => #{output}" do
          ##eval(run % [method, input.inspect]).should == output
          subject.send(method, input).send(shoulder) == output   #should == output
        end
      end
    end

  end

  def explain_not method, examples
    explain method, examples, :should_not
  end

  private
  def prepare table
    case table
    when Array then table.map { |x| prepare_one x }.each_slice(2)
    when String then prepare table.lines.map { |line| line.split '=>' }.flatten
    else
      raise
    end
  end

  COMMAND = %r"^`(.*)`$"
  def prepare_one element
    
    element = element.strip if element.is_a? String

    case element
    when COMMAND then eval(element[COMMAND,1])
    else
      element
    end      
  end
end
