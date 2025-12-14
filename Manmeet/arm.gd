extends CharacterBody3D

@onready var spring_arm_pivot = $SpringArmPivot
@onready var spring_arm = $SpringArmPivot/SpringArm3D
@onready var armature = $Armature
@onready var anim_tree = $AnimationTree
@onready var game_message_label = $"CanvasLayer/GameMessageLabel" 


const SPEED = 5.0
const JUMP_VELOCITY = 5.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# --- MISSION VARIABLES ---
var held_object = null
var start_time = 0 # Time recorded when the ball is picked up
var is_mission_complete = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Ensure the message is hidden when the game starts
	game_message_label.hide() 

func _unhandled_input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	
	# Interaction/Camera controls are disabled after victory
	if not is_mission_complete:
		# CAMERA CONTROL
		if event is InputEventMouseMotion:
			spring_arm_pivot.rotate_y(-event.relative.x * 0.0025)
			spring_arm.rotate_x(-event.relative.y * 0.0025)
			spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4)
			
		# --- PICK UP / DROP (Key: SPACEBAR) ---
		# 1st Press: Grab ball and start timer.
		# 2nd Press: Drop ball (or complete mission if at ramp).
		if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
			if held_object:
				check_drop_zone()
			else:
				grab_object_by_math()

func grab_object_by_math():
	var ball = get_tree().current_scene.find_child("Ball", true, false)
	if ball:
		var distance = global_position.distance_to(ball.global_position)
		if distance < 3.0:
			# START THE TIMER HERE
			start_time = Time.get_ticks_msec()
			print("--- TIMER STARTED! ---")
			
			held_object = ball
			held_object.freeze = true
			held_object.set_deferred("collision_layer", 0)
			held_object.set_deferred("collision_mask", 0)

func check_drop_zone():
	# Check if the player is at the victory spot (Ramp X > 5)
	if global_position.x > 5:
		trigger_victory()
	else:
		drop_object_normal()

func drop_object_normal():
	if held_object:
		held_object.freeze = false
		held_object.set_deferred("collision_layer", 1)
		held_object.set_deferred("collision_mask", 1)
		held_object.apply_impulse(-transform.basis.z * 5.0)
		held_object = null

func trigger_victory():
	if is_mission_complete:
		return 
		
	is_mission_complete = true
	
	# --- TIMER CALCULATION AND SCREEN OUTPUT ---
	var end_time = Time.get_ticks_msec()
	var duration_ms = end_time - start_time
	var duration_seconds = float(duration_ms) / 1000.0
	
	# Create the final message for the screen
	var message = "MISSION COMPLETED!\n"
	message += "CONGRATULATIONS!\n"
	# Using the compatible % operator for time display
	message += "Time taken: %.2f seconds" % duration_seconds 
	
	# Display the message on the screen and stop the game
	game_message_label.text = message
	game_message_label.show()
	print("\n--- VICTORY! Mission Complete in: " + str(duration_seconds) + " seconds. ---")
	
	# Release the held object (the ball)
	if held_object:
		held_object.freeze = false
		held_object.set_deferred("collision_layer", 1)
		held_object.set_deferred("collision_mask", 1)
		held_object = null

func _physics_process(delta):
	# --- GAME OVER STATE ---
	if is_mission_complete:
		# Stops robot instantly and permanently
		velocity = Vector3.ZERO
		move_and_slide() 
		return 
	
	# MAGNET HOLDING
	if held_object and is_instance_valid(held_object):
		var target = global_position + Vector3(0, 2.0, 0) + (-transform.basis.z * 1.5)
		held_object.global_position = target

	# --- GRAVITY ---
	if not is_on_floor():
		velocity.y -= gravity * delta

	# --- JUMPING: KEY J ---
	if Input.is_key_pressed(KEY_J) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# MOVEMENT
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP, spring_arm_pivot.rotation.y)
	direction.y = 0

	if direction:
		velocity.x = lerp(velocity.x, direction.x * SPEED, 0.15)
		velocity.z = lerp(velocity.z, direction.z * SPEED, 0.15)
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-velocity.x, velocity.z), 0.15)
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.15)
		velocity.z = lerp(velocity.z, 0.0, 0.15)
	
	
	anim_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() / SPEED)
	move_and_slide()
