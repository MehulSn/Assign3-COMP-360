extends Node3D

func _ready():
	# 1. FIND THE OBJECTS IN THE SCENE
	# We search for them by name so we don't need direct paths
	var ground = get_tree().current_scene.find_child("Ground", true, false)
	var ramp = get_tree().current_scene.find_child("Ramp", true, false)
	var ball = get_tree().current_scene.find_child("Ball", true, false)
	
	# 2. PAINT THE GROUND (Grass Green)
	if ground:
		var grass_mat = StandardMaterial3D.new()
		grass_mat.albedo_color = Color(0.1, 0.5, 0.1) # Dark Green
		# Apply to the mesh
		ground.material_override = grass_mat
		print("Painted Ground Green")
		
	# 3. PAINT THE RAMP (Target Red)
	if ramp:
		var ramp_mat = StandardMaterial3D.new()
		ramp_mat.albedo_color = Color(0.8, 0.1, 0.1) # Bright Red
		# Make it slightly glowing so it looks important
		ramp_mat.emission_enabled = true
		ramp_mat.emission = Color(0.5, 0, 0)
		ramp.material = ramp_mat
		print("Painted Ramp Red")
		
	# 4. PAINT THE BALL (Shiny Gold)
	if ball:
		# The Ball is a RigidBody, the color sits on the MeshInstance inside it
		var mesh = ball.get_node_or_null("MeshInstance3D")
		if mesh:
			var gold_mat = StandardMaterial3D.new()
			gold_mat.albedo_color = Color(1.0, 0.84, 0.0) # Gold
			gold_mat.metallic = 1.0  # Make it look like metal
			gold_mat.roughness = 0.2 # Make it shiny
			mesh.material_override = gold_mat
			print("Painted Ball Gold")
