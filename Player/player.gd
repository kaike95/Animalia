extends KinematicBody2D

export var vida : int = 10

const ACCEL = 500
const MAX_SPEED = 100
const FRICTION = 400
var velocity = Vector2.ZERO

signal damage_received(life)

onready var animationplayer = $AnimationPlayer
onready var animationtree = $AnimationTree
onready var animationstate = animationtree.get("parameters/playback")

func death():
	if vida == 0:
		queue_free()

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		animationtree.set("parameters/Idle/blend_position", input_vector)
		animationtree.set("parameters/Run/blend_position", input_vector)
		animationstate.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCEL * delta)
	else:
		animationstate.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta ) 
	death()
	move_and_slide(velocity)



func _on_hurtbox_area_entered(hitbox):
	print("DEBUG ",vida - 1)
	print("DEBUG:hitbox de " + hitbox.get_parent().name + " tocou " + name + " e deu 1 de dano")
	emit_signal("damage_received", vida)
	vida = vida -1
