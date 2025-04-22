extends HBoxContainer

enum MODES {simple, partial}

var heart_full = preload("res://Assets/hud assets/cow boy heart-02.png")
var heart_half = preload("res://Assets/hud assets/half heart with black.png")
var heart_empty = preload("res://Assets/hud assets/empty heart.png")
var armor_full = preload("res://Assets/ItemSprites/gatorman scale.png")
#var armor_half = preload("")

func update_health(health, max_hp, armor=0):
	update_partial(health, max_hp, armor)

func update_partial(health, max_hp, armor=0):
	for i in get_child_count():
		if health > i * 2 + 1:
			get_child(i).visible = true
			get_child(i).texture = heart_full
		elif health > i * 2:
			get_child(i).visible = true
			get_child(i).texture = heart_half
		elif max_hp > i * 2:
			get_child(i).visible = true
			get_child(i).texture = heart_empty
		elif armor > i * 2 - max_hp:
			get_child(i).visible = true
			get_child(i).texture = armor_full
		else:
			get_child(i).visible = false
