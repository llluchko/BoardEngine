//
//  GameData.swift
//  BoardEngine
//
//  Created by Latchezar Mladenov on 5/24/17.
//
//

import Foundation

struct GameData {
	var players: [Player] = [Player]()
	var turns: [(player: Player, startPosition: (Int, Int), direction: Direction, word: String)] = [(Player, (Int, Int), Direction, String)]()
}
