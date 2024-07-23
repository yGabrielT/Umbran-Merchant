extends Node3D

@onready var cam = get_viewport().get_camera_3d()
var pos 
var screenpos
@onready var dialogueBox = $"../../Player/DialogueUI/ColorRect2"
@export var dialogueList : Array[dialogue] 
var currentNpc = 0
var currentDialogue= 0 
var distance
@export var currentTalker : Node3D
var isTalking
var hasSam = false
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(currentNpc)
	if(not dialogueList.is_empty()):
		
		pos = currentTalker.global_position
		distance = cam.global_position.distance_to(pos)
		manageDialogueTextAndAudio()
		if(cam.is_position_in_frustum(pos)) and distance < 5.0:
			ManageBoxPosAndSize()
		else:
			var tween = get_tree().create_tween()
			tween.tween_property(dialogueBox, "modulate:a", 0.0, .1).set_ease(Tween.EASE_IN)
	

func ManageBoxPosAndSize():
	var tween = dialogueBox.create_tween()
	tween.tween_property(dialogueBox, "modulate:a", 1.0, .1).set_ease(Tween.EASE_IN)
	screenpos = cam.unproject_position(pos)
	dialogueBox.set_position((screenpos - Vector2(dialogueBox.size.x,dialogueBox.size.y)) + Vector2(35,-25))
	dialogueBox.set_size(Vector2( 80 - (distance), 60 - (distance)))
	dialogueBox.set_pivot_offset(Vector2(dialogueBox.size.x/2, dialogueBox.size.y/2) )
	
	
func hideDialogueBox():
	var tween = get_tree().create_tween()
	tween.tween_property(dialogueBox, "modulate:a", 0.0, .1).set_ease(Tween.EASE_IN)
	
func manageDialogueTextAndAudio():
	if (currentNpc < len(dialogueList)):
		var sam = GDSAM.new()
		var stream = AudioStreamPlayer.new()
		currentTalker.add_child(sam)
		currentTalker.add_child(stream)
		sam.speed = dialogueList[currentNpc].speed
		sam.pitch= dialogueList[currentNpc].pitch
		sam.mouth= dialogueList[currentNpc].mouth
		sam.throat = dialogueList[currentNpc].throat
		sam.singing= dialogueList[currentNpc].singing
		sam.phonetic= dialogueList[currentNpc].phonetic
		sam.finished_speaking.connect(isNotTalkingFunc)
		if(currentDialogue < len(dialogueList[currentNpc].dialogues)):
			if(not isTalking):
				isTalking = true
				dialogueBox.get_child(0).text = dialogueList[currentNpc].dialogues[currentDialogue]
				sam.speak(stream, dialogueList[currentNpc].dialogues[currentDialogue])
				currentDialogue += 1
		elif not isTalking:
			currentDialogue = 0
			currentNpc += 1
	
	
	
func isTalkingFunc():
	isTalking = true
func isNotTalkingFunc():
	isTalking = false
