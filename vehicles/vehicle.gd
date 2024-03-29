extends Node2D

@export var max_speed := 250.0
@export var max_force := 4.0
@export var slow_radius := 150.0
@export var rotate_strength := 50.0
@export var separate_radius := 75.0
@export var neighbor_radius := 120.0

var acceleration: Vector2
var velocity: Vector2
var desired: Vector2
var steer: Vector2

@onready var wander_rotator = $WanderRotator
@onready var wander_target = $WanderRotator/WanderTarget
@onready var vision = $WallVision
@onready var screen = get_viewport_rect().size


func set_steer(target: Vector2):
	desired = target
	desired = desired.normalized()
	desired *= max_speed
	steer = desired - velocity
	steer = steer.limit_length(max_force)


func seek(seek_target: Vector2):
	var target = seek_target - position
	set_steer(target)
	return steer


func flee(threat_target: Vector2):
	var target = position - threat_target
	set_steer(target)
	return steer


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
	steer = steer.limit_length(max_force)
	return steer


func wander():
	wander_rotator.rotation_degrees += randf_range(-rotate_strength, rotate_strength)
	var target = wander_target.global_position
	var wan = seek(target)
	wan *= 0.3
	acceleration += wan


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


func separate(vehicles):
	var sum := Vector2.ZERO
	var count = len(vehicles)

	for vehicle in vehicles:
		var diff = position.distance_to(vehicle.position)
		var target = position - vehicle.position
		target = target.normalized()
		target /= diff
		sum += target

	if count > 0:
		sum /= count
		set_steer(sum)
		return steer

	return Vector2.ZERO


func align(vehicles):
	var sum := Vector2.ZERO
	var count = len(vehicles)

	for vehicle in vehicles:
		sum += vehicle.velocity

	if count > 0:
		sum /= count
		set_steer(sum)
		return steer

	return Vector2.ZERO


func cohesion(vehicles):
	var sum := Vector2.ZERO
	var count = len(vehicles)

	for vehicle in vehicles:
		sum += vehicle.position

	if count > 0:
		sum /= count
		return seek(sum)

	return Vector2.ZERO


func get_neighbors(radius):
	var vehicles = get_tree().get_nodes_in_group("vehicles")
	var neighbors = []
	for vehicle in vehicles:
		var diff = position.distance_to(vehicle.position)
		if diff > 0 and diff < radius:
			neighbors.append(vehicle)
	return neighbors


func apply_behaviours():
	# follow_mouse()
	wander_flock()


func wander_flock():
	if len(get_neighbors(neighbor_radius)) == 0:
		wander()
	else:
		flock()


func flock():
	var sep = separate(get_neighbors(separate_radius))
	var ali = align(get_neighbors(neighbor_radius))
	var coh = cohesion(get_neighbors(neighbor_radius))

	sep *= 1.5
	ali *= 1.0
	coh *= 1.0

	acceleration += sep
	acceleration += ali
	acceleration += coh


func follow_mouse():
	var sep = separate(get_neighbors(separate_radius))
	var se = seek(get_global_mouse_position())

	sep *= 1.5
	se *= 0.5

	acceleration += sep
	acceleration += se


func _process(delta):
	apply_behaviours()
	velocity += acceleration
	velocity = velocity.limit_length(max_speed)
	look_at(position + velocity)
	position += velocity * delta
	acceleration = Vector2.ZERO
