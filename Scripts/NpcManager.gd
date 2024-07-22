extends Node3D
var PotsInDeliverArea = []
var firstNpcScene = preload("res://scenes/npcbase.tscn").instantiate()
var isNpcDone = false
var NpcAnimator



# Called when the node enters the scene tree for the first time.
func _ready():
	SpawnNpc()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if not isNpcDone and len(PotsInDeliverArea) != 0:
		if firstNpcScene.potionsQuantityExpected == 1:
			if firstNpcScene.liquidsQuantityExpected == 1:
				#print(PotsInDeliverArea[0].liquids[0], " pot")
				#print(firstNpcScene.liquidsColor[0], " npc")
				var npcColor = round(firstNpcScene.liquidsColor[0] * 255)
				var potColor = round(PotsInDeliverArea[0].liquids[0] * 255)
				print(npcColor, potColor)
				if  potColor == npcColor:
					print("LETSGO")
					isNpcDone = true
					
		#if len(PotsInDeliverArea) == firstNpcScene.potionsQuantityExpected:
			#pass
func SpawnNpc():
	add_child(firstNpcScene)
	
	firstNpcScene.needAOrder = false
	firstNpcScene.liquidsQuantityExpected = 1
	firstNpcScene.liquidRatioExpected = [100]
	firstNpcScene.liquidsColor.append(Vector4(0.2649, 0.8707, 0.9993, 1))
	NpcAnimator = firstNpcScene.get_node("NpcAnimations")

func getLiquidsColor() -> Array[String]:
	var liquidsColor = []
	var childs = PotsInDeliverArea
	
	
	return liquidsColor

func _on_deliver_area_body_entered(body):
	PotsInDeliverArea.append(body)


func _on_deliver_area_body_exited(body):
	PotsInDeliverArea.erase(body)
