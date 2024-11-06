package game

import "core:fmt"
import rl "vendor:raylib"

GameSounds :: struct {
	menu_music:       rl.Music,
	game_over_screen: rl.Music,
	play:             rl.Music,
	bang:             rl.Sound,
	cock:             rl.Sound,
	start:            rl.Sound,
	tennis_hit:       rl.Sound,
	loss:             rl.Sound,
	lockandload:      rl.Sound,
}

new_game_sounds :: proc() -> GameSounds {
	music := rl.LoadMusicStream("./assets/sounds/game-music-loop.mp3")
	game_over := rl.LoadMusicStream("./assets/sounds/bass.mp3")
	bang := rl.LoadSound("./assets/sounds/Bang.mp3")
	cock := rl.LoadSound("./assets/sounds/cock.mp3")
	start := rl.LoadSound("./assets/sounds/start.mp3")
	tennis_hit := rl.LoadSound("./assets/sounds/tennis-hit.mp3")
	loss := rl.LoadSound("./assets/sounds/game-over.mp3")
	lal := rl.LoadSound("./assets/sounds/lock-and-load.mp3")
	play := rl.LoadMusicStream("./assets/sounds/play.mp3")

	return GameSounds{music, game_over, play, bang, cock, start, tennis_hit, loss, lal}
}

play_menu_music :: proc(using gm_sounds: GameSounds, game: Game) {
	if !game.show_menu do return
	if rl.IsMusicReady(menu_music) && !rl.IsMusicStreamPlaying(menu_music) {
		rl.PlayMusicStream(menu_music)
	} else {
		rl.UpdateMusicStream(menu_music)
	}
}

stop_menu_music :: proc(using gm_sounds: GameSounds) {
	rl.StopMusicStream(menu_music)
}

play_game_over_music :: proc(using gm_sounds: GameSounds, game: Game) {
	if rl.IsMusicReady(game_over_screen) && !rl.IsMusicStreamPlaying(game_over_screen) {
		rl.PlayMusicStream(game_over_screen)
	} else {
		rl.UpdateMusicStream(game_over_screen)
	}
}

stop_game_over_music :: proc(using gm_sounds: GameSounds) {
	rl.StopMusicStream(game_over_screen)
}

play_game_play_music :: proc(using gm_sounds: GameSounds, game: Game) {
	if rl.IsMusicReady(play) && !rl.IsMusicStreamPlaying(play) {
		rl.PlayMusicStream(play)
	} else {
		rl.UpdateMusicStream(play)
	}
}

stop_game_play_music :: proc(using gm_sounds: GameSounds) {
	rl.StopMusicStream(play)
}

free_sounds :: proc(using gamesound: ^GameSounds) {
	rl.UnloadMusicStream(game_over_screen)
	rl.UnloadMusicStream(menu_music)
	rl.UnloadMusicStream(play)
	rl.UnloadSound(bang)
	rl.UnloadSound(cock)
	rl.UnloadSound(start)
	rl.UnloadSound(tennis_hit)
	rl.UnloadSound(loss)
	rl.UnloadSound(lockandload)
}
