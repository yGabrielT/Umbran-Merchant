extends Resource
class_name dialogue

@export var dialogues : Array[String]

@export_range(0, 255) var speed: int = 72
@export_range(0, 255) var pitch: int = 64
@export_range(0, 255) var mouth: int = 128
@export_range(0, 255) var throat: int = 128
@export var singing: bool = false
@export var phonetic: bool = false
