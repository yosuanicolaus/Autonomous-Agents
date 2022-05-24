extends Node2D

export var desired_separation = 40
export var max_speed = 100
export var max_force = 20

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO


func _process(delta):
	var sum = Vector2()
	var count = 0

	for ball in get_tree().get_nodes_in_group("balls"):
		var d = position.distance_to(ball.position)
		if d > 0 and d < desired_separation:
			var diff = position - ball.position
			diff = diff.normalized()
			diff /= d
			sum += diff
			count += 1

	if count > 0:
		sum /= count
		sum = sum.normalized()
		sum *= max_speed

		var steer = sum - velocity
		steer = steer.clamped(max_force)
		acceleration += steer

	velocity += acceleration
	velocity = velocity.clamped(max_speed)
	position += velocity * delta
	acceleration = Vector2.ZERO
