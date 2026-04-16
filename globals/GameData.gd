extends Node

const SAVE_PATH = "user://highscore.save"

var current_score = 0

func save_highscore(score: int) -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(score)
	
func load_highscore() -> int:
	if not FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
		file.store_var(0)
		file.close()
		return 0
		
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	return file.get_var()


# -------------------------------------
#			MUSIC
#--------------------------------------
var music_player: AudioStreamPlayer = AudioStreamPlayer.new()

func _ready():
	music_player = AudioStreamPlayer.new()
	add_child(music_player)

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

var floor_music = {
	"menu": "res://assets/audio/menu_soundtrack_by_chiphead64.wav",
	"shop": "res://assets/audio/Shop Theme.wav",
	"main": "res://assets/audio/3. Concrete Jungle.wav",
	"1_floor": "res://assets/audio/Through Mountains.wav",
	"2ndFloor": "res://assets/audio/Ambush.wav",
	"3rdFloor": "res://assets/audio/Time To Get Serious Bass.wav",
}
