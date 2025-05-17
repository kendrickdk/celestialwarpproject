extends Node2D

@export var chunk_size := 512
@export var load_radius := 2  # how many chunks around camera to load

var active_chunks = {}
var chunk_resources = {}

var chunk_grid_scene = preload("res://scenes/ChunkGrid.tscn")
var resource_node_scene = preload("res://scenes/ResourceNode.tscn")

func _ready():
	load_chunk_data()

func _process(_delta):
	var camera_pos = get_viewport().get_camera_2d().position
	var current_chunk = Vector2(
		int(camera_pos.x) / chunk_size,
		int(camera_pos.y) / chunk_size
	)

	var needed_chunks = []

	for x_offset in range(-load_radius, load_radius + 1):
		for y_offset in range(-load_radius, load_radius + 1):
			needed_chunks.append(current_chunk + Vector2(x_offset, y_offset))

	# Load missing chunks
	for chunk_coords in needed_chunks:
		if not active_chunks.has(chunk_coords):
			load_chunk(chunk_coords)

	# Unload chunks no longer needed
	for chunk_coords in active_chunks.keys():
		if chunk_coords not in needed_chunks:
			unload_chunk(chunk_coords)

func load_chunk(chunk_coords: Vector2) -> void:
	var chunk_node = Node2D.new()
	chunk_node.name = "Chunk_%d_%d" % [chunk_coords.x, chunk_coords.y]
	chunk_node.position = chunk_coords * chunk_size
	add_child(chunk_node)

	var chunk_grid_instance = chunk_grid_scene.instantiate()
	chunk_node.add_child(chunk_grid_instance)

	if chunk_resources.has(chunk_coords):
		for resource_info in chunk_resources[chunk_coords]:
			var node_instance = resource_node_scene.instantiate()
			node_instance.position = Vector2(resource_info["position"]["x"], resource_info["position"]["y"])
			node_instance.resource_type = resource_info["resource_type"]
			chunk_node.add_child(node_instance)
	else:
		var resources_info = []
		var resource_types = ["iron", "copper", "uranium", "water", "oil", "natural_gas"]
		var resource_count = randi() % 3 + 3
		for i in range(resource_count):
			var pos = Vector2(randf_range(0, chunk_size), randf_range(0, chunk_size))
			var type = resource_types[randi() % resource_types.size()]

			var node_instance = resource_node_scene.instantiate()
			node_instance.position = pos
			node_instance.resource_type = type
			chunk_node.add_child(node_instance)

			resources_info.append({
				"position": {"x": pos.x, "y": pos.y},
				"resource_type": type
			})
		chunk_resources[chunk_coords] = resources_info

	active_chunks[chunk_coords] = chunk_node

func unload_chunk(chunk_coords: Vector2) -> void:
	if active_chunks.has(chunk_coords):
		active_chunks[chunk_coords].queue_free()
		active_chunks.erase(chunk_coords)

func save_chunk_data() -> void:
	var file = FileAccess.open("user://chunk_data.save", FileAccess.WRITE)
	if file != null:
		var json = JSON.stringify(chunk_resources)
		file.store_string(json)
		file = null  # Close file
	else:
		print("Failed to open save file for writing")

func load_chunk_data() -> void:
	if FileAccess.file_exists("user://chunk_data.save"):
		var file = FileAccess.open("user://chunk_data.save", FileAccess.READ)
		if file != null:
			var json = file.get_as_text()
			var parsed_data = JSON.parse_string(json)
			if typeof(parsed_data) == TYPE_DICTIONARY:
				chunk_resources = parsed_data
			else:
				print("Save file corrupted, starting fresh")
				chunk_resources = {}
			file = null  # Close file
		else:
			print("Failed to open save file for reading")
	else:
		print("No save file found, starting fresh")

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_chunk_data()
