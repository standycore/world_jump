extends Control

signal retry_pressed
signal quit_pressed

func _on_retry_button_pressed():
	retry_pressed.emit()


func _on_quit_button_pressed():
	get_tree().quit()
	quit_pressed.emit()
