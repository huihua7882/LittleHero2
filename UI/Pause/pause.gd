class_name Pause

extends Control

@onready var btn_continue: Button = $VBoxContainer/HBoxContainer/BtnContinue
@onready var btn_title: Button = $VBoxContainer/HBoxContainer/BtnTitle

func _ready() -> void:
	btn_continue.pressed.connect(func ():
		hide()
		set_process_input(false)
	)
	btn_title.pressed.connect(func ():
		Game.change_scene_title()
	)
	hide()
	set_process_input(false)
	SoundManager.setup_ui_sounds(btn_continue)

func show_pause() -> void:
	show()
	set_process_input(true)
