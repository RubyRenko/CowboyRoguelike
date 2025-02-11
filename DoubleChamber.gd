extends Area2D

var sold = false
var near = false
var can_buy = false
var price = 5
@onready var player = get_tree().get_root().get_node("Main").get_node("CowboyPlayer")

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if near and can_buy and Input.is_action_just_pressed("interact"):
		sold = true
		player.money -= price
		can_buy = false
		$Description.text = "Double Chamber heart sold!"

func _on_body_entered(body):
	#print("body detected")
	if body.name == "CowboyPlayer" and sold:
		body.max_ammo += 6
		body.ammo += 6
		queue_free()

func _on_selling_interface_body_entered(body):
	if body.name == "CowboyPlayer" and not(sold):
		near = true
		$Description.visible = true
		if body.money >= price:
			can_buy = true
		else:
			can_buy = false

func _on_selling_interface_body_exited(body):
	near = false
	can_buy = false
	$Description.visible = false
