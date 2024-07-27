extends StaticBody3D

@export var itemName : String
@export var itemDesc : String

var liquids = []
var mats

# Called when the node enters the scene tree for the first time.
func _ready():
	updateLiquids()
	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
	
func updateLiquids():
	liquids.clear()
	mats = $Liquids.get_children()
	#print(self.name + " has ", len(mats))
	for i in len(mats):
		var vec = Vector4(
			mats[i].get_active_material(0).albedo_color.r,
		mats[i].get_active_material(0).albedo_color.g,
		mats[i].get_active_material(0).albedo_color.b,
		mats[i].get_active_material(0).albedo_color.a)
		liquids.append(vec)
		print(liquids)
