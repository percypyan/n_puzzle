//
//  a_star.swift
//  n_puzzle
//
//  Created by Perceval Archimbaud on 02/02/2020.
//  Copyright © 2020 Archimbaud. All rights reserved.
//

import Foundation

func insertInRightPosition(states: [GridState], state: GridState, isVerbose: Bool = false) -> [GridState] {
	var newStates = states
	let index = states.firstIndex(where: { $0.totalWeight >= state.totalWeight }) ?? states.count
	newStates.insert(state, at: index)
	if isVerbose { print("Add child induce by \(state.executedMove!) to opened nodes at index \(index).") }
	return newStates
}

struct AStarResult {
	let nodesExplored: Int
	let maxKnownNodes: Int
	let timeElapsed: TimeInterval
	let solution: String
}

func runAStarWith(grid: [[Int]], andHeuristicFunction heuristicFunction: @escaping ([[Int]]) -> Int, inVerboseMode isVerbose: Bool = false) -> AStarResult {
	let startTime = Date()

	var openedStates: [GridState] = [GridState(grid: grid, heuristicFunction: heuristicFunction)]
	var closedStates: [GridState] = []
	var finaleState: GridState? = nil
	var nodesExplored = 0
	var maxKnownNodes = 1
	while openedStates.count != 0 && finaleState == nil {
		nodesExplored += 1
		let evaluatedState = openedStates.removeFirst()
		if isVerbose {
			print("Evaluate node #\(nodesExplored):")
			print(grid: evaluatedState.grid)
			print("HW: \(evaluatedState.heuristicWeight) | PW: \(evaluatedState.pathWeight) | TW: \(evaluatedState.totalWeight)")
		}
		if evaluatedState.isFinaleState {
			if isVerbose { print("This node represent a solved puzzle. Search completed.\n") }
			finaleState = evaluatedState
			break
		}

		let children = evaluatedState.getChildren()
		for child in children {
			if let index = openedStates.firstIndex(where: { $0.uid == child.uid }) {
				if openedStates[index].totalWeight > child.totalWeight {
					openedStates.remove(at: index)
					openedStates = insertInRightPosition(states: openedStates, state: child, isVerbose: isVerbose)
				}
			} else if let index = closedStates.firstIndex(where: { $0.uid == child.uid }) {
				if closedStates[index].totalWeight > child.totalWeight {
					closedStates.remove(at: index)
					openedStates = insertInRightPosition(states: openedStates, state: child, isVerbose: isVerbose)
				}
			} else {
				openedStates = insertInRightPosition(states: openedStates, state: child, isVerbose: isVerbose)
			}
		}
		closedStates.append(evaluatedState)
		let currentKnownNodes = closedStates.count + openedStates.count
		if currentKnownNodes > maxKnownNodes {
			maxKnownNodes = currentKnownNodes
		}
		if isVerbose {
			print("Close this node.\n")
			print("Opened nodes: \(openedStates.count) | Closed nodes: \(closedStates.count)\n")
		}
	}

	let timeElapsed = startTime.distance(to: Date())

	var path = ""
	if let state = finaleState {
		var currentState: GridState? = state
		while currentState?.executedMove != nil {
			path = "\(currentState!.executedMove!.rawValue)\(path)"
			currentState = currentState!.parent
		}
	} else {
		path = "ø"
	}
	return AStarResult(nodesExplored: nodesExplored, maxKnownNodes: maxKnownNodes, timeElapsed: timeElapsed, solution: path)
}

func printResultReport(result: AStarResult, onOneLine: Bool = false) {
	let formatter = NumberFormatter()
	formatter.maximumFractionDigits = 3
	
	if onOneLine {
		print("\(result.solution) - \(result.nodesExplored) states - \(formatter.string(from: NSNumber(value: result.timeElapsed))!)s")
	} else {
		print("Puzzle solvable in \(result.solution.count) moves.")
		print("Solution: \(result.solution).")
		print("Nodes explored: \(result.nodesExplored).")
		print("Maximum number of simultaneous known nodes: \(result.maxKnownNodes).")
		print("Time elapsed: \(formatter.string(from: NSNumber(value: result.timeElapsed))!)s.")
	}
}
