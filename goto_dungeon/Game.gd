extends Node2D

var Room = preload("res://Room.tscn")
var Player = preload("res://Character.tscn")
var Tresure = preload("res://tresure.tscn")
var font = preload("res://assets/RobotoBold120.tres")
onready var Map = $TileMap

var tile_size = 16  # size of a tile in the TileMap
var num_rooms = 20  # number of rooms to generate
var min_size = 10  # minimum room size (in tiles)
var max_size = 20  # maximum room size (in tiles)
# var hspread = 200  # horizontal spread (in pixels)
var cull = 0.5  # chance to cull room
var path_with = 3 # tile with of path between rooms

var path  # AStar pathfinding object
var start_room = null
var end_room = null
var play_mode = false  
var player = null
var tresure = null

enum {GROUND, EMPTY, WALL, OUTER_CORNER, Inner_CORNER}


func _ready():
	randomize()
	make_rooms()
	# currently does not work without the yield
	yield(get_tree().create_timer(0.7), "timeout")
	make_map()
	player = Player.instance()
	add_child(player)
	player.position = start_room.position
	play_mode = true
	
	tresure = Tresure.instance()
	add_child(tresure)
	tresure.position = end_room.position

func make_rooms():
	for i in range(num_rooms):
		# var pos = Vector2(rand_range(-hspread, hspread), 0)
		var pos = Vector2(0, 0)
		var r = Room.instance()
		var w = min_size + randi() % (max_size - min_size)
		var h = min_size + randi() % (max_size - min_size)
		r.make_room(pos, Vector2(w, h) * tile_size)
		$Rooms.add_child(r)
	# wait for movement to stop
	yield(get_tree().create_timer(0.5), 'timeout')
	# cull rooms
	var room_positions = []
	for room in $Rooms.get_children():
		if randf() < cull:
			room.queue_free()
		else:
			room.mode = RigidBody2D.MODE_STATIC
			room_positions.append(Vector3(room.position.x,
										  room.position.y, 0))
	yield(get_tree(), 'idle_frame')
	# generate a minimum spanning tree connecting the rooms
	path = find_mst(room_positions)


func find_mst(nodes):
	# Prim's algorithm
	# Given an array of positions (nodes), generates a minimum
	# spanning tree
	# Returns an AStar object
	
	# Initialize the AStar and add the first point
	var path = AStar.new()
	path.add_point(path.get_available_point_id(), nodes.pop_front())
	
	# Repeat until no more nodes remain
	while nodes:
		var min_dist = INF  # Minimum distance so far
		var min_p = null  # Position of that node
		var p = null  # Current position
		# Loop through points in path
		for p1 in path.get_points():
			p1 = path.get_point_position(p1)
			# Loop through the remaining nodes
			for p2 in nodes:
				# If the node is closer, make it the closest
				if p1.distance_to(p2) < min_dist:
					min_dist = p1.distance_to(p2)
					min_p = p2
					p = p1
		# Insert the resulting node into the path and add
		# its connection
		var n = path.get_available_point_id()
		path.add_point(n, min_p)
		path.connect_points(path.get_closest_point(p), n)
		# Remove the node from the array so it isn't visited again
		nodes.erase(min_p)
	return path


func _draw():
	if not play_mode:
		font.size = 500
		draw_string(font, Vector2(-2000,0), "GENERATING MAP ...", Color(1,1,1))
		
		for room in $Rooms.get_children():
			draw_rect(Rect2(room.position - room.size, room.size * 2),
					 Color(0, 1, 0), false)
		if path:
			for p in path.get_points():
				for c in path.get_point_connections(p):
					var pp = path.get_point_position(p)
					var cp = path.get_point_position(c)
					draw_line(Vector2(pp.x, pp.y), Vector2(cp.x, cp.y),
							  Color(1, 1, 0), 15, true)


func _process(delta):
	update()
	


func make_map():
	# Create a TileMap from the generated rooms and path
	Map.clear()
	set_random_start_and_end()
	
	var full_rect = Rect2()
	for room in $Rooms.get_children():
		var r = Rect2(room.position-room.size,
					room.get_node("CollisionShape2D").shape.extents*2)
		full_rect = full_rect.merge(r)
	var topleft = Map.world_to_map(full_rect.position) - Vector2(2,2)
	var bottomright = Map.world_to_map(full_rect.end) + Vector2(2,2)
		
	fill_map(topleft, bottomright)
	carve_rooms()
	carve_corridors()
	remove_signle_tile_ground(topleft, bottomright)
	add_walls(topleft, bottomright)


func fill_map(topleft, bottomright):
	for x in range(topleft.x, bottomright.x):
		for y in range(topleft.y, bottomright.y):
			Map.set_cell(x, y, EMPTY)


func carve_rooms(): 
	for room in $Rooms.get_children():
		var gap_size = 2
		var s = (room.size / tile_size).floor()
		var pos = Map.world_to_map(room.position)
		var ul = (room.position / tile_size).floor() - s
		for x in range(gap_size, s.x * 2 - gap_size):
			for y in range(gap_size, s.y * 2 - gap_size):
				Map.set_cell(ul.x + x, ul.y + y, GROUND)


func carve_corridors(): 
	var corridors = []  # One corridor per connection
	for room in $Rooms.get_children():
		var p = path.get_closest_point(Vector3(room.position.x, 
											room.position.y, 0))
		for connection in path.get_point_connections(p):
			if not connection in corridors:
				var start = Map.world_to_map(Vector2(path.get_point_position(p).x,
													path.get_point_position(p).y))
				var end = Map.world_to_map(Vector2(path.get_point_position(connection).x,
													path.get_point_position(connection).y))
				carve_path(start, end)
		corridors.append(p)


func carve_path(pos1, pos2):
	# Carve a path between two points
	var x_diff = sign(pos2.x - pos1.x)
	var y_diff = sign(pos2.y - pos1.y)
	if x_diff == 0: x_diff = pow(-1.0, randi() % 2)
	if y_diff == 0: y_diff = pow(-1.0, randi() % 2)
	# choose either x/y or y/x
	var x_y = pos1
	var y_x = pos2
	if (randi() % 2) > 0:
		x_y = pos2
		y_x = pos1
	for x in range(pos1.x, pos2.x, x_diff):
		# widen the corridor
		for offset in range(path_with):
			Map.set_cell(x, x_y.y + y_diff * offset, GROUND)  
	for y in range(pos1.y, pos2.y, y_diff):
		for offset in range(path_with):
			Map.set_cell(y_x.x + x_diff * offset, y, GROUND)


func remove_signle_tile_ground(topleft, bottomright):
	for x in range(topleft.x, bottomright.x):
		for y in range(topleft.y, bottomright.y):
			if (Map.get_cell(x, y-1) == GROUND and Map.get_cell(x, y+1) == GROUND) or (Map.get_cell(x-1, y) == GROUND and Map.get_cell(x+1, y) == GROUND):
				Map.set_cell(x, y, GROUND)


class TileCash:
	var cash = []
	
	func save(x, y, tile, flip_x=false, flip_y=false, transpose=false):
		cash.append({'x': x, 'y': y, 'tile': tile, 'flip_x': flip_x, 'flip_y': flip_y, 'transpose': transpose})
		
	func apply_all(map):
		for tile in cash:
			map.set_cell(tile['x'], tile['y'], tile['tile'], tile['flip_x'], tile['flip_y'], tile['transpose'])


func add_walls(topleft, bottomright):
	var tile_cash = TileCash.new()
	for x in range(topleft.x, bottomright.x):
		for y in range(topleft.y, bottomright.y):
			# {GROUND, EMPTY, WALL, OUTER_CORNER, Inner_CORNER}
			if Map.get_cell(x, y) == EMPTY:
				if Map.get_cell(x, y-1) == EMPTY and Map.get_cell(x, y+1) == GROUND:
					tile_cash.save(x, y, WALL)
				elif Map.get_cell(x, y+1) == EMPTY and Map.get_cell(x, y-1) == GROUND:
					tile_cash.save(x, y, WALL, false, true)
				elif Map.get_cell(x-1, y) == EMPTY and Map.get_cell(x+1, y) == GROUND:
					tile_cash.save(x, y, WALL, false, false, true)
				elif Map.get_cell(x+1, y) == EMPTY and Map.get_cell(x-1, y) == GROUND:
					tile_cash.save(x, y, WALL, true, false, true)
					
				elif Map.get_cell(x+1, y) == EMPTY and Map.get_cell(x, y+1) == EMPTY and Map.get_cell(x+1, y+1) == GROUND:
					tile_cash.save(x, y, OUTER_CORNER)
				elif Map.get_cell(x-1, y) == EMPTY and Map.get_cell(x, y-1) == EMPTY and Map.get_cell(x-1, y-1) == GROUND:
					tile_cash.save(x, y, OUTER_CORNER, true, true)
				elif Map.get_cell(x-1, y) == EMPTY and Map.get_cell(x, y+1) == EMPTY and Map.get_cell(x-1, y+1) == GROUND:
					tile_cash.save(x, y, OUTER_CORNER, true, false)
				elif Map.get_cell(x+1, y) == EMPTY and Map.get_cell(x, y-1) == EMPTY and Map.get_cell(x+1, y-1) == GROUND:
					tile_cash.save(x, y, OUTER_CORNER, false, true)
				# Inner_CORNER may overwrite WALL tiles
				if Map.get_cell(x-1, y) == GROUND and Map.get_cell(x, y-1) == GROUND:
						tile_cash.save(x, y, Inner_CORNER)
				elif Map.get_cell(x+1, y) == GROUND and Map.get_cell(x, y+1) == GROUND:
						tile_cash.save(x, y, Inner_CORNER, true, true)
				elif Map.get_cell(x-1, y) == GROUND and Map.get_cell(x, y+1) == GROUND:
						tile_cash.save(x, y, Inner_CORNER, false, true)
				elif Map.get_cell(x+1, y) == GROUND and Map.get_cell(x, y-1) == GROUND:
						tile_cash.save(x, y, Inner_CORNER, true, false)
				
	tile_cash.apply_all(Map)


func set_random_start_and_end():
	start_room = find_edge_room()
	end_room = start_room
	# needs to be compared on room baisis because the top room can also be the left edge room ...
	while(end_room == start_room):
		end_room = find_edge_room()


enum {TOP, BOTTOM, RIGHT, LEFT}
func get_random_edge(): 
	return randi() % 4


func find_edge_room():
	var edge = get_random_edge()
	var found_room
	if edge == TOP:
		var min_y = INF
		for room in $Rooms.get_children():
			if room.position.y < min_y:
				found_room = room
				min_y = room.position.y
	
	elif edge == BOTTOM:
		var max_y = -INF
		for room in $Rooms.get_children():
			if room.position.y > max_y:
				found_room = room
				max_y = room.position.y
				
	elif edge == RIGHT:
		var max_x = -INF
		for room in $Rooms.get_children():
			if room.position.x > max_x:
				found_room = room
				max_x = room.position.x
	
	elif edge == LEFT:
		var min_x = INF
		for room in $Rooms.get_children():
			if room.position.x < min_x:
				found_room = room
				min_x = room.position.x
	return found_room