class_name VolumeSlider

extends HSlider

@export var bus : StringName = "Master"

@onready var bus_index := AudioServer.get_bus_index(bus)

func _ready() -> void:
	value = SoundManager.get_volume(bus_index)
	Log.d(name, "_ready %s" % value)
	value_changed.connect(func (vol : float):
		SoundManager.set_volume(bus_index, vol)
	)
	# SoundManager.play_bgm(preload("res://Assets/Audio/Music/Apple Cider.mp3"))
