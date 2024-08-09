class_name TitleScene

extends Control

@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var new_game: Button = $VBoxContainer/NewGame
@onready var setting: Button = $VBoxContainer/Setting
@onready var about_game: Button = $VBoxContainer/AboutGame
@onready var exit_game: Button = $VBoxContainer/ExitGame

func _ready() -> void:
	new_game.grab_focus()
	new_game.pressed.connect(func ():
		for key in Game.enemys.keys():
			var item : Dictionary = Game.enemys[key]
			# Log.d(name, "item %s DEATH %s" % [item, item[Game.DEATH]])
			item[Game.DEATH] = false
		
		Game.change_scene_prelude()
	)
	setting.pressed.connect(func ():
		Game.change_scene_setting()
	)
	about_game.pressed.connect(func ():
		Game.change_scene_about_game()
	)
	exit_game.pressed.connect(func ():
		get_tree().quit()
	)
	SoundManager.play_bgm_random()
	SoundManager.setup_ui_sounds(self)
