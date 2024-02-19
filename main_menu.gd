extends Node2D


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://game.tscn")


func _on_credits_button_pressed():
	get_node("Creditos").visible = true
	get_node("BackButton").visible = true


func _on_back_button_pressed():
	get_node("Creditos").visible = false
	get_node("BackButton").visible = false
