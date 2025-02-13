extends Area2D

var sold = false
var near = false
var can_buy = false
var price = 10
@onready var player = get_tree().get_root().get_node("Main").get_node("CowboyPlayer")

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if near and can_buy and Input.is_action_just_pressed("interact"):
		sold = true
		player.money -= price
		player.melee_dmg += 2
		queue_free()

func _on_body_entered(body):
	#print("body detected")
	if body.name == "CowboyPlayer" and sold:
		#print("add 1 heart")
		body.melee_dmg += 2
		#print(body.hp)
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
