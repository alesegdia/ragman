
require 'rubygems'
require 'gosu'

# FPS Counter based in fguillens fpscounter
	class FPSCounter

		attr_accessor :show_fps, :font
		attr_reader :fps

		def initialize()
			@frames_counter = 0
			@milliseconds_before = Gosu::milliseconds
			@show_fps = false
			@fps = 0
		end

		def update(font, x, y)
			@frames_counter += 1
			if Gosu::milliseconds - @milliseconds_before >= 1000
				@fps = @frames_counter.to_f / ((Gosu::milliseconds - @milliseconds_before) / 1000.0)
				@frames_counter = 0
				@milliseconds_before = Gosu::milliseconds
			end
			font.draw("FPS: "+@fps.to_s, x, y, 1) if @show_fps
		end
	end
