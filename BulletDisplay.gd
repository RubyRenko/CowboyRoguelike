extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_bullets(ammo, max):
	if max == 6:
		$BulletHUD.frame = ammo
		$BulletHUD2.visible = false
	elif max == 12:
		$BulletHUD2.visible = true
		$BulletHUD2.frame = ammo-6
		$BulletHUD.frame = ammo
