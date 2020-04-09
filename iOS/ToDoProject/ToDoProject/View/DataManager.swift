//
//  DataManager.swift
//  ToDoProject
//
//  Created by Keunna Lee on 2020/04/09.
//  Copyright © 2020 dev-Lena. All rights reserved.
//

import Foundation

class DataManager {
    private let microDustURL = "https://49f69bb9-2cf6-4590-af83-a8890ac67d7c.mock.pstmn.io/requestCardList"
    
    private(set) var totalToDoCards: ToDoCardInfo?
    private var toDoCards: [Card]?
    private var inProgressCards: [Card]?
    private var doneCards: [Card]?
    
    init() {
        decodeJson()
        distributeCardData()
    }
    
    func totalToDoCardsCount() -> Int?{
        return totalToDoCards?.responseMessage.count
    }
    
    private func decodeJson(){
        guard let url = URL(string: microDustURL) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { self.totalToDoCards = nil; return }
            guard let data = data else { self.totalToDoCards = nil; return }
            let decoder = JSONDecoder()
            do{
                self.totalToDoCards = try decoder.decode(ToDoCardInfo.self, from: data)
            } catch {
                self.totalToDoCards = nil
            }
        }.resume()
    }
    
    private func distributeCardData(){
        self.totalToDoCards?.responseMessage.forEach{ column in
            
            if column.colName == Column.ToDoColumn {
                self.toDoCards = column.columnData
                print(self.toDoCards)
            }
            if column.colName == Column.InProgressColumn {
                self.inProgressCards = column.columnData
            }
            if column.colName == Column.DoneColumn{
                self.doneCards = column.columnData
            }
        }
    }
}
