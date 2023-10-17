extends PanelContainer

# Called when the node enters the scene tree for the first time.
#func _ready():

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Exiting the whole table
func _on_table_area_mouse_exited():
	get_node("/root/Game").play.target_slot = null

func _on_slot_area_mouse_entered():
	get_node("/root/Game").play.target_slot = self
