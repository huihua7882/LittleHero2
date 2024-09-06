class_name PlayerCamera

extends Camera2D

func _ready() -> void:
	pass

func set_map(tile_map : TileMapLayer) -> void:
	Log.d(name, "set_map")
	if not is_node_ready():
		await ready
	var used_rect : Rect2i = tile_map.get_used_rect().grow(-1)
	var tile_size : Vector2i = tile_map.tile_set.tile_size

	limit_top = used_rect.position.y * tile_size.y * tile_map.scale.y
	limit_bottom = used_rect.end.y * tile_size.y * tile_map.scale.y
	limit_left = used_rect.position.x * tile_size.x * tile_map.scale.x
	limit_right = used_rect.end.x * tile_size.x * tile_map.scale.x
	reset_smoothing()
