extends Node

const SAVE_PATH = "user://highscore.save"

var current_score = 0 # resets on death
var total_bank_score = 1000 # The "Money" used for PowerUps (NEVER resets)
var current_health = 100
var highscore = 0;

var luck_level = 0
var health_level = 0
var speed_level = 0
var defense_level = 0
var strength_level = 0
var jump_level = 0
var player_health = 100
var player_can_dash = false
var player_max_jumps = 1
var player_damage_multiplier = 1
var player_score_multiplier = 1
var dash_time_left = 0.0
var double_jump_time_left = 0.0
var damage_boost_time_left = 0.0
var score_boost_time_left = 0.0

# This list allows the Gamble logic to pick one at random
var upgrade_keys = ["luck", "health", "speed", "defense", "strength", "jump"]

var music_player: AudioStreamPlayer = AudioStreamPlayer.new()

var floor_music = {
	"menu": "res://assets/audio/menu_soundtrack_by_chiphead64.wav",
	"shop": "res://assets/audio/Shop Theme.wav",
	"main": "res://assets/audio/3. Concrete Jungle.wav",
	"1_floor": "res://assets/audio/Through Mountains.wav",
	"2ndFloor": "res://assets/audio/Ambush.wav",
	"3rdFloor": "res://assets/audio/Time To Get Serious Bass.wav",
	"Boss1": "res://assets/audio/Time To Get Serious.wav",
	"Boss2": "res://assets/audio/Incoming Boss.wav",
	"Boss3": "res://assets/audio/Bowser Returns.wav",
}

# --- Core Logic ---

func _ready():
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	load_game_data()
	print("Game Data Loaded. Bank: ", total_bank_score, " Highscore: ", highscore)
	

# Call this when the player actually dies and doesn't resurrect
func add_run_to_bank():
	# Update highscore if current run was better
	if current_score > highscore:
		highscore = current_score
		
	total_bank_score += current_score
	current_score = 0
	save_game_data()


# --- Save/Load System ---

func save_game_data() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Could not open file for saving: " + str(FileAccess.get_open_error()))
		return

	var data_to_save = {
		"highscore": highscore,
		"bank": total_bank_score,
		"luck": luck_level,
		"health": health_level,
		"speed": speed_level,
		"defense": defense_level,
		"strength": strength_level,
		"jump": jump_level
	}
	
	file.store_var(data_to_save)
	file.close()
	print("All Game Data Saved Safely!")

func load_game_data() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
		
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var loaded_data = file.get_var()
	file.close()
	
	if typeof(loaded_data) == TYPE_DICTIONARY:
		highscore = loaded_data.get("highscore", 0)
		total_bank_score = loaded_data.get("bank", 0)
		luck_level = loaded_data.get("luck", 0)
		health_level = loaded_data.get("health", 0)
		speed_level = loaded_data.get("speed", 0)
		defense_level = loaded_data.get("defense", 0)
		strength_level = loaded_data.get("strength", 0)
		jump_level = loaded_data.get("jump", 0)
	elif typeof(loaded_data) == TYPE_INT:
		# Fallback for old save format that only stored highscore
		highscore = loaded_data

# We keep this for your Samurai to check the highscore specifically
func load_highscore() -> int:
	if not FileAccess.file_exists(SAVE_PATH): return 0
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data = file.get_var()
	if typeof(data) == TYPE_DICTIONARY:
		return data.get("highscore", 0)
	return int(data) # Fallback for old save format

	
func save_highscore(new_score: int) -> void:
	var current_hs = load_highscore()
	if new_score > current_hs:
 		# We don't just save the number; we update the bank and levels too
		save_game_data()



# --- Music System ---

func play_music(path: String) -> void:
	var new_stream: AudioStream = load(path)
	if new_stream == null:
		push_warning("Invalid music path: " + path)
		return

	if music_player.stream == new_stream:
		if not music_player.playing:
			music_player.play()
		return

	music_player.stop()
	music_player.stream = new_stream
	music_player.play()

func stop_music() -> void:
	if music_player.playing:
		music_player.stop()

func play_floor_music(floor_name: String) -> void:
	if not floor_music.has(floor_name):
		push_warning("No music assigned for floor: " + floor_name)
		return
	
	play_music(floor_music[floor_name])
