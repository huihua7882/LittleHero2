class_name Statistic

extends Node

signal health_change()

var reduce : int = 0

@export var max_health : int = 6000:
	set(val):
		if max_health != val:
			max_health = val
			health_change.emit()

@onready var health : int = max_health:
	set(val):
		val = clampi(val, 0, max_health)
		Log.d(owner.name, "val %s" % val)
		if health != val:
			reduce = val - health
			# reduce = health - val
			health = val
			health_change.emit()

@export var attack : int = 100
#@export var defense : int = 10
#@export var speed : int = 10

func _ready() -> void:
	Log.d("%s %s" % [owner.name, name], "_ready")
