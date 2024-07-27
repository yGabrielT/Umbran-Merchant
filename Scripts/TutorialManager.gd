extends Node3D
@onready var DialogueManager = $"../DialogueManager"
var next
var parts = 0
@onready var Player = $"../../Player"
@onready var UI = $"../../../../../../../UI_layer/SubViewport/GameplayUI"
@onready var Anim = $"../../Objects/Others/AnimationPlayer"
@export var colorNeeded : Color
var currentBody
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
			
		if(currentBody != null):
			DialogueManager.allowedToTalk = true
			currentBody.queue_free()
			next = false
	if DialogueManager.currentNpc == 2:
		
		
		if (not next):
			next = true
			DialogueManager.allowedToTalk = false
			Anim.play("downthings")
			Anim.queue("risetwo")
			print("AAAAA")
		if(currentBody != null):
			var potColorVec4 = Vector4(
				currentBody.liquids[0].x,
				currentBody.liquids[0].y,
				currentBody.liquids[0].z,
				currentBody.liquids[0].w) 
			var neededColorVec4 = Vector4(
				colorNeeded.r,
				colorNeeded.g,
				colorNeeded.b,
				colorNeeded.a) 
			var roundedColor = round(potColorVec4 * 255)
			var needColor = round(neededColorVec4 * 255)
			if roundedColor == needColor:
				DialogueManager.allowedToTalk = true


func _on_deliver_area_body_entered(body):
	currentBody = body



func _on_deliver_area_body_exited(body):
	currentBody = null
