class_name EnemyLoot

static func CreateLoot(key : String, enemy : Node):
	if (key in BuyablePickup.Item_Details):
		var pickup : BuyablePickup = load("res://Items/BuyablePickup.tscn").instantiate()
		pickup.create_pickup(key)
		pickup.sold = true
		pickup.position = enemy.position
		enemy.get_tree().get_root().add_child(pickup)
	elif (key in DroppedPickup.Item_Details):
		var pickup : DroppedPickup = load("res://Items/DroppablePickup.tscn").instantiate()
		pickup.create_pickup(key)
		pickup.position = enemy.position
		enemy.get_tree().get_root().add_child(pickup)
	else:
		print_debug(key + "could not be found as a droppable!")
