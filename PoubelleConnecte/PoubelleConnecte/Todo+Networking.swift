//
//  Todo+Networking.swift
//  PoubelleConnecte
//
//  Created by Tayeb Sedraia on 28/04/2017.
//  Copyright © 2017 Tayeb Sedraia. All rights reserved.
//

import Foundation
import Alamofire

enum BackendError: Error {
    case objectSerialization(reason: String)
}

extension Todo {
    class func endpointForID(_ id: Int) -> String {
        return "https://jsonplaceholder.typicode.com/todos/\(id)"
    }
    class func endpointForTodos() -> String {
        return "https://jsonplaceholder.typicode.com/todos/"
    }
    
    convenience init?(json: [String: Any]) {
        guard let title = json["title"] as? String,
            let userId = json["userId"] as? Int,
            let completed = json["completed"] as? Bool
            else {
                return nil
        }
        
        let idValue = json["id"] as? Int
        
        self.init(title: title, id: idValue, userId: userId, completedStatus: completed)
    }
    
    func toJSON() -> [String: Any] {
        var json = [String: Any]()
        json["title"] = title
        if let id = id {
            json["id"] = id
        }
        json["userId"] = userId
        json["completed"] = completed
        return json
    }
    
    class func todoByID(_ id: Int, completionHandler: @escaping (Result<Todo>) -> Void) {
        Alamofire.request(Todo.endpointForID(id))
            .responseJSON { response in
                let result = Todo.todoFromResponse(response: response)
                completionHandler(result)
        }
    }
    
    class func todoByAll(completionHandler: @escaping (Result<Todo>) -> Void) {
        Alamofire.request(Todo.endpointForTodos())
            .responseJSON { response in
                let result = Todo.todoFromResponse(response: response)
                completionHandler(result)
        }
    }
    
    func save(completionHandler: @escaping (Result<Todo>) -> Void) {
        let fields = self.toJSON()
        Alamofire.request(Todo.endpointForTodos(),
                          method: .post,
                          parameters: fields,
                          encoding: JSONEncoding.default,
                          headers: nil)
            .responseJSON { response in
                let result = Todo.todoFromResponse(response: response)
                completionHandler(result)
        }
    }
    
    private class func todoFromResponse(response: DataResponse<Any>) -> Result<Todo> {
        guard response.result.error == nil else {
            // got an error in getting the data, need to handle it
            print(response.result.error!)
            return .failure(response.result.error!)
        }
        
        // make sure we got JSON and it's a dictionary
        guard let json = response.result.value as? [String: Any] else {
            print("didn't get todo object as JSON from API")
            return .failure(BackendError.objectSerialization(reason:
                "Did not get JSON dictionary in response"))
        }
        
        // turn JSON in to Todo object
        guard let todo = Todo(json: json) else {
            return .failure(BackendError.objectSerialization(reason:
                "Could not create Todo object from JSON"))
        }
        return .success(todo)
    }
}

