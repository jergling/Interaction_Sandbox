extends Control

@export var scene1 : String
@export var scene2 : String

func _on_button_pressed() -> void:
	#get_tree().unload_current_scene()
	get_tree().change_scene_to_file(scene1)


func _on_button_2_pressed() -> void:
	#get_tree().unload_current_scene()
	get_tree().change_scene_to_file(scene2)
