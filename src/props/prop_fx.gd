extends AudioStreamPlayer3D
#TODO: Move all of this to just prop.gd

@onready var prop_body: RigidBody3D = $"../"

@export var break_speed: float
@export var velocities: Array[float]
@export var sounds: Array[AudioStream]

func _ready():
	prop_body.contact_monitor = true
	prop_body.max_contacts_reported = 1
	prop_body.body_entered.connect(body_entered)
	max_polyphony = 5


func body_entered(body):
	for i in len(velocities):
		var body_velocity = Vector3.ZERO
		if body is RigidBody3D:
			body_velocity = body.linear_velocity
		if (prop_body.linear_velocity - body_velocity).length() + prop_body.angular_velocity.length()/2 >= velocities[i]:
			stream = sounds[i]
			play()
			break

	print(body)
	if "velocities" in body and "sounds" in body and body.velocities != [] and body.sounds != []:
		print(body)
		for i in len(body.velocities):
			if prop_body.linear_velocity.length() + prop_body.angular_velocity.length()/2 >= body.velocities[i]:
				stream = body.sounds[i]
				play()
				break

	if prop_body.linear_velocity.length() + prop_body.angular_velocity.length()/2 >= break_speed and break_speed != 0:
		destroy()

func destroy():
	prop_body.remove_child(self)
	prop_body.get_parent().add_child(self)
	prop_body.queue_free()
