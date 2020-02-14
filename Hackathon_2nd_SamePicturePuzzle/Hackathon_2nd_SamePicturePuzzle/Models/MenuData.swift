//
//  MenuData.swift
//  puzzle
//
//  Created by macbook on 2020/01/31.
//  Copyright © 2020 Lance. All rights reserved.
//

import Foundation

struct Cards {
  let name: String
}


var card: [String] = {
    var arr = [String]()
    (0...41).forEach { arr.append("item\($0)") }
//    print(arr)
    return arr
}()

var normalCards: [Cards] = Array(1...10).map { _ in
    Cards(name: card.randomElement()!)
}

var nightCards: [Cards] = Array(1...20).map { _ in
    Cards(name: card.randomElement()!)
}

var hellCards: [Cards] = Array(1...30).map { _ in
    Cards(name: card.randomElement()!)
}
