//
//  DataManager.swift
//  ToDoProject
//
//  Created by Keunna Lee on 2020/04/09.
//  Copyright © 2020 dev-Lena. All rights reserved.
//

import Foundation

class DataManager {
    
    static let ToDoCardsDecodedNotification = NSNotification.Name("ToDoCardsDecodedNotification")
    static let AddCardCompletedNotification = NSNotification.Name("AddCardCompletedNotification")
    static let FinishToMoveNotification = NSNotification.Name("FinishToMoveNotification")
    var cardsData: ToDoCardInfo?
    private let headerUserId = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1c2VySW5mbyIsImV4cCI6MTU4NzEwODY1MDMzOCwidXNlck5hbWUiOiJsZW5hIiwidXNlcklkIjoibGVuYUlEIn0.AL10nktx6wLaOrisRDyZMnxmN2myulKVzLXiV5V3eCk"
    private var cardCount: String?
    private var responseCard: Card?
    private var addedCardColumn: String?
    
    func cardsDataCount() -> Int?{
        self.cardsData?.responseData.cards.count ?? 0
    }
    
    func requestData(of column: String) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        let url = URL(string: "http://15.164.78.121:8080/api/columns/\(column)")
        var request = URLRequest(url: url!)
        request.httpMethod = RequestMethod.get
        request.addValue(self.headerUserId, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do{
                let decodedData = try decoder.decode(ToDoCardInfo.self, from: data)
                self.cardsData = decodedData
                self.cardCount = " \( decodedData.responseData.cards.count)"
                self.sendNotification()
            } catch {
                self.cardsData = nil
            }
        }
        
        task.resume()
    }
    
    // Add Card and Edit Card
    func requestUpdateCard(card: NewCardForm, requestMethod: String, column: String, cardId: Int?) {
        let columnId = switchColumnId(column: column)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        let jsonData = try? encoder.encode(card)
        if let jsonData = jsonData, let jsonString = String(data: jsonData, encoding: .utf8){
            var url = URL(string: "")
            if cardId == nil {
                url = URL(string: "http://15.164.78.121:8080/api/columns/\(columnId)/cards")
            } else {
                guard let editCardId = cardId else { return }
                url = URL(string: "http://15.164.78.121:8080/api/columns/\(columnId)/cards/\(editCardId)")
            }
            var request = URLRequest(url: url!)
            request.httpMethod = requestMethod
            request.httpBody = jsonData
            request.addValue(self.headerUserId, forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(String(jsonData.count), forHTTPHeaderField: "Content-Length")
            let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
                guard let data = data, error == nil else { print("error=\(error)"); return}
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }else{
                    print("statusCode is 200, Success")
                    let decoder = JSONDecoder()
                    do{
                        let decodedData = try decoder.decode(ResponseDataForm.self, from: data)
                        self.responseCard = decodedData.responseData
                        self.addedCardColumn = column
                        self.sendCompletionNotification(requestMethod: requestMethod)
                    } catch {
                        self.responseCard = nil
                    }
                }
            }
            task.resume()
        }
    }
    
    func requestDeleteCard(columnId: Int,cardId: Int) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        let url = URL(string: "http://15.164.78.121:8080/api/columns/\(columnId)/cards/\(cardId)")
        var request = URLRequest(url: url!)
        request.httpMethod = RequestMethod.delete
        request.addValue(self.headerUserId, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
            guard let data = data, error == nil else { print("error=\(error)")
                return }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            } else {
                print("statusCode is 200, Success")
                self.sendNotification()
            }
        }
        task.resume()
    }
    
    
    func requestMoveCard(movingInfo: MoveCardForm, originalColumnId: Int, originalCardId: Int, originalCardRow: Int){
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        let jsonData = try? encoder.encode(movingInfo)
        if let jsonData = jsonData, let jsonString = String(data: jsonData, encoding: .utf8){
            let url = URL(string: "http://15.164.78.121:8080/api/columns/\(originalColumnId)/cards/\(originalCardId)")
            var request = URLRequest(url: url!)
            request.httpMethod = RequestMethod.patch
            request.httpBody = jsonData
            request.addValue(self.headerUserId, forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(String(jsonData.count), forHTTPHeaderField: "Content-Length")
            let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
                guard let data = data, error == nil else { print("error=\(error)"); return}
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }else{
                    print("statusCode is 200, Success")
                    let decoder = JSONDecoder()
                    do{
                        let decodedData = try decoder.decode(ResponseDataForm.self, from: data)
                        self.responseCard = decodedData.responseData
                        self.sendFinishToMoveNotification(movingInfo: movingInfo, movedCard: self.responseCard!, originalCardInfo: (self.switchColumnName(column: originalColumnId), originalCardRow))
                        
                    } catch {
                        self.responseCard = nil
                    }
                }
            }
            task.resume()
        }
    }
    
    func switchColumnName(column: Int) -> String{
        switch column {
        case 1 : return Column.toDoColumn
        case 2 : return Column.inProgressColumn
        case 3 : return Column.doneColumn
        default:
            return Column.toDoColumn
        }
    }
    
    func switchColumnId(column: String) -> Int {
        switch column {
        case Column.toDoColumn : return 1
        case Column.inProgressColumn : return 2
        case Column.doneColumn : return 3
        default:
            return 1
        }
    }
    
    func switchURLColumnId(column: String) -> Int {
        switch column {
        case ColumnURLName.toDo : return 1
        case ColumnURLName.inProgress : return 2
        case ColumnURLName.done : return 3
        default:
            return 1
        }
    }
    
    // Using when tableview first load
    private func sendNotification() {
        NotificationCenter.default.post(name: DataManager.ToDoCardsDecodedNotification, object: nil,userInfo: [NotificationUserInfoKey.cardCount: cardCount!])
    }
    
    // Using when add & edit card
    private func sendCompletionNotification(requestMethod: String) {
        NotificationCenter.default.post(name: DataManager.AddCardCompletedNotification, object: nil, userInfo: [NotificationUserInfoKey.addedCardInfo: responseCard!, NotificationUserInfoKey.addedCardColumn: addedCardColumn!, NotificationUserInfoKey.requestMethod: requestMethod])
    }
    
    // Usig when move card
    private func sendFinishToMoveNotification(movingInfo: MoveCardForm, movedCard: Card, originalCardInfo: (String,Int)) {
        NotificationCenter.default.post(name: DataManager.FinishToMoveNotification, object: nil, userInfo: [NotificationUserInfoKey.movingInfo: movingInfo, NotificationUserInfoKey.movedCard: movedCard, NotificationUserInfoKey.originalCardInfo: originalCardInfo])
    }
}
