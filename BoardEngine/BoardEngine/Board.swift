//
//  Board.swift
//  BoardEngine
//
//  Created by Latchezar Mladenov on 5/13/17.
//
//

import Foundation

enum Direction {
	case horizontal
	case vertical
}

typealias Coordinate = (row: Int, col: Int)

class Board {
	let rows: Int
	let columns: Int
	let middle: Coordinate
	var positions: [[Position]] = []
	
	init(dimensions: (Int, Int)) {
		rows = dimensions.0
		columns = dimensions.1
		middle = (row: rows / 2, col: columns / 2)
		positions = Array(
			repeating: Array(repeating: Position(), count: columns),
			count: rows
		)
	}
	
	// Use convenience initializer to create an instance of that class for a specific use case or input value type
	convenience init?(dim: Int) {
		self.init(dimensions: (dim, dim))
	}
}
