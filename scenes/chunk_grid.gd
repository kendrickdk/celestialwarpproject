extends Node2D

@export var chunk_size := 512
@export var map_width := 2048
@export var map_height := 2048

func _draw():
	var half_width = map_width / 2
	var half_height = map_height / 2

	# Draw vertical lines from -half_width to +half_width
	for x in range(-half_width, half_width + 1, chunk_size):
		draw_line(Vector2(x, -half_height), Vector2(x, half_height), Color.RED, 2)

	# Draw horizontal lines from -half_height to +half_height
	for y in range(-half_height, half_height + 1, chunk_size):
		draw_line(Vector2(-half_width, y), Vector2(half_width, y), Color.RED, 2)

func _ready():
	call_deferred("_update")
