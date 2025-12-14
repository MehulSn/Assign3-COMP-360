extends Node3D

@onready var mat: ShaderMaterial = $ShaderDemo.material_override

func _process(delta: float) -> void:
	if mat:
		mat.set_shader_parameter("time", Time.get_ticks_msec() / 500.0)
