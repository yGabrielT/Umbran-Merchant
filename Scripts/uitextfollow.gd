extends MeshInstance3D
@onready var cam = get_viewport().get_camera_3d()
var pos 
var screenpos
@onready var dialogue = $"../../../Player/DialogueUI/ColorRect2"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pos = self.global_position
	var distance = cam.global_position.distance_to(pos)
	if(cam.is_position_in_frustum(pos)) and distance < 5.0:
		
		var tween = dialogue.create_tween()
		tween.tween_property(dialogue, "modulate:a", 1.0, .1).set_ease(Tween.EASE_IN)
		screenpos = cam.unproject_position(pos)
		dialogue.set_position((screenpos - Vector2(dialogue.size.x,dialogue.size.y)) + Vector2(35,-25))
		dialogue.set_size(Vector2( 80 - (distance), 60 - (distance)))
		dialogue.set_pivot_offset(Vector2(dialogue.size.x/2, dialogue.size.y/2) )
		print(distance)
		
		
		
	else:
		var tween = get_tree().create_tween()
		tween.tween_property(dialogue, "modulate:a", 0.0, .1).set_ease(Tween.EASE_IN)
		
