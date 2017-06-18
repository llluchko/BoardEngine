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
		
		var elements: [(Element<T>, Int)] = [(Element<T>, Int)]()
		
		for line in configLines[lettersStartIndex + 1 ... configLines.count - 1] {
			let line = line.components(separatedBy: " ")
			if line.count < 3 {
				print("Line components cannot be < 3.")
				return nil
			}
			let letter = T(line[0])
			guard let occurences = Int(line[1]),
				let points = Int(line[2])
				else {
					print("Wrong input data.")
					return nil
			}
			let currentElement = Element(substance: letter, score: points)
			elements.append((currentElement, occurences))
		}
		
		gameConfig.dimensions = boardDimensions
		gameConfig.elements = elements
		gameConfig.bonuses = bonuses
		
		return gameConfig
	}
	
	static func parseGameData(path: String) -> GameData? {
		var gameData = GameData()
		
		let savedGame = Parser.getEncodedFileContent(filename: path)!
		var lines = Parser.getLines(file: savedGame)
		lines = Parser.removeLines(lines: lines)
		
		let playersStartIndex = lines.index(of: "--PLAYERS--")!
		let turnsStartIndex = lines.index(of: "--TURNS--")!
		
		var players: [Player] = [Player]()
		for name in lines[playersStartIndex+1...turnsStartIndex-1] {
			let currentPlayer = Player(name: name)
			players.append(currentPlayer)
		}
		
		var turns: [(player: Player, startPosition: (Int, Int), direction: Direction, word: String)] =
			[(Player, (Int, Int), Direction, String)]()
		
		for l in lines[turnsStartIndex+1...lines.count-1] {
			var line = l.components(separatedBy: " ")
			if line.count < 5 {
				print("Line components cannot be < 5.")
				return nil
			}
			
			let player = Player(name: line[0])
			guard let row = Int(line[1]),
				let col = Int(line[2])
				else {
					return nil
			}
			var wordStartDirection: Direction
			switch line[3] {
			case "H":
				wordStartDirection = .horizontal
			case "V":
				wordStartDirection = .vertical
			default: return nil
			}
			let playerWord = line[4]
			turns.append((player, (row, col), wordStartDirection, playerWord))
		}
		
		gameData.players = players
		gameData.turns = turns
		
		return gameData
	}
	
	static func writeToFile(content: String, filePath: String) {
		let contentToAppend = content + "\n"
		
		if let fileHandle = FileHandle(forWritingAtPath: filePath) {
			let data = contentToAppend.data(using: String.Encoding.utf8)
			fileHandle.seekToEndOfFile()
			fileHandle.write(data!)
		}
		else {
			do {
				try contentToAppend.write(toFile: filePath, atomically: false, encoding: String.Encoding.utf8)
			} catch {
				print("Error creating \(filePath)")
			}
		}
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
	
	static func getLetterScore(_ elements : [(Element<T>, Int)], _ letter: T) -> Int {
		for item in elements {
			if item.0.substance == letter {
				return item.0.score
			}
		}
		return 1
	}
}
