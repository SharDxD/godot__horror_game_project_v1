extends Control

@onready var main = $"../"

var button_pressed : bool
var toggled_on : bool

func _on_resume_pressed():
	main.pauseMenu()

func _on_quit_pressed():
	get_tree().quit()


func _on_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_music_switch_button_down():
	$AudioStreamPlayer2D.stop()


func _on_music_switch_button_up():
	$AudioStreamPlayer2D.play()


func _on_level_2_pressed():
	get_tree().change_scene_to_file("res://Scenes/level2.tscn")


func _on_level_1_pressed():
	get_tree().change_scene_to_file("res://Scenes/level_1_test.tscn")


func _on_music_switch_pressed(button_pressed):
	if button_pressed:
		$AudioStreamPlayer2D.play()
	else:
		$AudioStreamPlayer2D.stop()
