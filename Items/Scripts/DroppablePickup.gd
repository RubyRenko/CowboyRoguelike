class_name DroppablePickup extends Area2D

var item_key : String
@export var texture_sprite : Sprite2D
@export var collider : CollisionShape2D

static var Item_Details : Dictionary = {
										"coin" : {
											"texture_path": "res://Assets/hud assets/coins-03.png",
											"function" : func(player): 
												player.money += 1
												player.audio.play_sfx("coin"),
										},
										"beans" : {
											"texture_path": "res://Assets/ItemSprites/can o beans-02.png",
											"function" : func(player): 
														player.hp += 2
														player.itemaudio.play()
														if player.hp > player.max_hp:
															player.hp = player.max_hp,
													
										},
										"jerky" : {
											"texture_path": "res://Assets/ItemSprites/jerky-02.png",
											"function" : func(player): 
														player.hp += 1
														player.itemaudio.play()
														if player.hp > player.max_hp:
															player.hp = player.max_hp,
										}
									}

func create_pickup(key : String):
	item_key = key
	texture_sprite.texture = load(Item_Details[key]["texture_path"])
	if item_key == "coin":
		texture_sprite.scale = Vector2(0.01, 0.01);
		collider.shape.radius = 14
	
func _on_body_entered(body):
	if body.name == "CowboyPlayer":
		var function : Callable = Item_Details[item_key]["function"]
		function.call(body)
	queue_free()

func _on_despawn_timer_timeout():
	queue_free()
