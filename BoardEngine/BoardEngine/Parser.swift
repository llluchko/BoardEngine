//
//  Parser.swift
//  BoardEngine
//
//  Created by Latchezar Mladenov on 5/24/17.
//
//

import Foundation

class Parser {
	
	static func parseGameConfiguration(path: String) -> GameConfig? {
		var gameConfig = GameConfig()
		
		let config = Parser.getEncodedFileContent(filename: path)!
		var configLines = Parser.getLines(file: config)
		configLines = Parser.removeLines(lines: configLines)
		
		let boardStartIndex   = configLines.index(of: "--BOARD--")!
		let lettersStartIndex = configLines.index(of: "--LETTERS--")!
		
		let boardSize = configLines[boardStartIndex + 1].components(separatedBy: " ").map { Int($0) ?? 0 }
		
		let boardDimensions = (boardSize[0], boardSize[1])
		
		var bonuses: [(coordinates: (Int, Int), type: String, multiplier: Int)] = [((Int, Int), String, Int)]()
		
		for line in configLines[boardStartIndex + 2 ... lettersStartIndex - 1] {
			let line = line.components(separatedBy: " ")
			if line.count < 4 {
				print("Line components cannot be < 4.")
				return nil
			}
			guard let row = Int(line[0]),
				let col = Int(line[1]),
				let multiplyBy = Int(line[3])
				else {
					print("Wrong input data.")
					return nil
			}
			let rowCol = (row, col)
			let type = line[2]
			
			bonuses.append((rowCol, type, multiplyBy))
		}
		
		var elements: [(Element, Int)] = [(Element, Int)]()
		
		for line in configLines[lettersStartIndex + 1 ... configLines.count - 1] {
			let line = line.components(separatedBy: " ")
			if line.count < 3 {
				print("Line components cannot be < 3.")
				return nil
			}
			let letter = Character(line[0])
			guard let occurences = Int(line[1]),
				let points = Int(line[2])
				else {
					print("Wrong input data.")
					return nil
			}
			let currentElement = Element(letter: letter, score: points)
			elements.append((currentElement, occurences))
		}
		
		gameConfig.dimensions = boardDimensions
		gameConfig.elements = elements
		gameConfig.bonuses = bonuses
		
		return gameConfig
	}
	
	static func getEncodedFileContent(filename: String) -> String? {
		var file : String? = nil
		do {
			file = try String(
				contentsOfFile: filename,
				encoding: String.Encoding.utf8
			)
		} catch let error {
			print(error)
		}
		return file
	}
	
	static func getLines(file: String) -> [String] {
		let lines = file.components(separatedBy: "\n")
		return lines
	}
	
	static func removeLines(lines: [String]) -> [String] {
		return lines.filter { $0.isEmpty == false }.filter { $0[$0.startIndex] != "#" }
	}
}
