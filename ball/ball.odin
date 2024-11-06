package ball

import pl "../player"
import "core:fmt"
import rl "vendor:raylib"

Ball :: struct {
	pos:   rl.Vector2,
	size:  f32,
	speed: f32,
	dx:    f32,
	dy:    f32,
}

new :: proc() -> Ball {
	width := rl.GetScreenWidth()
	height := rl.GetScreenHeight()
	radius := f32(5)
	x := f32(width / 2) - radius
	y := f32(height / 2) - radius
	return Ball{rl.Vector2{x, y}, radius, 4, 0, -1}
}

draw_ball :: proc(using ball: Ball) {
	rl.DrawCircle(i32(pos.x), i32(pos.y), size, rl.RED)
}

move_ball :: proc(using ball: ^Ball) {
	if dy == 1 {
		pos.x += dx
		pos.y -= speed
	} else if dy == -1 {
		pos.x += dx
		pos.y += speed
	}
	width := rl.GetScreenWidth()
	height := rl.GetScreenHeight()
	if pos.y >= f32(height) + 5 do dy = 1
	if pos.y <= 0 do dy = -1
	if pos.x <= 0 || pos.x >= f32(width) do dx = -dx
}

check_collision :: proc(player: pl.Player, ball: Ball) -> bool {
	y_collide := ball.pos.y > player.pos.y && ball.pos.y < player.pos.y + f32(player.height)
	x_collide := ball.pos.x > player.pos.x && ball.pos.x < player.pos.x + f32(player.width)
	return x_collide && y_collide
}

is_death :: proc(using ball: Ball) -> bool {
	screen_width := rl.GetScreenWidth()
	screen_height := rl.GetScreenHeight()
	if pos.y >= f32(screen_height) + 5 do return true
	return false
}
