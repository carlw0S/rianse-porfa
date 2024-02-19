class_name JokeOption extends Node2D


signal option_selected(is_correct_option: bool)


@onready var is_correct_option: bool = false


func set_text(value: String):
	get_node("Button/Label").set_text(value)


func set_is_correct_option(value: bool = true):
	is_correct_option = value


func _ready():
	connect("option_selected", Callable(get_parent(), "_on_option_selected"))


func _on_button_pressed():
	emit_signal("option_selected", is_correct_option)
