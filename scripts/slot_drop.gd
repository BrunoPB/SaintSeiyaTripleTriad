extends PanelContainer

@onready var play = get_node("/root/Play")

# Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Exiting the whole table
func _on_table_area_mouse_exited():
	play.target_slot = null

func _on_slot_area_mouse_entered():
	play.target_slot = self
