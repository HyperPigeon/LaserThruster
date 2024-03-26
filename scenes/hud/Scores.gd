extends CanvasLayer


onready var game_data = SaveFile.game_data
onready var ScoreLabel = $Score
onready var HighScoreLabel = $HighScore

# Called when the node enters the scene tree for the first time.
func _ready():	
	SaveFile.score = 0
	ScoreLabel.text = "Score: " + str(SaveFile.score)
	HighScoreLabel.text = "High Score: " + str(game_data["high_score"])

func asteroid_destroyed(destroyed_asteroid):
	if destroyed_asteroid.is_big:
		SaveFile.score += 5
	else:
		SaveFile.score += 10

	if SaveFile.score > game_data["high_score"]:
		game_data["high_score"] = SaveFile.score
		HighScoreLabel.text = "High Score: " + str(game_data["high_score"])
		SaveFile.save_data()
	ScoreLabel.text =  "Score: " + str(SaveFile.score)

func enemy_ship_destroyed(enemy):
	SaveFile.score += 15
	if SaveFile.score > game_data["high_score"]:
		game_data["high_score"] = SaveFile.score
		HighScoreLabel.text = "High Score: " + str(game_data["high_score"])
		SaveFile.save_data()
	ScoreLabel.text =  "Score: " + str(SaveFile.score)

func player_damaged():
	if $Lives.get_child_count() != 0:
		$Lives.get_child(0).queue_free()


func _on_ExitButton_pressed():
	get_tree().change_scene("res://scenes/menu/MainMenu.tscn")
