extends Area2D

# Called when the node enters the scene tree for the first time.
	
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
func _on_body_entered(body: Node2D) -> void:
	if body.name == "CowboyPlayer":
		var E_interact = body.get_node_or_null("E_interact")
		if E_interact:
			E_interact.show()

func _on_body_exited(body: Node2D) -> void:
	if body.name == "CowboyPlayer":
		var E_interact = body.get_node_or_null("E_interact")
		if E_interact:
			E_interact.hide()
