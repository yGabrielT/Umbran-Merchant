extends Node3D

@export var npcToMove : PackedScene
@export var spawnPos : Node3D
@export var endPos : Node3D
var initialSpawnPos
var finalSpawnPos
var temp = 0.0
@export var maxCount = 20
var count = 0
@export var SpawnCD = 2.0

@export var AnyButton : Label3D
@export var memeButton : Label3D
@export var fadeOverlay : ColorRect
@export var MainLabel : Label
@export var otherFade : ColorRect
var cam : Camera3D
var isPressed = false
var isInitialFadeIn = false
@export var SceneToChange : PackedScene
@export var ambientSfx :AudioStream
@export var clickSound : AudioStream
var canChange = false
# Called when the node enters the scene tree for the first time.
func _ready():
	SoundManager.play_ambient_sound(ambientSfx,1)
	cam= get_viewport().get_camera_3d()
	var startTween = get_tree().create_tween()
	startTween.tween_property(otherFade, "color:a", 0, 2).set_ease(Tween.EASE_OUT_IN)
	startTween.tween_callback(func():
		isInitialFadeIn = true)

func _unhandled_input(event):
	if event is InputEventMouseButton and not isPressed and isInitialFadeIn:
		isPressed = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		SoundManager.play_sound_with_pitch(clickSound,.6)
		SoundManager.stop_all_ambient_sounds(.3)
		var tweenButton = get_tree().create_tween()
		var newbutton = AnyButton.duplicate()
		cam.add_child(newbutton)
		tweenButton.tween_property(newbutton, "scale", newbutton.scale * 1.05,.2)
		tweenButton.tween_property(AnyButton, "modulate:a", 0.0, .3)
		tweenButton.parallel().tween_property(newbutton, "modulate:a", 0.0, .3)
		tweenButton.parallel().tween_property(memeButton, "modulate:a", 0.0, .3)
		tweenButton.tween_property(fadeOverlay, "color:a", 1, 5)
		tweenButton.parallel().tween_property(MainLabel, "modulate:a", 0, 3)
		tweenButton.tween_callback(func():
			canChange = true)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if canChange:
		canChange = false
		ChangeScene()
	
	if temp > SpawnCD and  count < maxCount:
		temp = 0
		count += 1
		RandomPos()
		var npcSpawned = npcToMove.instantiate()
		self.add_child(npcSpawned)
		npcSpawned.position = initialSpawnPos
		var tweener = get_tree().create_tween()
		tweener.tween_property(npcSpawned, "position", finalSpawnPos, 5).set_ease(Tween.EASE_IN)
		tweener.tween_callback(func():
			ReduceCount())
		tweener.tween_callback(func():
			if npcSpawned != null:
				npcSpawned.queue_free())
	else:
		temp += delta 

func RandomPos():
	initialSpawnPos = Vector3(spawnPos.position.x,spawnPos.position.y,randi_range(spawnPos.position.z - 4, spawnPos.position.z + 4))
	finalSpawnPos = Vector3(endPos.position.x,endPos.position.y,randi_range(endPos.position.z - 4, endPos.position.z + 4))

func ReduceCount():
	count -= 1
	
func ChangeScene():
	get_tree().change_scene_to_packed(SceneToChange)
	

