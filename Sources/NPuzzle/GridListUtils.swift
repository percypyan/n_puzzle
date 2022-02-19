/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   GridListUtils.swift                                :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: parchimb <parchimb@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2020/02/16 17:54:07 by parchimb          #+#    #+#             */
/*   Updated: 2020/02/16 17:54:08 by parchimb         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

import Foundation

func binarySearchGridStateInsertionIndex(forArray gridStateList: [GridState], totalWeight: Int, range: Range<Int>? = nil) -> Int {
	guard gridStateList.count > 0 else { return 0 }
	
	// Add start range if not specified.
	guard let range = range else {
		return binarySearchGridStateInsertionIndex(forArray: gridStateList, totalWeight: totalWeight, range: 0 ..< gridStateList.count)
	}
	
	// If first item in range is heavier or same weight that totalWeight, we found the index.
	if range.lowerBound < gridStateList.count && gridStateList[range.lowerBound].totalWeight >= totalWeight {
		return range.lowerBound
	}
	
	// If we already check everything, return last index.
	if range.lowerBound >= range.upperBound {
		return gridStateList.count
	}
	
	let midIndex = range.lowerBound + (range.upperBound - range.lowerBound) / 2
	
	if gridStateList[midIndex].totalWeight < totalWeight {
		// If mid item is lighter than totalWeight only keep second half of range.
		return binarySearchGridStateInsertionIndex(forArray: gridStateList, totalWeight: totalWeight, range: midIndex + 1 ..< range.upperBound)
	}
	// If mid item is heavier or same weight than totalWeight only keep first half of range.
	return binarySearchGridStateInsertionIndex(forArray: gridStateList, totalWeight: totalWeight, range: range.lowerBound ..< midIndex)
}

func binarySearchGridStateInsertionIndex(forArray gridStateList: [GridState], uid: String, range: Range<Int>? = nil) -> Int {
	guard gridStateList.count > 0 else { return 0 }
	
	// Add start range if not specified.
	guard let range = range else {
		return binarySearchGridStateInsertionIndex(forArray: gridStateList, uid: uid, range: 0 ..< gridStateList.count)
	}
	
	// If first item in range is heavier or same weight that totalWeight, we found the index.
	if range.lowerBound < gridStateList.count && gridStateList[range.lowerBound].uid.compare(uid) != .orderedAscending {
		return range.lowerBound
	}
	
	// If we already check everything, return last index.
	if range.lowerBound >= range.upperBound {
		return gridStateList.count
	}
	
	let midIndex = range.lowerBound + (range.upperBound - range.lowerBound) / 2
	let comparisonResult = gridStateList[midIndex].uid.compare(uid)
	
	if comparisonResult == .orderedAscending {
		return binarySearchGridStateInsertionIndex(forArray: gridStateList, uid: uid, range: midIndex + 1 ..< range.upperBound)
	}
	return binarySearchGridStateInsertionIndex(forArray: gridStateList, uid: uid, range: range.lowerBound ..< midIndex)
}

func binarySearchUIDIndex(forArray gridStateList: [GridState], uid: String, range: Range<Int>? = nil) -> Int? {
	// Add start range if not specified.
	guard let range = range else {
		return binarySearchUIDIndex(forArray: gridStateList, uid: uid, range: 0 ..< gridStateList.count)
	}
	
	// If we already check everything, return nil.
	if range.lowerBound >= range.upperBound {
		return nil
	}
	
	let midIndex = range.lowerBound + (range.upperBound - range.lowerBound) / 2
	let comparisonResult = gridStateList[midIndex].uid.compare(uid)
	
	if comparisonResult == .orderedAscending {
		return binarySearchUIDIndex(forArray: gridStateList, uid: uid, range: midIndex + 1 ..< range.upperBound)
	} else if comparisonResult == .orderedDescending {
		return binarySearchUIDIndex(forArray: gridStateList, uid: uid, range: range.lowerBound ..< midIndex)
	}
	return midIndex
}
