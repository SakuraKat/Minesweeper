extends Control

onready var select_sound: AudioStreamPlayer = $SelectSound
onready var select_hover_sound: AudioStreamPlayer = $SelectHoverSound

func _on_PlayButton_button_up() -> void:
	select_sound.play()
	get_tree().change_scene("res://src/main/Main.tscn")

func _on_QuitButton_button_up() -> void:
	get_tree().quit()

func _on__mouse_entered() -> void:
	select_hover_sound.play()
