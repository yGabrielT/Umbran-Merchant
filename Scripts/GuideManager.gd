extends Node
@onready var DialogueManag =  $"../DialogueManager"
@onready var npcManag = $"../NpcManager"
var guideSaid = false
@export var guideDialogue : dialogue
@onready var GuideNode = $"../../Objects/Others/GuideMesh"
var t1 = 0
var canPutDialogue
var issaid = false
@export var exitAmbient : AudioStream
# Called when the node enters the scene tree for the first time.
func _ready():
	SoundManager.stop_all_ambient_sounds(.5)
	SoundManager.set_ambient_sound_volume(.5)
	SoundManager.play_ambient_sound(exitAmbient, 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if DialogueManag.currentNpc == 10 and DialogueManag.currentDialogue == 1 and not guideSaid and not DialogueManag.isTalking:
		DialogueManag.currentTalker = GuideNode
		DialogueManag.dialogueList.append(guideDialogue)
		DialogueManag.canChangeSam = true
		DialogueManag.allowedToTalk = false
		guideSaid = true
		issaid = true
		
	if DialogueManag.currentNpc == 12 and issaid:
		DialogueManag.currentNpc = 11
		
		issaid = false


