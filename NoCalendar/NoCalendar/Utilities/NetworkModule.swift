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
    func getAllEvents(completion: @escaping (Result<[Event], Error>) -> Void)
}

enum NetworkError: Error {
    case invalidUrl
    case emptyData
}


final class NetworkModule: NetworkDelegate {
    static let shared: NetworkDelegate = NetworkModule()
    private var endpoint = "http://89.19.190.83/api/"
    private let codes = statusCodes()
    private var token: String
    
    private init() {
        self.token = DatabaseModule.shared.getToken()
    }
    
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
                } else {
                    self.setToken(response: response)
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
            guard data != nil else {
                completion(.failure(NetworkError.emptyData))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode == self.codes.badRequest { // если 400 сразу отправляем ошибку
                    let errorTemp = NSError(domain:"", code:response.statusCode, userInfo:nil)
                    completion(.failure(errorTemp))
                } else {
                    self.setToken(response: response)
                    let tmpUser = User(login: login, email: email, name: nil, surname: nil, password: password)
                    completion(.success(tmpUser))
                }
            }
        }.resume()
    }
    
    func getAllEvents(completion: @escaping (Result<[Event], Error>) -> Void) {
        let url = URL(string: endpoint + "event/all")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(self.token, forHTTPHeaderField: "authorize")
        
        // insert json data to the request

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
                    response.statusCode == self.codes.unauthorized { // если 401 или 404 сразу отправляем ошибку
                    let errorTemp = NSError(domain:"", code:response.statusCode, userInfo:nil)
                    completion(.failure(errorTemp))
                } else {
                    let decoder = JSONDecoder()
                    do {
                        print((String(data: data, encoding: String.Encoding.utf8) ?? ""))
                        let evResponse = try decoder.decode(serverEventsResponse.self, from: data)
                        completion(.success(evResponse.events))
                    } catch let error {
                        completion(.failure(error))
                    }
                }
            }
        }.resume()
    }
    
    private func setToken(response: HTTPURLResponse) {
        self.token = response.allHeaderFields["Authorize"] as! String
        if token != "" {
            UserDefaults.standard.setValue(self.token, forKey: networkKeyString)
        }
    }
}
