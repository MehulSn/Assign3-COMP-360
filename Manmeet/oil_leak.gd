extends GPUParticles3D

#
@export var min_leak_rate: float = 2.0   # Drips per second when idle
@export var max_leak_rate: float = 50.0  # Drips per second when moving
@export var velocity_threshold: float = 0.1


@onready var robot = get_parent()

func _ready():
	
	emitting = true
	amount = int(max_leak_rate) * 2 # Buffer size
	one_shot = false

func _process(delta):
	var current_speed = robot.velocity.length()
	var target_amount = 0.0
	
	if current_speed > velocity_threshold:
		target_amount = max_leak_rate
	else:
		target_amount = min_leak_rate
	
	if randf() > 0.9: 
		target_amount *= 1.5 
	amount_ratio = move_toward(amount_ratio, target_amount / max_leak_rate, delta * 2.0)
