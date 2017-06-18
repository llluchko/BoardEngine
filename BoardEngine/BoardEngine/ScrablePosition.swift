//
//  Bonus.swift
//  BoardEngine
//
//  Created by Latchezar Mladenov on 5/24/17.
//
//

import Foundation

typealias T = Character

class ScrablePosition: Position {
	var hashValue: Int = -1
	var type: String?
	var multiplier: Int?
	var element: Element<T>?
	
	init() {
		type = nil
		multiplier = nil
		element = nil
	}
	
	init(type: String, multiplier: Int) {
		self.type = type
		self.multiplier = multiplier
	}
	
	static func ==(lhs: ScrablePosition, rhs: ScrablePosition) -> Bool {
		return false
	}
	
	func hasBonus() -> Bool {
		return type != nil
	}
	
	func setElement(element: Element<T>) {
		self.element = element
	}
	
	func hasElement() -> Bool {
		return element != nil
	}
}

extension ScrablePosition: CustomStringConvertible {
	var description: String {
		return "\(String(describing: type))-\(String(describing: multiplier))-\(String(describing: element))"
	}
}
