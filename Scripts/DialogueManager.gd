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
var sam
var t = 0.0
var canTalk
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if(not dialogueList.is_empty() and currentTalker != null):
		pos = currentTalker.global_position
		distance = cam.global_position.distance_to(pos)
		manageDialogueTextAndAudio(delta)
		if(cam.is_position_in_frustum(pos) and pos != null):
			ManageBoxPosAndSize()
		else:
			var tween = get_tree().create_tween()
			tween.tween_property(dialogueBox, "modulate:a", 0.0, .1).set_ease(Tween.EASE_IN)
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
	
func manageDialogueTextAndAudio(delta):
	
	if (currentNpc < len(dialogueList) and  dialogueList[currentNpc].npcSetting != null):
		sam = dialogueList[currentNpc].npcSetting.instantiate()
		add_child(sam)
		sam.finished_saying.connect(isNotTalkingFunc)
		sam.started_saying.connect(isTalkingFunc)
		sam.connect("saying_characters", func(pos: int) -> void: dialogueBox.get_child(0).get_child(0).visible_characters = pos)
		
		
		#sam.speed = dialogueList[currentNpc].speed
		#sam.pitch= dialogueList[currentNpc].pitch
		#sam.mouth= dialogueList[currentNpc].mouth
		#sam.throat = dialogueList[currentNpc].throat
		#sam.singing= dialogueList[currentNpc].singing
		#sam.phonetic= dialogueList[currentNpc].phonetic
		
		if(currentDialogue < len(dialogueList[currentNpc].dialogues)):
			if(not isTalking and canTalk):
				canTalk = false
				dialogueBox.get_child(0).get_child(0).text = "[center]" + dialogueList[currentNpc].dialogues[currentDialogue] + "[/center]"
				sam.say(dialogueList[currentNpc].dialogues[currentDialogue])
				currentDialogue += 1
				
				
				
			if (not canTalk):
				if (t > sam.punctuation_pause):
					t = 0
					
					canTalk = true
				else:
					t += delta
		elif not isTalking:
			currentDialogue = 0
			currentNpc += 1
			t = 99
			
	
	
	
func isTalkingFunc():
	isTalking = true
func isNotTalkingFunc():
	isTalking = false
