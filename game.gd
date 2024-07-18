extends Node3D

const REFERENCE_RESOLUTION = Vector2i(640, 360)
const DESKTOP_MAX_WINDOW_SCALE = 6

const COLLECTION_VERSION = "1.2.0"

static var DEMO_APP_VERSION = ProjectSettings.get_setting("application/config/version")
static var IS_WEB_VERSION = OS.has_feature("web")

@onready
var _window: Window = get_tree().root


var _fullscreen: bool:
	get: return _fullscreen

	set(value):
		_fullscreen = value

		if _fullscreen:
			_window.mode = Window.MODE_EXCLUSIVE_FULLSCREEN
		else:
			_window.mode = Window.MODE_WINDOWED

			var scale := 1

			for i in range(1, DESKTOP_MAX_WINDOW_SCALE):
				if REFERENCE_RESOLUTION * i < DisplayServer.screen_get_size():
					scale = i
				else:
					break

			_window.size = REFERENCE_RESOLUTION * scale

			_window.position = (
				DisplayServer.screen_get_size() / 2 - _window.size / 2)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
