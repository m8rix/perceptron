require "gnuplot"
require "awesome_print"

class Canvas
  attr_accessor :area
  def initialize(area)
    @area = area
    Gnuplot.open do |gp|
      Gnuplot::Plot.new( gp ) do |plot|
        plot.xrange "[#{area.min}:#{area.max}]"
        plot.yrange "[#{area.min}:#{area.max}]"
        yield( plot, self )
      end
    end
  end
end

class Line
  def initialize(slope = nil, intercept = nil, range = -1.00..1.00)
    @slope = slope || rand(range)
    @intercept = intercept || rand(range)
    @range = range
    # https://www.youtube.com/watch?v=IL3UCuXrUzE
    puts "y = #{@slope}x + #{-1 * @intercept}"
  end

  def y(x)
    @slope * x + @intercept
  end

  def points
    x_plots = []
    y_plots = []
    @range.step(0.0001) do |x|
      next unless @range.member?(y(x))
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
