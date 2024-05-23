extends Node3D


@onready var light: SpotLight3D = $SpotLight3D
@export var energy_curve: Curve = Curve.new()

var max_energy
var elapsed_time = 0
#var flash : bool

func _ready():
	max_energy = light.light_energy

func _process(delta):
	elapsed_time += delta
	_decrease_energy()
	
func _decrease_energy():
	if elapsed_time >= energy_curve.max_value:
		light.light_energy = 0
		#elapsed_time = 0
		set_process(false)
	else:
		var percentage = energy_curve.sample(elapsed_time/energy_curve.max_value)
		percentage /= energy_curve.max_value
		light.light_energy = max_energy * percentage

func _input(event):
	if Input.is_action_just_pressed("flashlight"):
		if is_processing():
			set_process(false)
			light.light_energy = 0
		else:
			try_to_recharge()

	#if Input.is_action_just_pressed("flashlight"):
		#if flash:
			#$AnimationPlayer.play("offflashlight")
		#else:
			#$AnimationPlayer.play("onflashlight")
		#flash = !flash

func try_to_recharge():
	if Inventory.power_cells > 0:
		Inventory.power_cells -= 1
		elapsed_time = 0
		set_process(true)
	else:
		set_process(false)
