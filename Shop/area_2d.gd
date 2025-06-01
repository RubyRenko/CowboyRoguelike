extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
func _on_body_entered(body: Node2D) -> void:
	if body.name == "CowboyPlayer":
		var nav_arrow = body.get_node_or_null("nav_arrow")
		if nav_arrow:
			nav_arrow.hide()

func _on_body_exited(body: Node2D) -> void:
	if body.name == "CowboyPlayer":
		var nav_arrow = body.get_node_or_null("nav_arrow")
		if nav_arrow:
			nav_arrow.show()
