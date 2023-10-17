extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func _on_resume_pressed():
	get_tree().paused = false
	queue_free()


func _on_surrender_pressed():
	var game_end = load("res://scenes/game_end.tscn").instantiate()
	game_end.force_loss = true
	get_tree().root.add_child(game_end)
	queue_free()
