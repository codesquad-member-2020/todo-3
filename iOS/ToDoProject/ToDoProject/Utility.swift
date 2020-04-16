//
//  Utility.swift
//  ToDoProject
//
//  Created by Keunna Lee on 2020/04/10.
//  Copyright © 2020 dev-Lena. All rights reserved.
//

import Foundation

enum KeyColorName{
    static let violetsAreBlue = "violetsAreBlue"
    static let mediumPurple = "mediumPurple"
    static let richLavender = "richLavender"
}

enum SystemImageName{
    static let circle = "circle.fill"
    static let plus = "plus"
}

enum Column {
    static let toDoColumn = "To Do"
    static let inProgressColumn = "In Progress"
    static let doneColumn = "Done"
}

enum ColumnURLName {
    static let toDo = "To_Do"
    static let inProgress = "In_Progress"
    static let done = "Done"
    
}

enum NotificationUserInfoKey {
    static let cardCount = "cardCount"
    static let addedCardInfo = "addedCardInfo"
    static let addedCardColumn = "addedCardColumn"
    static let columnName = "columnName"
    static let cardRow = "cardRow"
    static let requestMethod = "requestMethod"
    static let movingInfo = "movingInfo"
    static let movedCard = "movedCard"
    static let originalCardInfo = "originalCardInfo"
}

enum RequestMethod {
    static let get = "GET"
    static let post = "POST"
    static let put = "PUT" // edit card
    static let patch = "PATCH"
    static let delete = "DELETE" // delete card
}
