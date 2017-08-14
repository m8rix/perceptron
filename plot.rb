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

  def y(x)
    @slope * x + @intercept
  end

  def points(xrange = -1.00..1.00)
    x_plots = []
    y_plots = []
    xrange.step(0.0001) do |x|
      next unless xrange.member?(y(x))
      x_plots.push x.round(2)
      y_plots.push y(x).round(2)
    end
    [x_plots.values_at(0, -1), y_plots.values_at(0, -1)]
  end

  def draw
    "line lc rgb 'red'"
  end
end

class Point
  attr_accessor :guessed
  attr_accessor :above
  attr_accessor :x
  attr_accessor :y
  def initialize(x, y)
    @x = x
    @y = y
  end

  def guessed?
    @guessed || false
  end

  def above?
    @above || false
  end

  def coords
    [[x], [y]]
  end

  def draw
    return "circle lc rgb 'blue' fs transparent solid 0.25" if above?
    "circle lc rgb 'orange' fs transparent solid 0.5"
  end
end
