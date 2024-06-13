class_name TileMapManager
extends TileMap

enum TileState {
	SAFE = 0,
	FIRE = 1,
	ICE = 2
}

@export var timer:Timer
@export var tilemapScale: float
var astar = AStar2D.new()
var map_rect = Rect2i()
var tilemap_size
var point_id: int = 0
var currentX: int = 0
var currentY: int = 0

var tile_size = tile_set.tile_size;

func _ready():
	tilemap_size = get_used_rect().end - get_used_rect().position
	tile_set.tile_size = Vector2i(tile_set.tile_size.x * tilemapScale, tile_set.tile_size.y * tilemapScale)
	print(tilemap_size)
	var point_id: int = 0
	var adjacent_point_id: int = 0
	#for cell in get_used_cells(0):
		#if(get_cell_tile_data(1,cell)):
			#print(get_cell_tile_data(1,cell).get_custom_data("Walkable"))
			#continue;
		#astar.add_point(point_id, cell)
		#print(get_surrounding_cells(cell))
		#for adjacent_cell in get_surrounding_cells(cell):
			#adjacent_point_id = astar.get_point_count()
			#print("New cell")
			#astar.add_point(adjacent_point_id, adjacent_cell)
			#astar.connect_points(point_id, adjacent_point_id)
		#point_id = adjacent_point_id + 1
	add_traversable_tiles(get_used_cells(0))
	connect_traversable_tiles(get_used_cells(0))
	for cell in get_used_cells(0):
		print(cell)
		print(map_to_local(cell))
	print(astar.get_point_count())

func is_point_walkable(position):
	var map_position = local_to_map(position)
	if map_rect.has_point(map_position):
		return true
	return false

func add_traversable_tiles(tiles: Array):
	for tile in tiles:
		print(tile)
		if(get_cell_tile_data(1, tile)):
			continue
		var id = get_id_for_point(tile)
		astar.add_point(id, tile)
	
func connect_traversable_tiles(tiles: Array):
	for tile in tiles:
		
		if(get_cell_tile_data(1, tile)):
			continue
		var id = get_id_for_point(tile)
		for adjecent_tile in get_surrounding_cells(tile):
			var target_id = get_id_for_point(adjecent_tile)
			
			if not astar.has_point(target_id):
				continue
			
			astar.connect_points(id, target_id, true)

func get_id_for_point(point: Vector2):
	var x = point.x - get_used_rect().position.x
	var y = point.y - get_used_rect().position.y
	
	return x + y * get_used_rect().size.x

func astar_point_on_grid(_point_position) -> Vector2i:
	#print(local_to_map(astar.get_point_position(astar.get_closest_point(_point_position))))
	return astar.get_point_position(astar.get_closest_point(_point_position))
	
func set_player_path(_player_position, _player_destination) -> Array:
	print(astar.get_closest_point(_player_position))
	print(astar.get_closest_point(_player_destination))
	#astar.connect_points(astar.get_closest_point(_player_position),
			#astar.get_closest_point(_player_destination))
	return astar.get_point_path(astar.get_closest_point(_player_position),
			astar.get_closest_point(_player_destination))

func draw_outline(cell: Vector2i):
	var coords = map_to_local(cell)
	
	
	#draw_polyline([Vector2(coords.x, coords.y - tile_size.y / 2), 
	#Vector2(coords.x + tile_size.x / 2, coords.y - tile_size.y / 4),
	#Vector2(coords.x + tile_size.x / 2, coords.y + tile_size.y / 4),
	#Vector2(coords.x, coords.y + tile_size.y / 2),
	#Vector2(coords.x - tile_size.x / 2, coords.y + tile_size.y / 4),
	#Vector2(coords.x - tile_size.x / 2, coords.y - tile_size.y / 4),
	#Vector2(coords.x, coords.y - tile_size.y / 2)
	#], Color(0.0, 1.0, 0.0), 5.0)
	
	print("Линия")
	
