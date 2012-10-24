module RspecExplain
  def explain method, examples, run='subject.%s(%s)'

    examples = prepare examples

    context "##{method}" do
      examples.each do |input,output|
        specify "#{input} => #{output}" do
          eval(run % [method, input.inspect]) #subject.send(:method, input)
        end
      end
    end

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

  def prepare_one element
    case element
    when String then element.strip
    else
      element
    end      
  end
end
