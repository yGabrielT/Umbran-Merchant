extends Node3D
@onready var DialogueManager = $"../DialogueManager"
var next
var parts = 0
@onready var Player = $"../../Player"
@onready var UI = $"../../../../../../../UI_layer/SubViewport/GameplayUI"
@onready var Anim = $"../../Objects/Others/AnimationPlayer"
@export var colorNeeded : Color
@onready var guideLeftEye = $"../../Objects/Others/GuideMesh/Guide/LeftEye"
@onready var guideRightEye = $"../../Objects/Others/GuideMesh/Guide/RightEye"
var currentBody
var once = true
var t = 0


@onready var tableToSpawnBottle = $"../../Objects/Static/MeshInstance3D3"
@export var sceneToChange : PackedScene
@onready var fader = $"../../Player/DialogueUI/Fader/AnimationPlayer"
# Called when the node enters the scene tree for the first time.
func _ready():
	DialogueManager.t = -2
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	
	if DialogueManager.currentNpc == 1:
		if DialogueManager.currentDialogue == 4 and once:
			Anim.play("rise Things")
			once =false
		if (not next):
			DialogueManager.t = -.5
			next = true
			Player.SENSITIVITY = 0.01
			Player.SPEED = 5
			DialogueManager.allowedToTalk = false
			
			UI.visible = true
			
			
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
		
		checkBottle()

	if DialogueManager.currentNpc == 4:
		
		if DialogueManager.currentDialogue == 2:
			var bottles = get_tree().get_nodes_in_group("Bottle")
			print(bottles)
			bottles[0].queue_free()
			bottles[1].queue_free()
			var bottlesScene = preload("res://scenes/tutorial_bottles.tscn").instantiate()
			tableToSpawnBottle.add_child(bottlesScene)
			DialogueManager.currentNpc = 2
			DialogueManager.currentDialogue = 1
			currentBody = null
			DialogueManager.allowedToTalk = false
	
	if DialogueManager.currentNpc == 3:
		DialogueManager.allowedToTalk = false
		if(DialogueManager.currentDialogue == 4):
			fader.play_backwards("fade_start")
			once = true
			
		if (once):
			if t > 2.5:
				once = false
				get_tree().change_scene_to_packed(sceneToChange)
			else:
				t += delta


func _on_deliver_area_body_entered(body):
	currentBody = body



func _on_deliver_area_body_exited(body):
	currentBody = null


func checkBottle():
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
		if (roundedColor.is_equal_approx(needColor)):
			currentBody = null
			DialogueManager.allowedToTalk = true
			
		else:
			#not right
			#get bottles
			DialogueManager.currentNpc = 4
			DialogueManager.currentDialogue = 0
			DialogueManager.allowedToTalk = true
