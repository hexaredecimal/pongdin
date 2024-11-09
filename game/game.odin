package game

import bl "../ball"
import pl "../player"
import "core:fmt"
import "core:strings"
import rl "vendor:raylib"

Game :: struct {
	show_menu: bool,
	play:      bool,
	pause:     bool,
	running:   bool,
	credits:   bool,
}

new_game :: proc() -> Game {
	return Game{true, false, false, true, false}
}

play_game :: proc(
	player: ^pl.Player,
	player2: ^pl.Player,
	ball: ^bl.Ball,
	game: ^Game,
	sounds: GameSounds,
) {

	if !game.pause {
		if bl.check_collision(player^, ball^) {
			rl.PlaySound(sounds.tennis_hit)
			ball.dy *= -1
			hit_position := (ball.pos.x - player.pos.x) / f32(player.width)
			max_angle := f32(0.8)
			angle := hit_position * max_angle
			ball.dx = angle * (player2.dx * ball.dx) + player2.speed / 2
			if hit_position < 0.5 do ball.dx *= -1
		}

		if bl.check_collision(player2^, ball^) {
			rl.PlaySound(sounds.tennis_hit)
			ball.dy *= -1
			hit_position := (ball.pos.x - player.pos.x) / f32(player.width)
			max_angle := f32(0.8)
			angle := hit_position * max_angle
			ball.dx = angle * (player2.dx * ball.dx) + player2.speed / 2
			if hit_position < 0.5 do ball.dx *= -1
		}

		if bl.is_death(ball^) {
			player.health -= 1
			if player.health <= 0 do player.health = 0
			rl.PlaySound(sounds.loss)
		}

		player2.pos.x = ball.pos.x - f32(player2.width) / 2

		handle_game_pause(game)
		if player.health > 0 {
			pl.draw_player(player^)
			pl.draw_player(player2^)
			bl.draw_ball(ball^)
			bl.move_ball(ball)
			handle_game_pause(game)
			pl.move_player(player)
			pl.draw_player_health(player^)
			draw_game_pause_hud()
		} else {
			game.play = false
		}
	} else {
		pl.draw_player(player^)
		pl.draw_player(player2^)
		bl.draw_ball(ball^)
		draw_game_pause()
		handle_game_pause(game)
	}
}

draw_game_pause_hud :: proc() {
	width := rl.GetScreenWidth()
	txt := "[space] to pause"
	x := width - 190
	y := 10
	text := strings.clone_to_cstring(txt)
	rl.DrawText(text, x, i32(y), 12, rl.RED)

	y += 20
	text = strings.clone_to_cstring("[M] to go to main menu")
	rl.DrawText(text, x, i32(y), 12, rl.RED)
}

draw_game_pause :: proc() {
	width := rl.GetScreenWidth()
	height := rl.GetScreenHeight()
	x := width / 2 - 100
	y := height / 2 - 100
	text := strings.clone_to_cstring("[PAUSED]")
	rl.DrawText(text, x, i32(y), 32, rl.RED)

	x -= 20
	y += 50
	text = strings.clone_to_cstring("Press [A] to continue")
	rl.DrawText(text, x, i32(y), 20, rl.BLUE)
	y += 20
	text = strings.clone_to_cstring("Press [M] to goto main menu")
	rl.DrawText(text, x, i32(y), 20, rl.BLUE)
}

handle_game_pause :: proc(game: ^Game) {
	if rl.IsKeyPressed(.SPACE) do game.pause = true
	else if rl.IsKeyPressed(.A) do game.pause = false
	else if rl.IsKeyPressed(.M) {
		game.play = false
		game.show_menu = true
		game.pause = false
	}
}

handle_game_over :: proc(
	using game: ^Game,
	sounds: GameSounds,
	player: ^pl.Player,
	ball: ^bl.Ball,
) {
	if rl.IsKeyPressed(.SPACE) {
		game.play = true
		game.show_menu = false
		bl.reset(ball)
		pl.reset(player)
		rl.PlaySound(sounds.lockandload)
		stop_game_over_music(sounds)
	} else if rl.IsKeyPressed(.M) {
		game.play = false
		game.show_menu = true
		stop_game_over_music(sounds)
		bl.reset(ball)
		pl.reset(player)
	}
}

handle_game_credits :: proc(game: ^Game, gamesounds: GameSounds) {
	if rl.IsKeyPressed(.M) {
		game.show_menu = true
		game.play = false
		game.pause = false
		game.credits = false
		rl.SeekMusicStream(gamesounds.menu_music, 0)
	}
}

draw_game_credits :: proc(probe: ^pl.Player) {
	width := rl.GetScreenWidth()
	height := rl.GetScreenHeight()
	x := width / 2 - 100
	y := height / 2 - 100
	text := strings.clone_to_cstring("[PONG-DIN]")
	rl.DrawText(text, x, i32(y), 32, rl.RED)
	x -= 20
	y += 50
	text = strings.clone_to_cstring("Designed and Developed by:")
	rl.DrawText(text, x, i32(y), 20, rl.BLUE)
	y += 20
	x -= 50
	text = strings.clone_to_cstring("Gama Sibusiso")
	rl.DrawText(text, x, i32(y), 15, rl.RED)

	x += 140
	text = strings.clone_to_cstring("github.com/hexaredecimal")
	rl.DrawText(text, x, i32(y), 15, rl.BLUE)
	x -= 100

	y = height - 100
	text = strings.clone_to_cstring("[M] to go back to main menu")
	rl.DrawText(text, x, i32(y), 15, rl.ORANGE)

	min := 10
	max := width - 100
	pl.draw_player(probe^)
	probe.pos.x += probe.dx * probe.speed
	if probe.pos.x <= f32(min) do probe.dx = 1
	if probe.pos.x >= f32(max) do probe.dx = -1
}
