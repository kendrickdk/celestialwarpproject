extends Node2D

@export var map_width := 2048
@export var map_height := 2048

var resource_types = ["iron", "copper", "uranium", "water", "oil", "natural_gas"]

func _ready():
	spawn_clusters(5)
	$Camera2D.position = Vector2.ZERO

func spawn_clusters(num_clusters):
	var half_width = map_width / 2
	var half_height = map_height / 2

	for i in range(num_clusters):
		var cluster_size = randi() % 3 + 2  # 2 to 4 nodes
		var cluster_center = Vector2(
			randf_range(-half_width, half_width),
			randf_range(-half_height, half_height)
		)

		var cluster_resources = resource_types.duplicate()
		cluster_resources.shuffle()
		cluster_resources = cluster_resources.slice(0, cluster_size)

		for resource in cluster_resources:
			var offset = Vector2(randf_range(-50, 50), randf_range(-50, 50))
			var spawn_position = cluster_center + offset
			spawn_resource_node(resource, spawn_position)

func spawn_resource_node(resource_type, position):
	var scene = preload("res://scenes/ResourceNode.tscn")
	var node_instance = scene.instantiate()
	node_instance.position = position
	node_instance.resource_type = resource_type  # Assumes ResourceNode has this property
	add_child(node_instance)
