extends Node3D

func _ready():
	# Loop to create 5 lights automatically
	for i in range(5):
		var light = OmniLight3D.new()
		
		# Set settings
		light.light_energy = 2.0
		light.omni_range = 10.0
		
		# Position them in a row: (0, 3, -5), (0, 3, -10), etc.
		# The 'i * -10' spreads them out every 10 meters forward
		light.position = Vector3(0, 3, i * -10)
		
		# Add to the game
		add_child(light)
