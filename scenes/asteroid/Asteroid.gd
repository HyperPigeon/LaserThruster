extends KinematicBody2D

class_name Asteroid

var velocity = Vector2()
var is_big = true
var big_radius = 20 
var small_radius = 8; 


signal asteroid_destroyed(destroyed_asteroid)

func _ready():
	if is_big:
		spawn_large_asteroid()
	else:
		spawn_small_asteroid()


func _process(delta):
   reposition()

func _physics_process(delta):
	var collision = move_and_collide(velocity*delta)
	if collision:
		var collider = collision.get_collider()
		if collider.has_method("damage") and ((collider is Player) or (collider is SmallEnemy)):
			collider.damage()
		velocity = velocity.bounce(collision.get_normal())

func damage():
	emit_signal("asteroid_destroyed", self)
	queue_free()

func spawn_large_asteroid():
	randomize()
	var num_vertices = randi() % 8 + 5 # Random number between 5 and 8
	var line = Line2D.new()
	var collision_polygon = CollisionPolygon2D.new()
	
	add_child(line)
	add_child(collision_polygon)
		
	for i in range(num_vertices):
		var angle = 2 * PI * i / num_vertices
		var pos = Vector2(cos(angle), sin(angle)) * big_radius
		line.add_point(pos)
	
	line.add_point(Vector2(1,0)*big_radius)
	line.width = 5
	line.default_color = Color(255, 255, 255)
	
	collision_polygon.polygon = line.points

func spawn_small_asteroid():
	randomize()
	var num_vertices = randi() % 5 + 3 
	var line = Line2D.new()
	var collision_polygon = CollisionPolygon2D.new()
	
	add_child(line)
	add_child(collision_polygon)
		
	for i in range(num_vertices):
		var angle = 2 * PI * i / num_vertices
		var pos = Vector2(cos(angle), sin(angle)) * small_radius
		line.add_point(pos)
	
	line.add_point(Vector2(1,0)*small_radius)
	line.width = 1
	line.default_color = Color(255, 255, 255)
	
	collision_polygon.polygon = line.points
	
	

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
