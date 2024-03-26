extends PopupPanel

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

func _on_ReplayButton_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_ExitButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/menu/MainMenu.tscn")
