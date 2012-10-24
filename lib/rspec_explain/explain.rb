module RspecExplain
  def explain method, examples, run='subject.%s(%s)'

    examples = examples.each_slice(2)

    context "##{method}" do
      examples.each do |input,output|
        specify "#{input} => #{output}" do
          eval run % [method, input]  #subject.send(:method, input)
        end
      end
    end

  end
end
