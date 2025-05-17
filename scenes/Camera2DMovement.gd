extends Camera2D

@export var pan_speed := 800
@export var zoom_speed := 0.1
@export var min_zoom := 0.5
@export var max_zoom := 3.0

const BUTTON_WHEEL_UP = 4
const BUTTON_WHEEL_DOWN = 5

func _process(delta):
	var input_vector = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_vector.y += 1
	if Input.is_action_pressed("ui_up"):
		input_vector.y -= 1

	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		position += input_vector * pan_speed * delta

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP and event.pressed:
			var zoom_value = clamp(zoom.x - zoom_speed, min_zoom, max_zoom)
			zoom = Vector2(zoom_value, zoom_value)
		elif event.button_index == BUTTON_WHEEL_DOWN and event.pressed:
			var zoom_value = clamp(zoom.x + zoom_speed, min_zoom, max_zoom)
			zoom = Vector2(zoom_value, zoom_value)
