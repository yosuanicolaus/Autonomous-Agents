extends Node2D

var path_ant = "res://ant/ant_colony.tscn"
var path_ball = "res://practice/separate_test.tscn"
var path_agent = "res://vehicles/practice.tscn"


func _on_ButtonAnt_pressed():
	return get_tree().change_scene(path_ant)


func _on_ButtonBall_pressed():
	return get_tree().change_scene(path_ball)


func _on_ButtonAgents_pressed():
	return get_tree().change_scene(path_agent)