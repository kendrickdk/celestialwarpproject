# chunk_grid.gd
# This script draws either a single chunk rectangle or a full grid of chunks on a Node2D.
# Attach this to a Node2D in your scene.

extends Node2D

@export var chunk_size: int = 512       # Size (width/height) of each chunk in pixels
@export var map_width: int = 2048       # Total width of the map when drawing the full grid
@export var map_height: int = 2048      # Total height of the map when drawing the full grid
@export var use_map_grid: bool = true   # Toggle between drawing the full grid or a single chunk

func _draw():
	# Called whenever the node needs to redraw. Chooses which drawing function to use.
	if use_map_grid:
		_draw_map_grid()
	else:
		_draw_single_chunk()

func _draw_single_chunk():
	# Draws a single red rectangle from (0,0) to (chunk_size, chunk_size)
	draw_rect(
		Rect2(Vector2.ZERO, Vector2(chunk_size, chunk_size)),  # Rectangle dimensions
		Color(1, 0, 0, 0),                                      # Transparent fill color (alpha=0)
		false,                                                  # Do not fill (outline only)
		2                                                       # Line thickness
	)

func _draw_map_grid():
	# Draws a red grid covering the entire map area in increments of chunk_size
	var half_w = map_width / 2
	var half_h = map_height / 2

	# Draw vertical lines every chunk_size from -half_w to +half_w
	for x in range(-half_w, half_w + 1, chunk_size):
		draw_line(
			Vector2(x, -half_h),     # Start point at top
			Vector2(x, half_h),      # End point at bottom
			Color(1, 0, 0),          # Line color (red)
			2                        # Line thickness
		)

	# Draw horizontal lines every chunk_size from -half_h to +half_h
	for y in range(-half_h, half_h + 1, chunk_size):
		draw_line(
			Vector2(-half_w, y),     # Start point at left
			Vector2(half_w, y),      # End point at right
			Color(1, 0, 0),          # Line color (red)
			2                        # Line thickness
		)

func _ready():
	# Defer an initial draw call so the grid appears at startup
	call_deferred("_update")
