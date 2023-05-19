extends Node3D


# Called when the node enters the scene tree for the first time.
func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().quit()
