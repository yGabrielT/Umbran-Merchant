extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	DiscordRPC.app_id = 1264609049698242590 # Application ID
	DiscordRPC.details = "pirate game jam yippe"
	DiscordRPC.state = "idk"
	DiscordRPC.large_image = "562" # Image key from "Art Assets"
	DiscordRPC.large_image_text = "Damn daniel"
	DiscordRPC.small_image = "okak-_1_" # Image key from "Art Assets"
	DiscordRPC.small_image_text = "why u looking at this"

	DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system()) # "02:46 elapsed"
	# DiscordRPC.end_timestamp = int(Time.get_unix_time_from_system()) + 3600 # +1 hour in unix time / "01:00:00 remaining"

	DiscordRPC.refresh() # Always refresh after changing the values!
