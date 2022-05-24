extends Node2D

export(PackedScene) var object
export(int) var count = 10

onready var screen = get_viewport_rect().size


func _ready():
	randomize()
	for i in count:
		var obj = object.instance()
		var x = screen.x * randf()
		var y = screen.y * randf()
		obj.position = Vector2(x, y)
		obj.rotation_degrees = randf() * 360
		add_child(obj)
