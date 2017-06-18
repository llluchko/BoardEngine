//
//  Position.swift
//  BoardEngine
//
//  Created by Latchezar Mladenov on 6/18/17.
//  Copyright © 2017 Latchezar Mladenov. All rights reserved.
//

import Foundation

protocol Position: Hashable, Equatable {
	var type: String? { get set } // bonus type
	var multiplier: Int? { get set }
	func hasBonus() -> Bool
	func hasElement() -> Bool
}
