extends StaticBody2D

export(String, "RUPEE", "HEALTH") var content = "RUPEE"

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
	var drop_choice = 0
	match content:
		"RUPEE":
			drop_choice = "res://droppables/rupee.tscn"
		"HEALTH":
			drop_choice = "res://droppables/heart.tscn"
	var pos = Vector2(node.global_position.x, node.global_position.y)#Spawn in the player position
	var subitem_name = str(randi()) # we need to sync names to ensure the subitem can rpc to the same thing for others
	network.current_map.spawn_subitem(drop_choice, pos, subitem_name) # has to be from game.gd bc the node might have been freed beforehand
	for peer in network.map_peers:
		network.current_map.rpc_id(peer, "spawn_subitem", drop_choice, pos, subitem_name)
	
remote func update_chest():
	if is_open && is_scene_owner():
		rpc("open_chest")

sync func open_chest():
	is_open = true
	chest_sprite.frame = 2
	
func is_scene_owner():
	if !network.map_owners.keys().has(network.current_map.name):
		return false
	if network.map_owners[network.current_map.name] == get_tree().get_network_unique_id():
		return true
	return false
