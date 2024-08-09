class_name HealthBar

extends Node2D

@onready var label: Label = $VBoxContainer/Label
@onready var texture_progress_bar_green: TextureProgressBar = $VBoxContainer/TextureProgressBar
@onready var texture_progress_bar_red: TextureProgressBar = $VBoxContainer/TextureProgressBar/TextureProgressBar
@onready var statistic: Statistic = $"../Statistic"

var duration: float = 0.3
#@export var show_bar: bool = false:
	#set(val):
		#if show_bar != val:
			#show_bar = val
			#if show_bar:
				#texture_progress_bar_green.show()
			#else:
				#texture_progress_bar_green.hide()

func _ready() -> void:
	Log.d("%s %s" % [owner.name, name], "_ready")
	label.set("theme_override_colors/font_color", Color(255, 0, 0, 0))
	label.set("theme_override_colors/font_outline_color", Color(0, 0, 0, 0))
	statistic.health_change.connect(on_health_change)
	# show_bar = false
	if statistic != null:
		update(true)

func on_health_change() -> void:
	update()

func update(skip_anim : bool = false) -> void:
	label.text = "%s" % statistic.reduce
	var percentage : float = statistic.health / float(statistic.max_health)
	#Log.d(name, "reduce %s percentage %s" % [statistic.reduce, percentage])
	texture_progress_bar_green.value = percentage

	if skip_anim:
		texture_progress_bar_red.value = percentage
	else:
		create_tween().tween_property(texture_progress_bar_red, "value", percentage, duration)
		var tween := create_tween()
		if statistic.reduce < 0:
			label.set("theme_override_colors/font_color", Color(255, 0, 0, 1))
			label.set("theme_override_colors/font_outline_color", Color(0, 0, 0, 1))
			tween.tween_property(label, "theme_override_colors/font_color", Color(255, 0, 0, 0), duration)
			tween.tween_property(label, "theme_override_colors/font_outline_color", Color(0, 0, 0, 0), duration)
		else:
			label.set("theme_override_colors/font_color", Color(0, 255, 0, 1))
			label.set("theme_override_colors/font_outline_color", Color(0, 0, 0, 1))
			tween.tween_property(label, "theme_override_colors/font_color", Color(0, 255, 0, 0), duration)
			tween.tween_property(label, "theme_override_colors/font_outline_color", Color(0, 0, 0, 0), duration)
		Engine.time_scale = 0.1
		await get_tree().create_timer(0.3, true, false, true).timeout
		Engine.time_scale = 1
		await tween.finished
