extends Node

const SAVE_PATH = "user://highscore.save"

var current_score = 0

func save_highscore(score: int) -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(score)
	
func load_highscore() -> int:
	if not FileAccess.file_exists(SAVE_PATH):
		return 0
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	return file.get_var()
