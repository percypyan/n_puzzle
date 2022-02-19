/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   AStar.swift                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: parchimb <parchimb@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2020/02/16 17:54:07 by parchimb          #+#    #+#             */
/*   Updated: 2020/02/16 17:54:08 by parchimb         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

import Foundation

let numberFormatter = NumberFormatter()

func insertInRightPosition(states: [GridState], state: GridState, isVerbose: Bool = false) -> [GridState] {
	var newStates = states
	let index = binarySearchGridStateInsertionIndex(forArray: states, totalWeight: state.totalWeight)
//	let index = newStates.firstIndex(where: { $0.totalWeight >= state.totalWeight }) ?? states.count
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

struct AStarConfig {
	let heuristicFunction: ([[Int]]) -> Int
	let useIterativeDeepening: Bool
	let isVerbose: Bool
}

func runAStarWith(grid: [[Int]], andConfig config: AStarConfig) -> AStarResult {
	let startTime = Date()

	var openedStates: [GridState] = [GridState(grid: grid, heuristicFunction: config.heuristicFunction)]
	var maxWeight = openedStates.first!.heuristicWeight
	var closedStates: [GridState] = []
	var finaleState: GridState? = nil
	var nodesExplored = 0
	var maxKnownNodes = 1
	while openedStates.count != 0 && finaleState == nil {
		nodesExplored += 1
		let evaluatedState = openedStates.removeFirst()
		if config.isVerbose {
			print("Evaluate node #\(nodesExplored):")
			print(grid: evaluatedState.grid)
			print("HW: \(evaluatedState.heuristicWeight) | PW: \(evaluatedState.pathWeight) | TW: \(evaluatedState.totalWeight)")
		}
		if evaluatedState.isFinaleState {
			if config.isVerbose { print("This node represent a solved puzzle. Search completed.\n") }
			finaleState = evaluatedState
			break
		}

		let children = evaluatedState.getChildren()
		var minOverWeightedChild: GridState? = nil
		var openedChildrenCount = 0
		for child in children {
			if let index = openedStates.firstIndex(where: { $0.uid == child.uid }) { // Last O(n)
				guard openedStates[index].totalWeight > child.totalWeight else { continue }
				openedStates.remove(at: index)
			} else if let index = binarySearchUIDIndex(forArray: closedStates, uid: child.uid) { // closedStates.firstIndex(where: { $0.uid == child.uid }) {
				guard closedStates[index].totalWeight > child.totalWeight else { continue }
				closedStates.remove(at: index)
			}
			if !config.useIterativeDeepening || child.heuristicWeight <= maxWeight {
				openedStates = insertInRightPosition(states: openedStates, state: child, isVerbose: config.isVerbose)
				openedChildrenCount += 1
			} else {
				minOverWeightedChild = child.heuristicWeight < minOverWeightedChild?.heuristicWeight ?? (child.heuristicWeight + 1)
					? child
					: minOverWeightedChild
			}
		}
		if let maxOWChild = minOverWeightedChild, openedChildrenCount == 0 {
			openedStates = insertInRightPosition(states: openedStates, state: maxOWChild, isVerbose: config.isVerbose)
		}
		
		// Keep closed states ordered by UID.
		let insertionIndex = binarySearchGridStateInsertionIndex(forArray: closedStates, uid: evaluatedState.uid)
		closedStates.insert(evaluatedState, at: insertionIndex)
		
		let currentKnownNodes = closedStates.count + openedStates.count
		if currentKnownNodes > maxKnownNodes {
			maxKnownNodes = currentKnownNodes
		}
		if (config.useIterativeDeepening) {
			maxWeight = minOverWeightedChild?.heuristicWeight ?? maxWeight
		}
		
		if config.isVerbose {
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
