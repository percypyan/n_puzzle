/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   Heuristic.swift                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: parchimb <parchimb@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2020/02/16 17:53:33 by parchimb          #+#    #+#             */
/*   Updated: 2020/02/16 17:53:38 by parchimb         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

import Foundation

// Those heuristic functions are based on an incorrect final order.
// Should be:
// 1 2 3
// 8 - 4
// 7 6 5
// Currently is:
// 1 2 3
// 4 5 6
// 7 8 -

// We migth use an array with correct coordinate:
// - index: is the tile number (Int)
// - value: is the coordinate object

struct HeuristicMethod {
	let method: ([[Int]]) -> Int
	let label: String
}

let AvailableHeuristicMethods = [
	"misplaced": HeuristicMethod(method: misplacedTiles, label: "Misplaced tiles"),
	"manhattan": HeuristicMethod(method: manhattanDistance, label: "Manhattan distance"),
	"linear": HeuristicMethod(method: linearConflict, label: "Manhattan distance with linear conflicts")
]

func misplacedTiles(grid: [[Int]]) -> Int {
	var misplaced = 0
	for y in 0...(grid.count - 1) {
		for x in 0...(grid[y].count - 1) {
			if grid[y][x] != y * grid.count + x + 1 && grid[y][x] != 0 {
				misplaced += 1
			}
		}
	}
	return misplaced
}

func manhattanDistance(grid: [[Int]]) -> Int {
	var heuristic = 0
	for y in 0...(grid.count - 1) {
		for x in 0...(grid[y].count - 1) {
			if grid[y][x] != 0 {
				let correctX = (grid[y][x] - 1) % grid[y].count
				let correctY = (grid[y][x] - 1) / 3
				heuristic += abs(correctX - x) + abs(correctY - y)
			}
		}
	}
	return heuristic
}

func linearConflict(grid: [[Int]]) -> Int {
	var heuristic = 0
	var realPositions: [GridPosition] = []
	var goalPositions: [GridPosition] = []
	for y in 0...(grid.count - 1) {
		for x in 0...(grid[y].count - 1) {
			if grid[y][x] != 0 && grid[y][x] != y * grid.count + x + 1 {
				realPositions.append(GridPosition(x: x, y: y))
				// Goal position never change, we should compute it only once.
				goalPositions.append(GridPosition(
					x: (grid[y][x] - 1) % grid[y].count,
					y: (grid[y][x] - 1) / 3
				))
			}
		}
	}
	var linearConflicts = 0
	if goalPositions.count > 0 {
		for i1 in 0...(goalPositions.count - 1) {
			let goal = goalPositions[i1]
			let real = realPositions[i1]
			heuristic += abs(real.x - goal.x) + abs(real.y - goal.y)
			if i1 >= goalPositions.count - 2 { continue }
			for i2 in (i1 + 1)...(goalPositions.count - 1) {
				let goal2 = goalPositions[i2]
				let real2 = realPositions[i2]
				let sameX = real.x == real2.x && real.x == goal.x && goal.x == goal2.x
				let sameY = real.y == real2.y && real.y == goal.y && goal.y == goal2.y
				let invertedX = (real.x > real2.x && goal.x < goal2.x) || (real.x < real2.x && goal.x > goal2.x)
				let invertedY = (real.y > real2.y && goal.y < goal2.y) || (real.y < real2.y && goal.y > goal2.y)
				if (sameX && invertedY) || (sameY && invertedX) {
					linearConflicts += 1
				}
			}
		}
	}
	heuristic += 2 * linearConflicts
	return heuristic
}

func maxSwapMisplaced(grid: [[Int]]) -> Int {
	var misplaced = 0
	for y in 0...(grid.count - 1) {
		for x in 0...(grid[y].count - 1) {
			if grid[y][x] != y * grid.count + x + 1 && grid[y][x] != 0 {
				misplaced += 1
			}
		}
	}
	/* If 0 is in place you've to move it once before start swaping */
	if grid.last?.last == 0 {
		misplaced += 1
	}
	return misplaced
}
