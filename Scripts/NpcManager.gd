extends Node3D
var PotsInDeliverArea = []
var firstNpcScene = preload("res://scenes/npcbase.tscn").instantiate()
var isNpcDone = false
var NpcAnimator : AnimationPlayer
var potChecker = 99
var potLiquidChecker = 99
var potsNeeded;

# Called when the node enters the scene tree for the first time.
func _ready():
	SpawnNpc()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if firstNpcScene != null: #if npc gets erased stop
		if potChecker != 0:  #continue if not all checks are done
			if len(PotsInDeliverArea) != 0: #check if there at least a pot in the deliver area
				if firstNpcScene.potionsQuantityExpected == len(PotsInDeliverArea): #check the quantity of pots needed
					potChecker = len(PotsInDeliverArea) # gives the value that needs to be subtratec
					
					# In every pot look at the liquids inside
					for i in len(PotsInDeliverArea):
						
						#What is the number of liquids needed in the pot?
						if firstNpcScene.liquidsQuantityExpected == len(PotsInDeliverArea[i - 1].liquids): 
							
							
							if(potLiquidChecker != 0): #continue if not all checks are done
								potLiquidChecker = len(PotsInDeliverArea[i - 1].liquids) # gives the value that needs to be subtratec
								for x in len(PotsInDeliverArea[i - 1].liquids): #look at the liquids at the individual pot
									#Transform both Vector4 To Color8 and round it
									var npcColor = round(firstNpcScene.liquidsColor[x - 1] * 255) 
									var potColor = round(PotsInDeliverArea[i - 1].liquids[x - 1] * 255)
									#Check if the colors are equal
									if  potColor == npcColor:
										
										potLiquidChecker -=  1#Subtract liquid value
										
										
							else:
								potChecker -= 1 #Subtract pot value
		else:
			#All check are done
			isNpcDone = true
			NpcAnimator.queue("walk_out")
func SpawnNpc():
	add_child(firstNpcScene)
	
	firstNpcScene.needAOrder = false
	firstNpcScene.liquidsQuantityExpected = 1
	firstNpcScene.liquidRatioExpected = [100]
	firstNpcScene.liquidsColor.append(Vector4(0.2649, 0.8707, 0.9993, 1))
	NpcAnimator = firstNpcScene.get_node("NpcAnimations")
	NpcAnimator.play("walk_in")

func getLiquidsColor() -> Array[String]:
	var liquidsColor = []
	var childs = PotsInDeliverArea
	
	
	return liquidsColor

func _on_deliver_area_body_entered(body):
	PotsInDeliverArea.append(body)


func _on_deliver_area_body_exited(body):
	PotsInDeliverArea.erase(body)
