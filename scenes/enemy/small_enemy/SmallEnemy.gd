extends KinematicBody2D

class_name SmallEnemy

onready var agent: NavigationAgent2D = $NavigationAgent2D
onready var timer := $Timer
onready var player := get_parent().get_parent().get_node("Player")
onready var avoidance_area := $Area2D


const laser_path = preload('res://scenes/laser/enemy_laser/EnemyLaser.tscn')


var velocity = Vector2.ZERO
var health = 1
var speed = 75
var laser_cooldown = 0
const COOLDOWN = 80

signal enemy_ship_destroyed(enemy)

func _ready():
	timer.connect("timeout", self, "update_pathfinding")

func _process(delta):
	if (global_position.distance_squared_to(player.global_position) < 75000):
		shoot()

func damage():
	health -= 1
	if health <= 0:
		emit_signal("enemy_ship_destroyed", self)
		queue_free()

func update_pathfinding():
	# set target location to player's current location
	agent.set_target_location(player.global_position)

func _physics_process(delta):
	#steer towards player
	if (global_position.distance_squared_to(player.global_position) > 75000):
		var direction = global_position.direction_to(agent.get_next_location())
		var target_velocity = direction*speed
		var steering = (target_velocity-velocity) * delta
		velocity += steering
	else:
		velocity = Vector2.ZERO
#		_avoid(player.global_position,delta)
	
	#steer away from fellow enemy ships and asteroids
	for obstacle in avoidance_area.get_overlapping_bodies():
		if (not obstacle is Player) and (not obstacle is Laser):
			_avoid(obstacle.global_position, delta)

#	# set agent velocity
#	agent.set_velocity(velocity)
	
	velocity = move_and_slide(velocity)
	update_rotation()

#func _on_NavigationAgent2D_velocity_computed(safe_velocity):
#	velocity = move_and_slide(safe_velocity)
#	update_rotation()

func shoot():
	if laser_cooldown <= 0:
		var laser = laser_path.instance()
		get_parent().add_child(laser)
		laser.position = $Position2D.global_position
		laser.rotate(self.rotation)
		laser.velocity = Vector2(cos(self.rotation), sin(self.rotation))
		velocity += -1*laser.velocity.normalized()*speed
		laser_cooldown = COOLDOWN 
	elif laser_cooldown > 0:
		laser_cooldown -= 1


func _avoid(avoid_position, delta):
	var offset =  avoid_position - self.global_position
	velocity -= offset.normalized() * speed * 3.5 * delta
	

func update_rotation():
	look_at(player.global_position)
#	rotation = velocity.angle()
