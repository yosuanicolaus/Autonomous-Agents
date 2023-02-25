extends Node2D

@export var object: PackedScene
@export var count: int = 10

var dragging := false
var frame := 0

@onready var screen := get_viewport_rect().size


func _ready():
	randomize()
	for i in count:
		var obj = object.instantiate()
		var x = screen.x * randf()
		var y = screen.y * randf()
		obj.position = Vector2(x, y)
		obj.rotation = randf() * TAU
		add_child(obj)


func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		dragging = event.pressed


func _process(_delta):
	if dragging and frame % 5 == 0:
		var obj = object.instantiate()
		obj.position = get_global_mouse_position()
		obj.rotation = randf() * TAU
		add_child(obj)
	frame += 1
