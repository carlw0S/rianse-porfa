class_name GameOver extends Node2D


var final_score: int = 0
@onready var final_score_label: Label = get_node("FinalScore")


func set_final_score(value: int):
	final_score = value


func _ready():
	final_score_label.set_text(str("Puntuación final: ", final_score))


func _on_retry_button_pressed():
	get_tree().change_scene_to_file("res://game.tscn")


func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")
