require 'gosu'

class VultureCap < Gosu::Window
  def initialize
    super(800, 600)
    self.caption = "Vulture Capital!"
    @image = Gosu::Image.new('vulture.png')
    @x = 200
    @y = 200
    @width = 75
    @height = 65
    @velocity_x = 5
    @velocity_y = 5
    @visable = 0
    @fist_image = Gosu::Image.new('fist.png')
    @hit = 0
    @font = Gosu::Font.new(30)
    @score = 0
    @playing = true
    @start_time = 0
  end
  def update
    if @playing
      @x += @velocity_x
      @y += @velocity_y
      @visable -= 1
      @time_left = (45 - ((Gosu.milliseconds - @start_time) / 1000))
      @playing = false if @time_left < 0 || @score == -500 || @score == 500
      @velocity_x *= -1 if @x + @width / 2 > 800 || @x - @width / 2 < 0
      @velocity_y *= -1 if @y + @height / 2 > 600 || @y - @height / 2 < 0
      @visable = 40 if @visable <10 && rand < 0.01

    end
  end
  def draw
    if @visable > 0
    @image.draw(@x - @width / 2, @y - @height / 2, 1)
    end
    @fist_image.draw(mouse_x - 40, mouse_y - 10, 1)
    if @hit == 0
      c = Gosu::Color::NONE
    elsif @hit == 1
      c = Gosu::Color::GREEN
    elsif @hit == -1
      c = Gosu::Color::RED
    end
    draw_quad(0, 0, c, 800, 0, c, 800, 600, c, 0, 600, c)
    @hit = 0
    @font.draw(@score.to_s, 700, 20, 2)
    @font.draw(@time_left.to_s, 20, 20, 2)
    unless @playing
      if @time_left < 0 || @score == -500
      @font.draw('Gave Over!', 330, 300, 3)
      @font.draw('The Vultures Have Taken Your Business', 135, 350, 3)
      @font.draw('Press the Space Bar to Play Again', 175, 400, 3)
      @visable = 20
    elsif
      @score == 500
      @font.draw('Congratulations, You\'re a Wealthy Entrepreneur' , 100, 250, 3)
      @font.draw('Press the Space Bar to Play Again', 175, 350, 3)
    end
    end
  end
  def button_down(id)
    if @playing
      if (id == Gosu::MsLeft)
        if Gosu.distance(mouse_x, mouse_y, @x, @y) < 60 && @visable >= 0
          @hit = 1
          @score += 100
        else
          @hit = -1
          @score -= 50
        end
      end
    else
      if (id == Gosu::KbSpace)
        @playing = true
        @visable = -10
        @start_time = Gosu.milliseconds
        @score = 0
      end
    end
  end
end

window = VultureCap.new
window.show
