
require './spatial/NavigationMap.rb'

module AStarState
	RUNNING = 0
	FINISH = 1
end

class AStar

	attr_reader :iter

	# Usage:
	# 	1. set goal and origin
	# 	2. step until :STATE_RUNNING
	# 	3. when :STATE_FINISH, ask for path (getpath)

	def initialize( navmap )
		@navmap = navmap
	end

	def setnodes( origin, goal )
		origin.parent = nil
		origin.list = :open_set
		origin.g = 0
		origin.h = origin.cost_to( goal )
		origin.f = origin.h
		@closedset = []
		@openset = [ origin ]
		@goal = goal
		@origin = origin
		@iter = 0
		@state = AStarState::FINISH
	end

	def getneighboors(node)
		neigh = []
		(0..3).each do |i|
			if node.is_active? and node.is_used i then
				neigh << node.get_link_node(i)
			end
		end
		return neigh
	end

	# :closed_set, :open_set
	# p0, p1 -> { x, y }
	def step
		@iter = @iter + 1
		@openset.sort_by!{ |n| n.f }
		@openset.reverse!
		current = @openset.pop
		if current.is_same? @goal then
			@goal = current
			return AStarState::FINISH
		end
		neighboors = self.getneighboors(current)
		neighboors.each { |n|
			neigh_new_g = current.g + current.cost_to(n)
			# si estaba en abiertos y el coste ERA mejor, no hacemos nada
			if n.list == :open_set and n.g < neigh_new_g then
				next
			# si estaba en cerrados y el coste ERA mejor, tampoco hacemos nada
			elsif n.list == :closed_set and n.g < neigh_new_g then
				next
			end
			n.parent = current
			n.h = n.cost_to(@goal)
			n.g = neigh_new_g
			n.f = n.g + n.h
			n.list = :open_set
			@openset.push(n)
		}
		current.list = :closed_set
		return AStarState::RUNNING
	end

	def getpath
		path = []
		while @goal != nil do
			path << @goal
			@goal = @goal.parent
		end
		return path
	end

end
