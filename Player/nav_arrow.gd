extends Sprite2D

@onready var arrow = $nav_arrow

func _ready() -> void:
	GlobalSignals.target_position_updated.connect(self._on_target_position_updated)

func _on_target_position_updated(position: Vector2) -> void:
	var direction = position - global_position 
	rotation = direction.angle() + PI/2

func _process(delta):
	pass
