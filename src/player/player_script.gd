extends CharacterBody3D
class_name Player

enum State {
	Walking,
	Running,
	Crouching
}

@onready var collision_shape: CollisionShape3D = $"CollisionShape3D"

@export_group("Speeds")
@export var walking_speed: float
@export var w_jump_velocity: float
@export var running_speed: float
@export var r_jump_velocity: float
@export var crouching_speed: float
@export_group("Stamina")
@export var max_stamina: float = 100
@export var stamina_decrease: float
@export var stamina_increase: float
@export var stamina_low_increase: float
@export var stamina_low_bound: float

var state: State = State.Walking

var speed
var jump_velocity
var gravity = 12

var stamina = 100

func _physics_process(delta):
	if not is_on_floor(): # Add the gravity.
		velocity.y -= gravity * delta

	#Determine state
	stamina = clampf(stamina, 0, max_stamina)
	if Input.is_action_pressed("run") and stamina > 0:
		state = State.Running
	elif Input.is_action_pressed("crouch"):
		state = State.Crouching
	else:
		state = State.Walking
	
	#Do state stuff
	if state == State.Walking:
		speed = walking_speed
		jump_velocity = w_jump_velocity

	if state == State.Running:
		speed = running_speed
		jump_velocity = r_jump_velocity

		stamina -= stamina_decrease * delta
		if stamina <= 0:
			state = State.Walking
	else:
		if stamina > stamina_low_bound:
			stamina += stamina_increase * delta
		else:
			stamina += stamina_low_increase * delta

	if state == State.Crouching:
		speed = crouching_speed
		collision_shape.shape.height = 1
	else:
		collision_shape.shape.height = 1.8

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
