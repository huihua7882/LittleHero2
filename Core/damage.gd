class_name Damage

extends Node

var hit : Character = null
var hurt : Character = null

func _init() -> void:
	#Log.d(name, "_init")
	pass

func _ready() -> void:
	#Log.d(name, "_ready")
	pass

func set_hit(h : Character) -> void:
	hit = h

func set_hurt(h : Character) -> void:
	hurt = h

func get_damage() -> int:
	var injure : int = hit.statistic.attack
	#Log.d("FlyingEye", "injure %s %s" % [
		#injure,
		#Character.State.keys()[hit.state_machine.state]
	#])
	if hit.state_machine.state == Character.State.ATTACK1:
		injure *= 0.9
	elif hit.state_machine.state == Character.State.ATTACK2:
		injure *= 1.0
	elif hit.state_machine.state == Character.State.ATTACK3:
		injure *= 1.1
	elif hit.state_machine.state == Character.State.MAGIC1:
		injure *= 3.0
	#Log.d("FlyingEye", "injure2 %s" % injure)
	injure = randi_range(injure - injure * 0.05, injure + injure * 0.05)
	#Log.d("FlyingEye", "injure3 %s" % injure)
	return clampi(injure, 1, 9999)
