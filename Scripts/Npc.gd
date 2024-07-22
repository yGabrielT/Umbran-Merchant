extends MeshInstance3D

@export var needAOrder : bool = false
@export var potionsQuantityExpected = 1
@export var liquidsQuantityExpected = 1
@export var liquidRatioExpected = []
@export var liquidsColor = [] 
var endAnimIsFinished = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_npc_animations_animation_finished(anim_name):
	if anim_name == "walk_out":
		self.queue_free()
