extends Node2D

@onready var item_list = {
	"jackalope" : load("res://Items/jackalop_pickup.tscn"),
	"double_chamber" : load("res://Items/double_chamber.tscn")
}
var pos_items = ["jackalope", "double_chamber"]
# Called when the node enters the scene tree for the first time.
func _ready():
	$Despawn_timer.start()
	var item1 = pos_items.pick_random()
	var item1_instance = item_list[item1].instantiate()
	item1_instance.position = $ItemPoint1.position
	if item1_instance.is_in_group("nonstackable"):
		print("removing ", item1)
		pos_items.pop_at(pos_items.find(item1))
		print(pos_items)
	add_child(item1_instance)
	
	var item2 = pos_items.pick_random()
	var item2_instance = item_list[item2].instantiate()
	item2_instance.position = $ItemPoint2.position
	if item2_instance.is_in_group("nonstackable"):
		print("removing ", item2)
		pos_items.pop_at(pos_items.find(item2))
		print(pos_items)
	add_child(item2_instance)
	
	var item3 = pos_items.pick_random()
	var item3_instance = item_list[item3].instantiate()
	item3_instance.position = $ItemPoint3.position
	if item3_instance.is_in_group("nonstackable"):
		print("removing ", item3)
		pos_items.pop_at(pos_items.find(item3))
		print(pos_items)
	add_child(item3_instance)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_despawn_timer_timeout():
	queue_free()
