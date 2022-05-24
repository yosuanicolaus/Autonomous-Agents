extends Node2D

export var max_speed := 250.0
export var max_force := 5.0
export var slow_radius := 150.0
export var rotate_strength := 50.0
export var separate_radius := 75.0

var acceleration: Vector2
var velocity: Vector2
var desired: Vector2
var steer: Vector2

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


func separate():
	var vehicles = get_tree().get_nodes_in_group("vehicles")
	var sum := Vector2.ZERO
	var count := 0

	for vehicle in vehicles:
		var diff = (vehicle.position - position).length()
		if diff > 0 and diff < separate_radius:
			var target = position - vehicle.position
			sum += target
			count += 1

	if count > 0:
		sum /= count
		sum = sum.normalized()
		sum *= max_speed

		steer = sum - position
		steer = steer.clamped(max_force)
		acceleration += steer
		var c = count * 50
		modulate = Color(255, 255 - c, 255 - c)
	else:
		modulate = Color(1, 1, 1)


func _process(delta):
	# wander()
	separate()
	velocity += acceleration
	velocity = velocity.clamped(max_speed)
	look_at(position + velocity)
	position += velocity * delta
	acceleration = Vector2.ZERO
