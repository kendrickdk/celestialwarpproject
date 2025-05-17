extends Node2D

@export var chunk_size := 512

func _draw():
	draw_rect(Rect2(Vector2.ZERO, Vector2(chunk_size, chunk_size)), Color(1, 0, 0, 0), false, 2)

func _ready():
	call_deferred("_update")
