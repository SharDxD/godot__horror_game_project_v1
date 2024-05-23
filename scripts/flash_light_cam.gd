extends Node3D

@onready var light: SpotLight3D = $SpotLight3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var rec_animation: AnimationPlayer = $rec_animation
@onready var batteties_label: Label = $Ui/Energy/FlowContainer/Label
@onready var rec_time_label: Label = $Ui/Recording/FlowContainer/MarginContainer/Label
@onready var ui_container: Control = $Ui
@onready var timer: Timer = $Timer
@onready var nigth_vision_mesh: MeshInstance3D = $NightVisionMesh
var elapsed_time = 0
var material: Material
@export var normal_speed = 1
@export var reduced_speed = 0.3

enum CAM_MODES {
	NIGHT_VISION_ON,
	NIGHT_VISION_OFF,
	POWER_OFF
}

var current_mode: CAM_MODES
var last_mode: CAM_MODES

func _ready():
	material = nigth_vision_mesh.get_active_material(0)
	light.light_energy = 0
	rec_animation.play("rec_animation")
	update_power_cells()
	Inventory.update_power_cells.connect(update_power_cells)
	#animation_player.play("Decrease Energy")
	#set_nightvision_enable(false)
	set_nightvision_mode(CAM_MODES.POWER_OFF)

func set_nightvision_mode(mode: CAM_MODES):
	if mode == CAM_MODES.NIGHT_VISION_ON:
		light.visible = true
		animation_player.speed_scale = normal_speed
		ui_container.visible = true
		material.set_shader_parameter("ENABLE_NIGHT_VISION", true)
		material.set_shader_parameter("ENABLE_NOISE", true)
	elif mode == CAM_MODES.NIGHT_VISION_OFF:
		light.visible = false
		ui_container.visible = true
		material.set_shader_parameter("ENABLE_NIGHT_VISION", false)
		material.set_shader_parameter("ENABLE_NOISE", true)
	elif mode == CAM_MODES.POWER_OFF:
		light.visible = false
		ui_container.visible = false
		animation_player.speed_scale = 0
		material.set_shader_parameter("ENABLE_NIGHT_VISION", false)
		material.set_shader_parameter("ENABLE_NOISE", false)
	current_mode = mode


#func set_nightvision_enable(is_enable: bool):
	#visible = is_enable
	#if is_enable:
		#animation_player.speed_scale = normal_speed
	#else:
		#animation_player.speed_scale = reduced_speed

func _input(event):
	if Input.is_action_just_pressed("flashlight"):
		update_power_cells()
	
	if event.is_action_pressed("Camera"):
		if current_mode == CAM_MODES.POWER_OFF:
			set_nightvision_mode(CAM_MODES.NIGHT_VISION_OFF)
			try_to_recharge()
			timer.start()
		elif current_mode == CAM_MODES.NIGHT_VISION_OFF:
			set_nightvision_mode(CAM_MODES.NIGHT_VISION_ON)
		elif current_mode == CAM_MODES.NIGHT_VISION_ON:
			set_nightvision_mode(CAM_MODES.POWER_OFF)
			timer.stop()
		return


	if current_mode == CAM_MODES.POWER_OFF:
		return

	if Input.is_action_just_pressed("Camera"):
		if current_mode == CAM_MODES.NIGHT_VISION_ON:
			set_nightvision_mode(CAM_MODES.NIGHT_VISION_OFF)
			#set_nightvision_enable(false)
			animation_player.pause()
			light.light_energy = 0
			return
		if not animation_player.assigned_animation:
			try_to_recharge()
			return
		if animation_player.current_animation_position == animation_player.current_animation_length:
			try_to_recharge()
		else:
			animation_player.play("Decrease Energy")
			#set_nightvision_enable(true)
			set_nightvision_mode(CAM_MODES.NIGHT_VISION_ON)
 
func update_power_cells():
	batteties_label.text = str(Inventory.power_cells) + "/" + str(Inventory.power_cells_limit)


func try_to_recharge():
	if Inventory.power_cells > 0:
		Inventory.power_cells -= 1
		#print("test")
		update_power_cells()
		animation_player.play("Decrease Energy")
		#set_nightvision_enable(true)
		set_nightvision_mode(CAM_MODES.NIGHT_VISION_ON)

func format_elapsed_time(_elapsed_time: int) -> String:
	var h = _elapsed_time / 3600.0
	var m = (_elapsed_time % 3600) / 60.0
	var s: int = _elapsed_time % 60
	var form_h: String = str(int(h)).pad_zeros(2)
	var form_m: String = str(int(m)).pad_zeros(2)
	var form_s: String = str(s).pad_zeros(2)
	#print("lol"+form_h + ":" + form_m + ":" + form_s)
	return form_h + ":" + form_m + ":" + form_s



func _on_timer_timeout():
	elapsed_time += 1
	var elapsed_str = format_elapsed_time(elapsed_time)
	#print(elapsed_str)
	rec_time_label.text = elapsed_str
