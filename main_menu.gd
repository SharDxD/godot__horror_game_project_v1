extends Control

var button_pressed : bool
var toggled_on : bool

func _on_start_game_pressed():
	get_tree().change_scene_to_file("res://Scenes/level_1_test.tscn")
	
func _on_end_game_pressed():
	get_tree().quit()

func _on_music_switch_button_down():
	$AudioStreamPlayer2D.stop()


func _on_music_switch_button_up():
	$AudioStreamPlayer2D.play()

#

func _on_music_switch_toggled(button_pressed):
	if button_pressed:
		$AudioStreamPlayer2D.play()
	else:
		$AudioStreamPlayer2D.stop()
		



func _on_fullscreen_switch_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(3, 0)
	else:
		DisplayServer.window_set_mode(0, 0)



func _on_level_2_pressed():
	get_tree().change_scene_to_file("res://Scenes/level2.tscn")
