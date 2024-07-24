extends Node3D
var PotsInDeliverArea = []

var isNpcDone = false
var NpcAnimator : AnimationPlayer
var potChecker = 99
var potLiquidChecker = 99
var currentNpcNumber = 0
var potionOrderCorrector
@onready var dialogueManager = $"../DialogueManager"
@export var allNpcs : Array[check_list]
var NpcScene
var hasTalked




# Called when the node enters the scene tree for the first time.
func _ready():
	SpawnNpc()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	if currentNpcNumber < len(allNpcs) and not NpcScene.isGoing: #if npc gets erased stop
		if potChecker != 0:  #continue if not all checks are done
			
			if len(PotsInDeliverArea) != 0 and hasTalked: #check if there at least a pot in the deliver area
				
				if len(allNpcs[currentNpcNumber].PotionList) == len(PotsInDeliverArea): #check the quantity of pots needed
					potChecker = len(allNpcs[currentNpcNumber].PotionList) # gives the value that needs to be subtratec
					
					# In every pot look at the liquids inside
					for i in len(PotsInDeliverArea):
						PotsInDeliverArea.shuffle() 
						#What is the number of liquids needed in the pot?
						if len(allNpcs[currentNpcNumber].PotionList[i - 1].liquidsQuantityExpected) == len(PotsInDeliverArea[i - 1].liquids): 
							
							
							if(potLiquidChecker != 0): #continue if not all checks are done
								potLiquidChecker = len(allNpcs[currentNpcNumber].PotionList[i - 1].liquidsQuantityExpected) # gives the value that needs to be subtratec
								for x in len(PotsInDeliverArea[i - 1].liquids): #look at the liquids at the individual pot
									PotsInDeliverArea[i - 1].liquids.shuffle() 
									#Transform both Vector4 To Color8 and round it
									var npcColorVec4 = Vector4(
										allNpcs[currentNpcNumber].PotionList[i - 1].liquidsQuantityExpected[x - 1].liquidColor.r,
										allNpcs[currentNpcNumber].PotionList[i - 1].liquidsQuantityExpected[x - 1].liquidColor.g,
										allNpcs[currentNpcNumber].PotionList[i - 1].liquidsQuantityExpected[x - 1].liquidColor.b,
										allNpcs[currentNpcNumber].PotionList[i - 1].liquidsQuantityExpected[x - 1].liquidColor.a) 
									var npcColor = round(npcColorVec4 * 255) 
									var potColor = round(PotsInDeliverArea[i - 1].liquids[x - 1] * 255)
									#Check if the colors are equal
									if  potColor == npcColor and not allNpcs[currentNpcNumber].PotionList[i - 1].isChecked and not allNpcs[currentNpcNumber].PotionList[i - 1].liquidsQuantityExpected[x - 1].isChecked:
										allNpcs[currentNpcNumber].PotionList[i - 1].isChecked = true
										allNpcs[currentNpcNumber].PotionList[i - 1].liquidsQuantityExpected[x - 1].isChecked
										potLiquidChecker -=  1#Subtract liquid value
										
									
							else:
								
								potChecker -= 1 #Subtract pot value
		elif not isNpcDone:
			#All check are done
			hasTalked = false
			isNpcDone = true
			NpcAnimator.queue("walk_out")
			for i in len(PotsInDeliverArea):
				PotsInDeliverArea[i - 1].queue_free()

	if not hasTalked:
		
		if NpcScene.hasCome:
			hasTalked = true
			NpcScene.hasCome = false
			TalkWithPlayer(true,NpcScene)
		if NpcScene.isGoing:
			hasTalked = true
			NpcScene.isGoing = false
			TalkWithPlayer(false,NpcScene)
	if NpcScene != null:
		if NpcScene.isGone :
			currentNpcNumber += 1
			NpcScene.queue_free()
			SpawnNpc()
func SpawnNpc():
	if currentNpcNumber < len(allNpcs):
		hasTalked = false
		potChecker = 99
		potLiquidChecker = 99
		isNpcDone = false
		NpcScene = preload("res://scenes/npcbase.tscn").instantiate()
		add_child(NpcScene)
		
		NpcAnimator = NpcScene.get_node("NpcAnimations")
		NpcAnimator.play("walk_in")
	

func TalkWithPlayer(isEntering : bool, npcNode):
	dialogueManager.currentTalker = npcNode
	if(isEntering):
		dialogueManager.dialogueList.append(allNpcs[currentNpcNumber].dialogueEnter)
	else:
		dialogueManager.dialogueList.append(allNpcs[currentNpcNumber].dialogueExit)
	
func _on_deliver_area_body_entered(body):
	PotsInDeliverArea.append(body)


func _on_deliver_area_body_exited(body):
	PotsInDeliverArea.erase(body)
