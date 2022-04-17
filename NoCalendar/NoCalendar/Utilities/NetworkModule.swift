//
//  NetworkModule.swift
//  NoCalendar
//
//  Created by Александр Клонов on 17.04.2022.
//

import Foundation

protocol NetworkDelegate {
    func authorise(login: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
    func register(login: String, email:String, password: String, completion: @escaping (Result<User, Error>) -> Void)
}

enum NetworkError: Error {
    case invalidUrl
    case emptyData
}


final class NetworkModule: NetworkDelegate {
    private init() {}
    static let shared: NetworkDelegate = NetworkModule()
    private var endpoint = "http://89.19.190.83/api/"
    private let codes = statusCodes()
    private var token = ""
    
    func authorise(login: String, password: String,
                   completion: @escaping (Result<User, Error>) -> Void) {
        let json: [String: Any] = ["login": login, "password": password]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: endpoint + "auth")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.emptyData))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode == self.codes.notFound ||
                    response.statusCode == self.codes.badRequest { // если 400 или 404 сразу отправляем ошибку
                    let errorTemp = NSError(domain:"", code:response.statusCode, userInfo:nil)
                    completion(.failure(errorTemp))
                } else {  // иначе кастим юзера
                    self.token = response.allHeaderFields["token"] as? String ?? ""
                    let decoder = JSONDecoder()
                    do {
                        let user = try decoder.decode(User.self, from: data)
                        completion(.success(user))
                    } catch let error {
                        completion(.failure(error))
                    }
                }
            }
        }.resume()
    }
    
    func register(login: String, email: String, password: String,
                  completion: @escaping (Result<User, Error>) -> Void) {
        let json: [String: Any] = ["login": login, "email": email, "password": password]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: endpoint + "register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.emptyData))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode == self.codes.badRequest { // если 400 сразу отправляем ошибку
                    let errorTemp = NSError(domain:"", code:response.statusCode, userInfo:nil)
                    completion(.failure(errorTemp))
                } else {  // иначе кастим юзера
                    self.token = response.allHeaderFields["token"] as? String ?? ""
                    let tmpUser = User(name: nil, surname: nil, login: login, password: password, email: email)
                    completion(.success(tmpUser))
                }
            }
        }.resume()
    }
}
