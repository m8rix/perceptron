require_relative "plot"

# The activation function
def sign(int)
  int <=> 0
end

class Perceptron
  attr_accessor :weights

  # Constructor
  def initialize(w = Array.new)
    # Initialize the weights randomly
    @weights = w.map { rand(-1.00..1.00) }
  end

  def guess(inputs)
    sum = 0
    ## Fill in missing weights
    @weights = inputs.zip(@weights).map { |i, w| w.to_f.zero? ? rand(-1.00..1.00) : w }
    inputs.zip(@weights).each do |input, weight|
      sum += input * weight
      puts sum
    end
    sign(sum)
  end
end

perceptron = Perceptron.new
puts perceptron.guess([-1, 0.5])

Canvas.new(-1.00..1.00, -1.00..1.00) do |plot, canvas|
  line = Line.new(rand(canvas.xrange), rand(canvas.yrange))
  dots = Array.new(100).map do
    dot = Point.new(rand(canvas.xrange), rand(canvas.yrange))
    dot.guessed = [true, false].sample
    dot.above = line.y(dot.x) > dot.y
    dot
  end

  dots.each do |dot|
    plot.data << Gnuplot::DataSet.new(dot.coords) do |ds|
      ds.with = dot.draw
      ds.notitle
    end
  end

  plot.data << Gnuplot::DataSet.new(line.points(canvas.xrange)) do |ds|
    ds.with = line.draw
    ds.linewidth = 3
  end
end
