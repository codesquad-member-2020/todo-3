//
//  ToDoCardInfo.swift
//  ToDoProject
//
//  Created by Keunna Lee on 2020/04/09.
//  Copyright © 2020 dev-Lena. All rights reserved.
//

import Foundation

struct ToDoCardInfo: Codable {
    let responseMessage: [ToDoCard]
}
struct ToDoCard: Codable {
    let colName: String
    let columnData: [Card]
}
struct Card: Codable {
    let id: Int
    let index: Int
    let title: String
    let contents: String
    let writer: String
}
