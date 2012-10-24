# RSpecExplain

The idea was to write something like scenario outlines in cucumber but without semicolons or vertical bars or other syntax trash.

## Installation

Add this line to your application's Gemfile:

    gem 'rspec_explain'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec_explain

## Usage

    describe 'Usage' do
      subject { Usage.new }
             
      explain :square, %w[
        2   4
        10  100
        25  625
        30  900
      ].map(&:to_i)
            
      explain :no_spaces, <<-EX
        one string  => one_string
        a b c       => a_b_c
        a_b c_d     => a_b_c_d
      EX 
            
    end

### output:

    Usage
      #square
        2 => 4
        10 => 100
        ...


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
