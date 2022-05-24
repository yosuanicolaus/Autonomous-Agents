extends Node2D

export var max_speed := 400.0
export var max_force := 15.0

var acceleration := Vector2.ZERO
var velocity := Vector2.ZERO


func seek(target: Vector2):
	var desired: Vector2 = target - position
	desired = desired.normalized()
	desired *= max_speed

	var steer: Vector2 = desired - velocity
	steer = steer.clamped(max_force)
	acceleration += steer


func _process(delta):
	var target = get_global_mouse_position()
	seek(target)
	velocity += acceleration
	velocity = velocity.clamped(max_speed)
	look_at(position + velocity)
	position += velocity * delta
	acceleration = Vector2.ZERO
