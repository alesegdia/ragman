require 'rubygems'
require 'gosu'
require './Direction.rb'

class AgentController

	def initialize ()
	    @nextaid = 0;
		@sprites = Hash.new
		@behaviours = Hash.new
	end
	
	# THREAD SAFE!! if needed
	def gen_next_aid ()
	    return @nextaid++
	end

	def subscribe_agent (sprite)
		aid = gen_next_aid()
		@sprites[aid] = sprite;
		@behaviours[aid] = Array.new()
	end

	def subscribe_behaviour (agentid, behaviour)
		@behaviours[agentid].push(behaviour)
	end
end
