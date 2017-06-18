//
//  GameCongif.swift
//  BoardEngine
//
//  Created by Latchezar Mladenov on 5/24/17.
//
//

import Foundation

struct GameConfig {
	var dimensions: (rows: Int, cols: Int) = (rows: 0, cols: 0)
	var elements: [(Element<T>, Int)] = [(Element<T>, Int)]()
	var bonuses: [(coordinates: (Int, Int), type: String, multiplier: Int)] = [((Int, Int), String, Int)]()
}
