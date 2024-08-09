class_name Setting

extends Control

@onready var btn_back: Button = $BtnBack
@onready var btn_reset: Button = $VBoxContainer/BtnReset
@onready var volume_slider_1: VolumeSlider = $VBoxContainer/GridContainer/VolumeSlider1
@onready var volume_slider_2: VolumeSlider = $VBoxContainer/GridContainer/VolumeSlider2
@onready var volume_slider_3: VolumeSlider = $VBoxContainer/GridContainer/VolumeSlider3

func _ready() -> void:
	btn_back.pressed.connect(Game.change_scene_title)
	btn_reset.pressed.connect(func ():
		SoundManager.load_default()
		volume_slider_1.value = SoundManager.get_volume(SoundManager.Bus.MASTER)
		volume_slider_2.value = SoundManager.get_volume(SoundManager.Bus.BGM)
		volume_slider_3.value = SoundManager.get_volume(SoundManager.Bus.SFX)
	)

	SoundManager.setup_ui_sounds(self, btn_back)
