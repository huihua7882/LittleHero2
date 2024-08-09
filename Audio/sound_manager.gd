# class_name SoundManager

extends Node

enum Bus {
	MASTER,
	SFX,
	BGM,
}

const AUDIO : String = "audio"
const CONFIG_PATH := "user://config.ini"

@onready var sfx: Node = $SFX
@onready var bgm_player: AudioStreamPlayer = $BGMPlayer

const BGM1 = preload("res://Assets/Audio/Music/Apple Cider.mp3")
const BGM2 = preload("res://Assets/Audio/Music/Insect Factory.mp3")
const BGM3 = preload("res://Assets/Audio/Music/squashin_bugs_fixed.mp3")
const BGM4 = preload("res://Assets/Audio/Music/the_fun_run.mp3")

func _ready() -> void:
	load_config()

func play_sfx(name : String) -> void:
	var player := sfx.get_node(name) as AudioStreamPlayer
	if player:
		player.play()

func setup_ui_sounds(node : Node, def_focus : Node = null) -> void:
	var button := node as Button
	if button:
		if button == def_focus:
			button.grab_focus()
		button.focus_entered.connect(play_sfx.bind("UIFocus"))
		button.pressed.connect(play_sfx.bind("UIPress"))
		button.mouse_entered.connect(button.grab_focus)
	var slider := node as Slider
	if slider:
		if slider == def_focus:
			slider.grab_focus()
		slider.focus_entered.connect(play_sfx.bind("UIFocus"))
		slider.value_changed.connect(play_sfx.bind("UIPress").unbind(1))
		slider.mouse_entered.connect(slider.grab_focus)

	for child in node.get_children():
		setup_ui_sounds(child, def_focus)

func stop() -> void:
	if bgm_player.playing:
		bgm_player.stop()

func play_bgm_random(mark : bool = false) -> void:
	if not bgm_player.playing or mark:
		var index : int = randi_range(1, 4)
		match index:
			1:
				SoundManager.play_bgm(BGM1)
			2:
				SoundManager.play_bgm(BGM2)
			3:
				SoundManager.play_bgm(BGM3)
			4:
				SoundManager.play_bgm(BGM4)

func play_bgm(stream : AudioStream) -> void:
	if bgm_player.stream != stream:
		bgm_player.stream = stream
		bgm_player.play()
	if not bgm_player.playing:
		bgm_player.play()

func get_volume(bus_index : int) -> float:
	var db = AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(db)

func set_volume(bus_index : int, val : float) -> void:
	var db = linear_to_db(val)
	AudioServer.set_bus_volume_db(bus_index, db)
	save_config()

func save_config() -> void:
	var config := ConfigFile.new()
	config.set_value(AUDIO, "master", get_volume(Bus.MASTER))
	config.set_value(AUDIO, "sfx", get_volume(Bus.SFX))
	config.set_value(AUDIO, "bgm", get_volume(Bus.BGM))
	config.save(CONFIG_PATH)

func load_config() -> void:
	var config := ConfigFile.new()
	config.load(CONFIG_PATH)

	set_volume(
		SoundManager.Bus.MASTER,
		config.get_value(AUDIO, "master", 0.5)
		# 0.5
	)

	set_volume(
		SoundManager.Bus.SFX,
		config.get_value(AUDIO, "sfx", 1.0)
		# 1.0
	)

	set_volume(
		SoundManager.Bus.BGM,
		config.get_value(AUDIO, "bgm", 0.5)
		# 0.5
	)

func load_default() -> void:
	set_volume(Bus.MASTER, 0.5)
	set_volume(Bus.SFX, 1.0)
	set_volume(Bus.BGM, 0.5)
