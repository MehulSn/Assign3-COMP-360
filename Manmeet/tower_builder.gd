extends Node3D

func _ready():
	var height = 5
	
	# TASK 1: Build the Pyramid (The Structure)
	for y in range(height):
		var layer_size = height - y
		for x in range(layer_size):
			for z in range(layer_size):
				spawn_block(x, y, z, layer_size)
	
	# TASK 2: Spawn the Beacon (The Lighting)
	spawn_beacon(height)

func spawn_block(x, y, z, layer_size):
	var block = CSGBox3D.new()
	block.size = Vector3(1, 1, 1)
	block.use_collision = true
	# Center the pyramid and move it to the LEFT (-8)
	var x_pos = x - (layer_size * 0.5)
	var z_pos = z - (layer_size * 0.5)
	block.position = Vector3(-8 + x_pos, 0.5 + y, 0 + z_pos)
	add_child(block)

func spawn_beacon(height):
	# Scripting a light source automatically
	var light = OmniLight3D.new()
	light.light_color = Color(1, 0.5, 0) # Orange Glow
	light.light_energy = 5.0
	light.omni_range = 15.0
	
	# Place it exactly on top of the pyramid
	# X = -8.5 (Center of pyramid), Y = Height + 1
	light.position = Vector3(-8.5, height + 1, 0)
	
	add_child(light)
