extends Area2D

var sold = false
var near = false
var can_buy = false
var price = 10
@onready var player = get_tree().get_root().get_node("Main").get_node("CowboyPlayer")
@onready var shop = get_parent()

func _ready():
	hide_desc()
	if sold:
		$DespawnTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if near and can_buy and Input.is_action_just_pressed("interact"):
		sold = true
		shop.audio.play_sfx("buy")
		player.money -= price
		player.armor += 2
		queue_free()
	elif near and Input.is_action_just_pressed("interact"):
		shop.audio.play_sfx("no_funds")

func _on_body_entered(body):
	#print("body detected")
	if body.name == "CowboyPlayer" and sold:
		body.armor += 2
		queue_free()

func _on_selling_interface_body_entered(body):
	if body.name == "CowboyPlayer" and not(sold):
		near = true
		show_desc()
		if body.money >= price:
			can_buy = true
		else:
			can_buy = false

func _on_selling_interface_body_exited(body):
	near = false
	can_buy = false
	hide_desc()

func show_desc():
	$TextBox.visible = true
	$Title.visible = true
	$Description.visible = true

func hide_desc():
	$TextBox.visible = false
	$Title.visible = false
	$Description.visible = false

func _on_despawn_timer_timeout():
	queue_free()
