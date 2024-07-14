class_name MainMenu

extends Control

@onready var start_buton = $MarginContainer/HBoxContainer/VBoxContainer/Start_Button as Button
@onready var exit_buton = $MarginContainer/HBoxContainer/VBoxContainer/Exit_Button as Button
@onready var start_level = preload("res://main.tscn") as PackedScene


func _ready():
	start_buton.button_down.connect(on_start_pressed)
	
	
func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)
	
	
