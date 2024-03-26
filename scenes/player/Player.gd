extends KinematicBody2D

class_name Player

const laser_path = preload('res://scenes/laser/player_laser/Laser.tscn')

var velocity = Vector2()
var speed = 15
var health = 3
var laser_cooldown = 0
var rng = RandomNumberGenerator.new()
var is_invincible = false
var is_dying = false

const COOLDOWN = 30

signal player_damaged
signal player_killed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
   if Input.is_mouse_button_pressed(BUTTON_LEFT): # Left mouse button.
	   shoot()
   reposition()

func _physics_process(delta):
	look_at(get_global_mouse_position())
	var collision = move_and_collide(velocity*delta)
	handle_collision(collision)

func shoot():
	if laser_cooldown <= 0 and (not is_dying):
		var laser = laser_path.instance()
		get_parent().add_child(laser)
		laser.position = $Position2D.global_position
		laser.rotate(self.rotation)
		laser.velocity = Vector2(cos(self.rotation), sin(self.rotation))
		velocity += -1*laser.velocity.normalized()*speed
		laser_cooldown = COOLDOWN 
		
		SoundManager.get_node("LaserSound").position = self.position
		SoundManager.get_node("LaserSound").play()

	elif laser_cooldown > 0:
		laser_cooldown -= 1

func handle_collision(collision):
	if collision:
		velocity = velocity.bounce(collision.get_normal())*0.75

func reposition():
	var game_size = Vector2(5120,2880)
	if self.position.y > game_size.y+10:
	   self.position.y = -self.position.y + game_size.y
	elif self.position.y < -10:
	   self.position.y = game_size.y + self.position.y
	if self.position.x > game_size.x:
	   self.position.x = -self.position.x + game_size.x	
	elif self.position.x < -10:
	   self.position.x = game_size.x + self.position.x

func damage():
	if not is_invincible:
		emit_signal("player_damaged")
		is_invincible = true
		$AnimationPlayer.play("blink")
		health -= 1
		if health <= 0:
			is_dying = true
			SoundManager.get_node("DeathSound").position = self.position
			SoundManager.get_node("DeathSound").play()
			$AnimationPlayer.play("death")
		else:
			SoundManager.get_node("HurtSound").position = self.position
			SoundManager.get_node("HurtSound").play()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "blink":
		is_invincible = false
	if anim_name == "death":
		$Sprite.set_visible(0)
		emit_signal("player_killed")
