module RspecExplain
  def explain method, examples

    examples = examples.each_slice(2)

    context "##{method}" do
      examples.each do
        specify 'example'
      end
    end

  end
end
