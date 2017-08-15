require_relative "plot"

# The activation function
def sign(int)
  int <=> 0
end

class Perceptron
  attr_accessor :weights
  LR = 0.1

  # Constructor
  def initialize(weights, bias)
    # Initialize the weights randomly
    @weights = weights.push bias
  end

  def guess(inputs)
    sum = 0
    inputs.zip(@weights).each do |input, weight|
      sum += input * weight
    end
    sign(sum)
  end

  def train(inputs, label)
    guess = guess(inputs)
    error = label - guess
    # Tune all the weights
    @weights = inputs.zip(@weights).map { |i, w| w += error * i * LR }
  end
end

xrange = -1.00..1.00
yrange = -1.00..1.00

brain = Perceptron.new([rand(xrange),rand(yrange)], 1)

line = Line.new(rand(xrange), rand(yrange))

points = Array.new(100).map do
  point = Point.new(rand(xrange), rand(yrange))
  point.label = line.f(point.x) > point.y ? 1 : -1
  point
end

points.each do |pt|
  inputs = [pt.x, pt.y, pt.bias]
  target = pt.label
  brain.train(inputs, target)
  pt.guess = brain.guess(inputs)
end

Canvas.new(xrange, yrange) do |plot, canvas|
  points.each do |point|
    plot.data << Gnuplot::DataSet.new(point.draw) do |ds|
      ds.with = point.style
      ds.notitle
    end
  end

  plot.data << Gnuplot::DataSet.new(line.draw(canvas.xrange)) do |ds|
    ds.with = line.style
    ds.linewidth = 3
  end
end
