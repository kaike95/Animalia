extends KinematicBody2D

const ACCEL = 500
const MAX_SPEED = 100
const FRICTION = 400
var velocity = Vector2.ZERO

onready var animationplayer = $AnimationPlayer
onready var animationtree = $AnimationTree
onready var animationstate = animationtree.get("parameters/playback")

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

	move_and_slide(velocity)
