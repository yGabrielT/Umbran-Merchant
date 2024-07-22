extends SubViewportContainer

@onready var ItemTextUI : Control = $SubViewport/ItemTextUI
@onready var ItemNameUI : Label = $SubViewport/ItemTextUI/ItemName
@onready var ItemDescUI : Label = $SubViewport/ItemTextUI/ItemName/ItemDesc
@onready var Player = $"../LowResPort/LowResSubPort/DitherPort/DitherSubPort/World/Player"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Player.isLookingToItem == true and Player.raycastObj != null:
		ItemTextUI.visible = true
		ItemNameUI.text = Player.raycastObj.get_parent().itemName
		ItemDescUI.text = Player.raycastObj.get_parent().itemDesc
	else:
		ItemTextUI.visible = false
