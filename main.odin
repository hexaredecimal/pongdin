package main

import bl "ball"
import "core:fmt"
import "core:math"
import "core:strings"
import pl "player"
import rl "vendor:raylib"

import gm "game"

width :: 600
height :: 400

main :: proc() {
	rl.InitWindow(width, height, "Hellope")
	rl.SetTargetFPS(60)
	rl.InitAudioDevice()
	rl.SetMasterVolume(100)


	player := pl.new()
	player2 := pl.new()
	player.pos = rl.Vector2{width / 2, height - 20}
	player2.pos = rl.Vector2{width / 2, 10}
	player2.color = rl.ORANGE
	ball := bl.new()
	interval := i32(1)
	text := strings.clone_to_cstring("Game Over!!!")
	x := width / 2 - i32(rl.TextLength(text)) - 10

	font := i32(10)
	game := gm.new_game()
	menu := gm.new_menu(&game)
	game_sound := gm.new_game_sounds()
	for !rl.WindowShouldClose() {
		gm.play_menu_music(game_sound)
		if game.show_menu do gm.handle_menu(&menu, game_sound)
		rl.BeginDrawing()
		rl.ClearBackground(rl.WHITE)
		if game.show_menu do gm.draw_menu(menu)
		if game.play && !game.show_menu {
			gm.stop_menu_music(game_sound)
			gm.play_game(&player, &player2, &ball, &game, game_sound)
		} else if !game.play && !game.show_menu {
			pl.draw_game_over(&font, text, &x, &interval)
		}
		rl.EndDrawing()
	}
	gm.free_sounds(&game_sound)
	rl.CloseWindow()
}
