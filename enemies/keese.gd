extends Enemy

var spawn_point
var target = 0

func _ready():
	spawn_point = position
	puppet_pos = position
	puppet_anim = "idleDown"

func _physics_process(delta):
	if !is_scene_owner() || is_dead():
		return
	loop_damage()
	loop_movement()
	if typeof(target) != TYPE_INT:
		movedir = (target.get_position() - self.get_position()).normalized()
		anim_switch("flying")
	else:
		movedir = (spawn_point - self.get_position()).normalized()
		anim_switch("idle")

func puppet_update():
	position = puppet_pos
	if anim.current_animation != puppet_anim:
		anim.play(puppet_anim)
		
func _process(delta):
	loop_network()

func back_to_spawn(body):
	if(body.has_method("get_type")):
		if body.get_type() == "PLAYER":
			target = 0

func get_target(body):
	if(body.has_method("get_type")):
		if body.get_type() == "PLAYER":
			target = body
