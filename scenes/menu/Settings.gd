extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var game_data = SaveFile.game_data
onready var asteroid_sound_slider = self.get_node("AsteroidSoundSlider")
onready var enemy_destroyed_slider = self.get_node("EnemySoundSlider")
onready var player_destroyed_slider = self.get_node("PlayerDestroyedSlider")
onready var laser_slider = self.get_node("LaserVolumeSlider")
onready var player_hurt_slider = self.get_node("PlayerHurtVolumeSlider")

# Called when the node enters the scene tree for the first time.
func _ready():
	get_viewport().set_size(Vector2(1920,1080))
	asteroid_sound_slider.set_value(game_data["asteroid_volume"])
	enemy_destroyed_slider.set_value(game_data["enemy_volume"])
	player_destroyed_slider.set_value(game_data["player_destroyed_volume"])
	laser_slider.set_value(game_data["laser_volume"])
	player_hurt_slider.set_value(game_data["player_hurt_volume"])



func _on_ExitButton_pressed():
	get_tree().change_scene("res://scenes/menu/MainMenu.tscn")


func _on_AsteroidSoundSlider_drag_ended(value_changed):
	if value_changed:
		game_data["asteroid_volume"] = asteroid_sound_slider.get_value()
		SoundManager.get_node("HitSound").volume_db = game_data["asteroid_volume"]
		SaveFile.save_data()


func _on_EnemySoundSlider_drag_ended(value_changed):
	if value_changed:
		game_data["enemy_volume"] = enemy_destroyed_slider.get_value()
		SoundManager.get_node("EnemyDeathSound").volume_db = game_data["enemy_volume"]
		SaveFile.save_data()


func _on_LaserVolumeSlider_drag_ended(value_changed):
	if value_changed:
		game_data["laser_volume"] = laser_slider.get_value()
		SoundManager.get_node("LaserSound").volume_db = game_data["laser_volume"]
		SaveFile.save_data()


func _on_PlayerHurtVolumeSlider_drag_ended(value_changed):
	if value_changed:
		game_data["player_hurt_volume"] = player_hurt_slider.get_value()
		SoundManager.get_node("HurtSound").volume_db = game_data["player_hurt_volume"]
		SaveFile.save_data()


func _on_PlayerDestroyedSlider_drag_ended(value_changed):
	if value_changed:
		game_data["player_destroyed_volume"] = player_destroyed_slider.get_value()
		SoundManager.get_node("DeathSound").volume_db = game_data["player_destroyed_volume"]
		SaveFile.save_data()
