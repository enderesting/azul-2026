extends Control

@onready var menu_container: MarginContainer = %MenuContainer


func _on_exit_selector_pressed() -> void:
	hide()
	menu_container.show()
