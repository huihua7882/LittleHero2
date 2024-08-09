class_name AboutGame

extends Control

@onready var btn_back: Button = $BtnBack

func _ready() -> void:
	btn_back.pressed.connect(func ():
		Game.change_scene_title()
	)
	SoundManager.setup_ui_sounds(self, btn_back)
