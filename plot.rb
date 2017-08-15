require "gnuplot"
require "awesome_print"

class Canvas
  attr_accessor :xrange
  attr_accessor :yrange
  def initialize(xrange, yrange)
    @xrange = xrange
    @yrange = yrange
    Gnuplot.open do |gp|
      Gnuplot::Plot.new( gp ) do |plot|
        plot.xrange "[#{xrange.min}:#{xrange.max}]"
        plot.yrange "[#{yrange.min}:#{yrange.max}]"
        plot.title  "Perceptron"
        plot.unset "key"
        plot.zeroaxis
        plot.size "ratio 1.0"
        plot.xtics "axis"
        plot.ytics "axis"
        plot.border 0
        plot.format "xy ''"
        plot.tics "scale 1"
        yield( plot, self )
      end
    end
  end
end

class Line
  def initialize(slope = nil, intercept = nil)
    @slope = slope
    @intercept = intercept
    # https://www.youtube.com/watch?v=IL3UCuXrUzE
    puts "y = #{@slope}x + #{-1 * @intercept}"
  end

  def f(x)
    @slope * x + @intercept
  end

  def draw(xrange = -1.00..1.00)
    x_plots = []
    y_plots = []
    xrange.step(0.0001) do |x|
      next unless xrange.member?(f(x))
      x_plots.push x.round(2)
      y_plots.push f(x).round(2)
    end
    [x_plots.values_at(0, -1), y_plots.values_at(0, -1)]
  end

  def style
    "line lc rgb 'red'"
  end
end

class Point
  attr_accessor :x
  attr_accessor :y
  attr_accessor :bias
  attr_accessor :label
  attr_accessor :guess

  def initialize(x, y)
    @x = x
    @y = y
    @bias = 1
  end

  def above?
    @label == 1
  end

  def guessed?
    @label == @guess
  end

  def draw
    [[x], [y]]
  end

  def style
    return "circle lc rgb 'green' fs transparent solid 0.25" if guessed?
    return "circle lc rgb 'blue' fs transparent solid 0.25" if above?
    "circle lc rgb 'orange' fs transparent solid 0.5"
  end
end
