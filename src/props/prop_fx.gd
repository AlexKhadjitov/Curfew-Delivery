extends AudioStreamPlayer3D

@onready var prop_body: RigidBody3D = $"../"

@export var break_speed: float
@export var velocities: Array[float]
@export var sounds: Array[AudioStream]

func _ready():
	prop_body.contact_monitor = true
	prop_body.max_contacts_reported = 1
	prop_body.body_entered.connect(body_entered)


func body_entered(body):
	for i in len(velocities):
		if prop_body.linear_velocity.length() >= velocities[i]:
			stream = sounds[i]
			play()
			break

	if prop_body.linear_velocity.length() >= break_speed and break_speed != 0:
		destroy()

func destroy():
	prop_body.remove_child(self)
	prop_body.get_parent().add_child(self)
	prop_body.queue_free()
