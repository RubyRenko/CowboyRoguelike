extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $CowboyPlayer.hp <= 0:
		#if the player runs out of hp
		#pauses the game and makes the gameover text visible
		#print("game over")
		$GUI/GameOverText.visible = true
		get_tree().paused = true
		#insert scene change to game over screen here
