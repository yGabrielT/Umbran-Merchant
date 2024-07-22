extends MeshInstance3D



var endAnimIsFinished = false

#@export var npcWantedList = {"needAOrder":false,"potionsQuantityExpected": [{"liquidsQuantityExpected": [{"liquidsColor": [{"Color":Color(0,0,0,0), "liquidRatioExpected": 100}]}]}]}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # .Replace with function body


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_npc_animations_animation_finished(anim_name):
	if anim_name == "walk_out":
		self.queue_free()
