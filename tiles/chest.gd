extends StaticBody2D

var is_open = false
var chest_sprite

func _ready():
	add_to_group("interact")
	add_to_group("nopush")
	
	chest_sprite = get_node("Sprite")
	chest_sprite.frame = 0
	
	rpc("update_chest")
	
func interact(node):
	if(is_open == false):
		rpc("open_chest")
		get_chest_content(node)

func get_chest_content(node):
	pass
	
remote func update_chest():
	if is_open:
		rpc("open_chest")

sync func open_chest():
	is_open = true
	chest_sprite.frame = 2
