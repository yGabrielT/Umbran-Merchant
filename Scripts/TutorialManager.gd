extends Node3D
@onready var DialogueManager = $"../DialogueManager"
var next
@onready var Player = $"../../Player"
@onready var UI = $"../../../../../../../UI_layer/SubViewport/GameplayUI"
@onready var Anim = $"../../Objects/Others/AnimationPlayer"
# Called when the node enters the scene tree for the first time.
func _ready():
	DialogueManager.t = -2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if DialogueManager.currentNpc == 1:
		if (not next):
			next = true
			Player.SENSITIVITY = 0.01
			Player.SPEED = 5
			DialogueManager.allowedToTalk = false
			
			UI.visible = true
			Anim.play("rise Things")
			
	


func _on_deliver_area_body_entered(body):
	DialogueManager.allowedToTalk = true
