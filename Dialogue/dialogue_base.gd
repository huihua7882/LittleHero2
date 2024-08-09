class_name DialogueBase

extends Control

@export var dialogue_gdscript : GDScript = null:
	set(val):
		if dialogue_gdscript != val:
			dialogue_gdscript = val
			dialogue_engine = dialogue_gdscript.new()
			dialogue_engine.dialogue_started.connect(__on_dialogue_started)
			dialogue_engine.dialogue_continued.connect(__on_dialogue_continued)
			dialogue_engine.dialogue_finished.connect(__on_dialogue_finished)
			dialogue_engine.dialogue_cancelled.connect(__on_dialogue_cancelled)
var dialogue_engine : DialogueEngine = null

@onready var label: Label = $HBoxContainer/Label
@onready var rich_text_label: RichTextLabel = $HBoxContainer/RichTextLabel
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var tween : Tween = null

func _ready() -> void:
	Log.d(name, "_ready")
	SoundManager.stop()
	rich_text_label.set_use_bbcode(true)
	rich_text_label.set_fit_content(true)
	
	hide_doalogue()

func show_doalogue() -> void:
	if not visible:
		show()
		set_process_input(true)
		dialogue_engine.advance()

func hide_doalogue() -> void:
	set_process_input(false)
	hide()

func _input(event: InputEvent) -> void:
	get_window().set_input_as_handled()
	if (event is InputEventKey or
		event is InputEventMouseButton or
		event is InputEventJoypadButton):
			if event.is_pressed() and not event.is_echo():
				Log.d(name, "tween %s %s" % [visible, tween])
				if tween != null:
					cancel_tween()
				elif visible:
					dialogue_engine.advance()

func __on_dialogue_started() -> void:
	Log.d(name, "__on_dialogue_started")
	#talk = true

func cancel_tween() -> void:
	if tween != null:
		tween.stop()
		tween = null
		rich_text_label.set("visible_ratio", 1)

func __on_dialogue_continued(p_dialogue_entry : DialogueEntry) -> void:
	# print("__on_dialogue_continued %s" % p_dialogue_entry.get_text())
	cancel_tween()
	var author := p_dialogue_entry.get_metadata(Game.AUTHOR) as String
	if author:
		label.text = author + ":"
	var audio := p_dialogue_entry.get_metadata(Game.AUDIO) as Resource
	if audio:
		if audio_stream_player.playing:
			audio_stream_player.stop()
		audio_stream_player.stream = audio
		audio_stream_player.finished.connect(func ():
			if visible:
				dialogue_engine.advance()
		)
		audio_stream_player.play()
	rich_text_label.text = p_dialogue_entry.get_text()
	rich_text_label.set("visible_ratio", 0)
	tween = create_tween()
	# tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS) # 该参数控制不允许多个动画同时执行
	Log.d(name, "length %s" % rich_text_label.text.length())
	tween.tween_property(rich_text_label, "visible_ratio", 1, rich_text_label.text.length() * 0.1)
	tween.finished.connect(func ():
		Log.d(name, "tween.finished")
		tween = null
	)

func __on_dialogue_finished() -> void:
	Log.d(name, "__on_dialogue_finished")
	#talk = false
	hide_doalogue()

func __on_dialogue_cancelled() -> void:
	Log.d(name, "__on_dialogue_cancelled")
	#talk = false
	hide_doalogue()
