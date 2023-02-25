extends Node2D

var path_home = "res://main/main_menu.tscn"


func _on_Button_pressed():
	return get_tree().change_scene(path_home);
