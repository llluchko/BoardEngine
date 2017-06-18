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

class Board {
	let rows: Int
	let columns: Int
	let middle: Coordinate
	var positions: [[ScrablePosition]] = []
	
	typealias Coordinate = (row: Int, col: Int)
	
	init(dimensions: (Int, Int)) {
		rows = dimensions.0
		columns = dimensions.1
		middle = (row: rows / 2, col: columns / 2)
		positions = []
		for _ in 0..<rows {
			var row: [ScrablePosition] = []
			for _ in 0..<columns {
				row.append(ScrablePosition())
			}
			positions.append(row)
		}
	}
	
	// Use convenience initializer to create an instance of that class for a specific use case or input value type
	convenience init?(dim: Int) {
		self.init(dimensions: (dim, dim))
	}

	private func isValidIndex(_ row: Int, _ col: Int) -> Bool {
		return row >= 0 && row < rows && col >= 0 && col < columns
	}
	
	private func areWordCoordinatesValid(_ coordinates: Coordinate, _ direction: Direction, _ lettersCount: Int) -> Bool {
		let isStartIndexValid = isValidIndex(coordinates.row, coordinates.col)
		var isEndIndexValid: Bool
		
		switch direction {
		case .horizontal:
			isEndIndexValid = isValidIndex(coordinates.row, coordinates.col + lettersCount - 1)
		case .vertical:
			isEndIndexValid = isValidIndex(coordinates.row + lettersCount - 1, coordinates.col)
		}
		
		return isStartIndexValid && isEndIndexValid
	}
	
	subscript(row: Int, col: Int) -> ScrablePosition {
		get {
			assert(isValidIndex(row, col), "Index out of range.")
			return positions[row][col]
		}
		set {
			assert(isValidIndex(row, col), "Index out of range.")
			positions[row][col] = newValue
		}
	}
	
	private func areElementsEmpty(_ elements: [Element<T>], _ lettersCount: Int, _ startRowCol: Coordinate, _ direction: Direction) -> Bool {
		if direction == .horizontal {
			for i in 0..<lettersCount {
				if self[startRowCol.row, startRowCol.col + i].hasElement() == true {
					return false
				}
			}
		} else {
			for i in 0..<lettersCount {
				if self[startRowCol.row + i, startRowCol.col].hasElement() == true {
					return false
				}
			}
		}
		return true
	}
	
	func isCenterEmpty() -> Bool {
		return positions[middle.row][middle.col].hasElement() == false
	}
	
	// Calculate score of words
	private func addWordWithScore(_ elements: [Element<T>], _ start: Coordinate, _ direction: Direction) -> Int {
		var score = 0
		var wsMultipliers: [Int] = []
		for (index, element) in elements.enumerated() {
			var currentIndex = start
			switch direction {
			case .horizontal:
				currentIndex.col = currentIndex.col + index
			case .vertical:
				currentIndex.row = currentIndex.row + index
			}
			// type is the type of bonus
			var lsMultiplier = 1
			let currentPosition = self[currentIndex.row, currentIndex.col]
			if currentPosition.type != nil {
				if currentPosition.type == "WS" {
					wsMultipliers.append(currentPosition.multiplier!)
				} else {
					lsMultiplier = currentPosition.multiplier!
				}
			}
			if self[currentIndex.row, currentIndex.col].hasElement() == false {
				self[currentIndex.row, currentIndex.col].setElement(element: element)
				score = score + element.score * lsMultiplier
			}
			else if self[currentIndex.row, currentIndex.col].hasElement() == true
				&& self[currentIndex.row, currentIndex.col].element!.substance == element.substance {
				score = score + element.score * lsMultiplier
			}
		}
		for i in wsMultipliers {
			score = score * i
		}
		return score
	}
	
	func addWord(word: [Element<T>], startRowCol: Coordinate, direction: Direction) -> Int {
		if isCenterEmpty() && startRowCol != middle {
			print("Please start your first word from the middle of the board.")
			return 0
		}
		
		if areElementsEmpty(word, word.count, startRowCol, direction) == false
			|| areWordCoordinatesValid(startRowCol, direction, word.count) == false {
			print("Can't write the word on the board.")
			return 0
		} else {
			return addWordWithScore(word, startRowCol, direction)
		}
	}
	
	func saveBoardToFile() {
		let savedGameFile = Bundle.main.path(forResource: "new_game", ofType: "txt")
		
		Parser.writeToFile(content: "--BOARD--", filePath: savedGameFile!)
		Parser.writeToFile(content: "\(rows) \(columns)", filePath: savedGameFile!)
		
		for i in 0..<rows {
			for j in 0..<columns {
				var line = ""
				if self[i, j].hasBonus() == true && self[i, j].hasElement() == true {
					line += "\(i) \(j) \(self[i, j].type!) \(self[i, j].multiplier!)"
					line += "\n"
					line += "\(i) \(j) \(self[i, j].element!.substance) \(self[i, j].element!.score)"
				}
				else if self[i, j].hasBonus() == true && self[i, j].hasElement() == false {
					line += "\(i) \(j) \(self[i, j].type!) \(self[i, j].multiplier!)"
				}
				else if self[i, j].hasBonus() == false && self[i, j].hasElement() == true {
					line += "\(i) \(j) \(self[i, j].element!.substance) \(self[i, j].element!.score)"
				}
				if line != "" {
					print(line)
					Parser.writeToFile(content: line, filePath: savedGameFile!)
				}
			}
		}
	}
}

extension Board: CustomStringConvertible {
	var description: String {
		return positions.map { row in row.map { $0.description }.joined(separator: " | ") }
			.joined(separator: "\n\n") + "\n\n"
	}
}


