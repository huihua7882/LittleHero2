class_name GameOver

extends Control

@onready var btn_back: Button = $BtnBack
@onready var label: Label = $Label
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	btn_back.pressed.connect(func ():
		Game.change_scene_title()
	)
	SoundManager.setup_ui_sounds(self, btn_back)
	SoundManager.stop()

func set_title(title : String) -> void:
	label.text = title
	#Log.d(name, "%s %s" % [
		#label.text.find("打败大魔王"),
		#label.text
	#])
	if label.text.find("打败大魔王") > 0:
		audio_stream_player.stream = preload("res://Assets/Audio/Dialogue/Victory01.wav")
	else:
		audio_stream_player.stream = preload("res://Assets/Audio/Dialogue/Fail01.wav")
	audio_stream_player.play()
	label.set("visible_ratio", 0)
	var tween := create_tween()
	# tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS) # 该参数控制不允许多个动画同时执行
	tween.tween_property(label, "visible_ratio", 1, 2.5)
	await tween.finished
	btn_back.show()
