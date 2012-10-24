module RspecExplain
  def explain method, examples
    context "##{method}", examples
  end
end
