extends Node2D

var path_home = "res://main/main_menu.tscn"


func _on_Button_pressed():
	return get_tree().change_scene_to_file(path_home);
