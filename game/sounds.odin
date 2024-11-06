package game

import "core:fmt"
import rl "vendor:raylib"

GameSounds :: struct {
	menu_music: rl.Music,
	bang:       rl.Sound,
	cock:       rl.Sound,
	start:      rl.Sound,
	tennis_hit: rl.Sound,
	game_over:  rl.Sound,
}

new_game_sounds :: proc() -> GameSounds {
	music := rl.LoadMusicStream("./assets/sounds/game-music-loop.mp3")
	bang := rl.LoadSound("./assets/sounds/Bang.mp3")
	cock := rl.LoadSound("./assets/sounds/cock.mp3")
	start := rl.LoadSound("./assets/sounds/start.mp3")
	tennis_hit := rl.LoadSound("./assets/sounds/tennis-hit.mp3")
	game_over := rl.LoadSound("./assets/sounds/game-over.mp3")
	return GameSounds{music, bang, cock, start, tennis_hit, game_over}
}

play_menu_music :: proc(using gm_sounds: GameSounds) {
	if rl.IsMusicReady(menu_music) && !rl.IsMusicStreamPlaying(menu_music) {
		rl.PlayMusicStream(menu_music)
	} else {
		rl.UpdateMusicStream(menu_music)
	}
}

stop_menu_music :: proc(using gm_sounds: GameSounds) {
	rl.StopMusicStream(menu_music)
}

free_sounds :: proc(using gamesound: ^GameSounds) {
	rl.UnloadSound(bang)
	rl.UnloadMusicStream(menu_music)
}
