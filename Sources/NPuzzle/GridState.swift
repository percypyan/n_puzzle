/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   GridState.swift                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: parchimb <parchimb@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2020/02/16 17:53:57 by parchimb          #+#    #+#             */
/*   Updated: 2020/02/16 17:53:59 by parchimb         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

import Foundation

class GridState {

	let grid: [[Int]]
	let executedMove: Move?
	var parent: GridState?
	let heuristicFunction: ([[Int]]) -> Int
	let heuristicWeight: Int
	var pathWeight: Int
	let uid: String
	let zeroPosition: GridPosition

	var totalWeight: Int {
		get { self.heuristicWeight + self.pathWeight }
	}
	var isFinaleState: Bool {
		get { return heuristicWeight == 0 }
	}

	private init(grid: [[Int]], parent: GridState?, heuristicFunction: (([[Int]]) -> Int)?, executedMove: Move?) {
		self.grid = grid
		self.parent = parent
		self.heuristicFunction = parent?.heuristicFunction ?? heuristicFunction!
		self.pathWeight = parent != nil ? parent!.pathWeight + 1 : 0
		self.heuristicWeight = self.heuristicFunction(grid)
		self.executedMove = executedMove

		var uid = ""
		var zeroPosition: GridPosition? = nil
		for y in 0...(grid.count - 1) {
			for x in 0...(grid[y].count - 1) {
				uid += "-\(grid[y][x])"
				if grid[y][x] == 0 {
					zeroPosition = GridPosition(x: x, y: y)
				}
			}
		}
		self.zeroPosition = zeroPosition!
		self.uid = String(uid.dropFirst())
	}

	convenience init(grid: [[Int]], heuristicFunction: @escaping ([[Int]]) -> Int) {
		self.init(
			grid: grid,
			parent: nil,
			heuristicFunction: heuristicFunction,
			executedMove: nil
		)
	}

	convenience init(parent: GridState, move: Move) {
		self.init(
			grid: apply(move: move, toGrid: parent.grid, withZeroPosition: parent.zeroPosition),
			parent: parent,
			heuristicFunction: nil,
			executedMove: move
		)
	}

	func getChildren() -> [GridState] {
		var children: [GridState] = []
		let vSize = grid.count
		let hSize = grid[0].count

		if zeroPosition.x > 0 {
			children.append(GridState(parent: self, move: .left))
		}
		if zeroPosition.x < hSize - 1 {
			children.append(GridState(parent: self, move: .right))
		}
		if zeroPosition.y > 0 {
			children.append(GridState(parent: self, move: .up))
		}
		if zeroPosition.y < vSize - 1 {
			children.append(GridState(parent: self, move: .down))
		}
		return children
	}

}
