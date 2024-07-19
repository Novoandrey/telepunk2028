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
		#print(tile)
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
	return astar.get_point_position(astar.get_closest_point(_point_position))
	
func set_player_path(_player_position, _player_destination) -> Array:
	return astar.get_point_path(astar.get_closest_point(_player_position),
			astar.get_closest_point(_player_destination))


#Есть ли tile на слое terrain (на 1 слое tileset)
#Не работает с scene tile
func has_terrain_point(point_position):
	print(get_cell_tile_data(1, local_to_map(to_local(point_position))))
	return get_cell_tile_data(1, local_to_map(to_local(point_position)))

#Есть ли точка навигации по глобальная координате
func has_nav_point(point_position):
	return astar.has_point(get_id_for_point(local_to_map(to_local(point_position))))

#Включена ли точка в навигации по глобальная координате
func point_enabled(point_position):
	return !astar.is_point_disabled(get_id_for_point(local_to_map(to_local(point_position))))

#Есть ли точка навигации по позиции tile в tilemap
func has_nav_tile_point(tile_position):
	return astar.has_point(get_id_for_point(tile_position))

#Включена ли точка в навигации по позиции tile в tilemap
func tile_point_enabled(tile_position):
	return !astar.is_point_disabled(get_id_for_point(tile_position))
