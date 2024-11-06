package main

import bl "ball"
import "core:fmt"
import "core:math"
import "core:strings"
import pl "player"
import rl "vendor:raylib"

width :: 600
height :: 400

main :: proc() {
	rl.InitWindow(width, height, "Hellope")
	rl.SetTargetFPS(60)
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

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.WHITE)

		if bl.check_collision(player, ball) {
			ball.dy *= -1
			hit_position := (ball.pos.x - player.pos.x) / f32(player.width)
			max_angle := f32(0.8)
			angle := hit_position * max_angle
			ball.dx = angle * (player2.dx * ball.dx) + player2.speed / 2
			if hit_position < 0.5 do ball.dx *= -1
		}

		if bl.check_collision(player2, ball) {
			ball.dy *= -1
			hit_position := (ball.pos.x - player.pos.x) / f32(player.width)
			max_angle := f32(0.8)
			angle := hit_position * max_angle
			ball.dx = angle * (player2.dx * ball.dx) + player2.speed / 2
			if hit_position < 0.5 do ball.dx *= -1
		}

		if bl.is_death(ball) {
			player.health -= 1
			if player.health <= 0 do player.health = 0
		}

		player2.pos.x = ball.pos.x - f32(player2.width) / 2

		if player.health > 0 {
			pl.draw_player(player)
			pl.draw_player(player2)
			bl.draw_ball(ball)
			bl.move_ball(&ball)

			pl.move_player(&player)
			pl.draw_player_health(player)
		} else do pl.draw_game_over(&font, text, &x, &interval)
		rl.EndDrawing()
	}

	rl.CloseWindow()
}
