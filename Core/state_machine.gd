class_name StateMachine

extends Node

var state : int = -1:
	set(val):
		if state != val:
			owner.on_state_change(state, val)
			state = val

var frames : int = 0
var times : float = 0.0
var old_state : int = -1
var enable : bool = true

func _ready() -> void:
	Log.d("%s %s" % [owner.name, name], "_ready")
	if not owner.is_node_ready():
		await owner.ready
	state = 0

func _physics_process(delta: float) -> void:
	if enable:
		owner.on_state_start(state, delta)
		while true:
			var next : int = owner.get_next_state(state)
			if state != next:
				frames = 0
				times = 0.0
				old_state = state
				owner.on_state_start(next, delta)
				state = next
			else:
				frames += 1
				times += delta
			break
		owner.on_state_end(state, delta)


