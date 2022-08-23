extends AnimatedSprite

const CONV_STATE = [null, "Idle_", "Block_", "Walk_", "Attack_"]
const CONV_DIRECTION = [null, "up", "right", "down", "left"]

var direction = 3
var state = 1

var moving_direction = Vector2.ZERO
var acceleration = 10
var max_speed = 500
var velocity = Vector2.ZERO
var deceleration_step = 0.09

onready var parent = get_node("../")

# Called when the node enters the scene tree for the first time.
func _ready():
	playing = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	move()


func _input(event):
	if event.is_action_pressed("ui_up"):
		change_direction(1)
	elif event.is_action_pressed("ui_right"):
		change_direction(2)
	elif event.is_action_pressed("ui_down"):
		change_direction(3)
	elif event.is_action_pressed("ui_left"):
		change_direction(4)
	
	if event.is_action_released("ui_up"):
		stop_direction(1)
	elif event.is_action_released("ui_right"):
		stop_direction(2)
	elif event.is_action_released("ui_down"):
		stop_direction(3)
	elif event.is_action_released("ui_left"):
		stop_direction(4)
	
	elif event.is_action_pressed("block"):
		if state != 4:
			change_state(2)
			deceleration_step = 0.01
			$Particles2D.emitting = true
	elif event.is_action_released("block"):
		deceleration_step = 0.09
		if Input.is_action_pressed("ui_"+CONV_DIRECTION[direction]):
			change_state(3)
		else:
			change_state(1)
	
	elif event.is_action_pressed("attack"):
		change_state(4)
		deceleration_step = 0.03
	
func change_state(temp_state):
	state = temp_state
	change_anim()

func change_direction(temp_direct):
	direction = temp_direct
	if state == 1:
		state = 3
	if state != 4:
		change_anim()

func stop_direction(temp_direction):
	if temp_direction == direction:
		if state == 3:
			state = 1
			change_anim()

func change_anim():
	set_animation(CONV_STATE[state]+CONV_DIRECTION[direction])


func move():
#	print(velocity)
	if state == 3:
		match direction:
			1:
				moving_direction = Vector2(0,-max_speed)
			2:
				moving_direction = Vector2(max_speed,0)
			3:
				moving_direction = Vector2(0,max_speed)
			4:
				moving_direction = Vector2(-max_speed,0)
		velocity = lerp(velocity, moving_direction, 0.1)
	else:
		velocity = lerp(velocity, Vector2.ZERO, deceleration_step)
		if abs(velocity.x) < 80:
			velocity.x = 0
		if abs(velocity.y) < 80:
			velocity.y = 0
	parent.move_and_slide(velocity)


func _on_Sprite_animation_finished():
	if animation.split('_')[0] == "Attack":
		deceleration_step = 0.09
		if Input.is_action_pressed("ui_"+CONV_DIRECTION[direction]):
			change_state(3)
		else:
			change_state(1)
