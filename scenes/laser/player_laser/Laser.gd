extends KinematicBody2D

class_name Laser

var velocity = Vector2(0,0)
var speed = 300
var lifespan = 60

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

func _physics_process(delta):
	var collision = move_and_collide(velocity.normalized()*delta*speed)
	if collision:
		queue_free()
		handle_collision(collision.get_collider())

## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if lifespan <= 0:
#		queue_free()
#	else:
#		lifespan -= 1

func handle_collision(collider):
	if collider.has_method("damage"):
		collider.damage()


func _on_Timer_timeout():
	queue_free()
