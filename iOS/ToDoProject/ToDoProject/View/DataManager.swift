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
    private var cardCount: String?
    private var responseCard: Card?
    private var addedCardColumn: String?
    
    func cardsDataCount() -> Int?{
        self.cardsData?.responseData.cards.count ?? 0
    }
    
    func requestData(of column: String) {
        let toDoCardsURL =
        "http://15.164.78.121:8080/api/columns/\(column)"
        guard let url = URL(string: toDoCardsURL) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
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
        }.resume()
    }
    
    // Add Card and Edit Card
    func requestUpdateCard(card: NewCardForm, requestMethod: String) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        let jsonData = try? encoder.encode(card)
        if let jsonData = jsonData, let jsonString = String(data: jsonData, encoding: .utf8){
            let url = URL(string: "http://15.164.78.121:8080/api/cards")
            var request = URLRequest(url: url!)
            request.httpMethod = requestMethod
            request.httpBody = jsonData
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
                        self.addedCardColumn = card.colName
                        self.sendCompletionNotification(requestMethod: requestMethod)
                    } catch {
                        self.responseCard = nil
                    }
                }
            }
            task.resume()
        }
    }
    
    func requestDeleteCard(cardId: DeleteCardForm) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        let jsonData = try? encoder.encode(cardId)
        if let jsonData = jsonData, let jsonString = String(data: jsonData, encoding: .utf8){
            let url = URL(string: "http://15.164.78.121:8080/api/cards")
            var request = URLRequest(url: url!)
            request.httpMethod = RequestMethod.delete
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(String(jsonData.count), forHTTPHeaderField: "Content-Length")
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
    }
    
    func requestMoveCard(movingInfo: MoveCardForm){
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        let jsonData = try? encoder.encode(movingInfo)
        if let jsonData = jsonData, let jsonString = String(data: jsonData, encoding: .utf8){
            let url = URL(string: "http://15.164.78.121:8080/api/cards/move")
            var request = URLRequest(url: url!)
            request.httpMethod = RequestMethod.post
            request.httpBody = jsonData
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
                        self.sendFinishToMoveNotification(movingInfo: movingInfo, movedCard: self.responseCard!)
                        
                    } catch {
                        self.responseCard = nil
                    }
                }
            }
            task.resume()
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
    private func sendFinishToMoveNotification(movingInfo: MoveCardForm, movedCard: Card) {
        NotificationCenter.default.post(name: DataManager.FinishToMoveNotification, object: nil, userInfo: [NotificationUserInfoKey.movingInfo: movingInfo, NotificationUserInfoKey.movedCard: movedCard])
    }
}
