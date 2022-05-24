extends Node2D

export var max_speed := 250.0
export var max_force := 5.0
export var slow_radius := 150.0
export var rotate_strength := 50.0

var acceleration := Vector2.ZERO
var velocity := Vector2.ZERO
var desired = Vector2.ZERO
var steer = Vector2.ZERO

onready var wander_rotator = $WanderRotator
onready var wander_target = $WanderRotator/WanderTarget
onready var vision = $WallVision
onready var screen = get_viewport_rect().size


func seek(target: Vector2):
	desired = target - position
	desired = desired.normalized()
	desired *= max_speed

	steer = desired - velocity
	steer = steer.clamped(max_force)
	acceleration += steer


func flee(target: Vector2):
	desired = position - target
	desired = desired.normalized()
	desired *= max_speed

	steer = desired - velocity
	steer = steer.clamped(max_force)
	acceleration += steer


func arrive(target: Vector2):
	desired = target - position
	var desired_length = desired.length()
	desired = desired.normalized()
	if desired_length < slow_radius:
		var slow_speed = max_speed * (desired_length / slow_radius)
		desired *= slow_speed
	else:
		desired *= max_speed

	steer = desired - velocity
	steer = steer.clamped(max_speed)
	acceleration += steer


func wander():
	wander_rotator.rotation_degrees += rand_range(-rotate_strength, rotate_strength)
	var target = wander_target.global_position

	seek(target)


func check_wall():
	var vision_position = vision.global_position
	if vision_position.x > screen.x:
		desired = Vector2(-max_speed, velocity.y)
	if vision_position.x < 0:
		desired = Vector2(max_speed, velocity.y)
	if vision_position.y > screen.y:
		desired = Vector2(velocity.x, -max_speed)
	if vision_position.y < 0:
		desired = Vector2(velocity.x, max_speed)


func _process(delta):
	# seek(get_global_mouse_position())
	wander()
	velocity += acceleration
	velocity = velocity.clamped(max_speed)
	look_at(position + velocity)
	position += velocity * delta
	acceleration = Vector2.ZERO
