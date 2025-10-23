extends Area2D

@onready var game_magnager: Node = %GameMagnager
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	game_magnager.add_points() # Replace with function body.
	animation_player.play("pickUp")
