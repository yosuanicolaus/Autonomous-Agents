extends Control

var path_ant = "res://ant/ant_colony.tscn"
var path_ball = "res://practice/separate_test.tscn"
var path_agent = "res://vehicles/practice.tscn"


func _on_ButtonAnt_pressed():
	return get_tree().change_scene_to_file(path_ant)


func _on_ButtonBall_pressed():
	return get_tree().change_scene_to_file(path_ball)


func _on_ButtonAgents_pressed():
	return get_tree().change_scene_to_file(path_agent)


func _on_LinkButton_pressed():
	return OS.shell_open("https://natureofcode.com/book/chapter-6-autonomous-agents/")


func _on_Copyright_pressed():
	return OS.shell_open("https://github.com/yosuanicolaus/Autonomous-Agents")
