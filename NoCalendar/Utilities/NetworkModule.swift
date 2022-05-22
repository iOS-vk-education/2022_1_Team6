//
//  NetworkModule.swift
//  NoCalendar
//
//  Created by Александр Клонов on 17.04.2022.
//

import Foundation

protocol NetworkDelegate {
    func authorise(login: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
    func register(login: String, email: String, password: String, name: String?, surname: String?,
                  completion: @escaping (Result<User, Error>) -> Void)
    func getAllEvents(completion: @escaping (Result<[Event], Error>) -> Void)
    func postEvent(event: EventPost, completion: @escaping (Result<EventAnswer, Error>) -> Void)
    func updateEvent(event: EventPostEdit, completion: @escaping (Result<EventAnswer, Error>) -> Void)
    func deleteEvent(eventId: String, completion: @escaping (Result<serverAnswer, Error>) -> Void)
    func getEvent(id: String, completion: @escaping (Result<Event, Error>) -> Void)
    func getInvites(completion: @escaping (Result<[String], Error>) -> Void)
    func acceptInvite(id: String, completion: @escaping (Result<String, Error>) -> Void)
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
                    print(response, "here")
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
    
    func register(login: String, email: String, password: String, name: String? = nil, surname: String? = nil,
                  completion: @escaping (Result<User, Error>) -> Void) {
        let json: [String: String]
        if let _name = name, let _surname = surname {
            json = ["login": login, "email": email, "password": password, "name": _name, "surname": _surname]
        } else {
            json = ["login": login, "email": email, "password": password]
        }
        
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
                if response.statusCode == self.codes.badRequest || response.statusCode == self.codes.alreadyRegister{ // если 400 сразу отправляем ошибку
                    let errorTemp = NSError(domain:"", code:response.statusCode, userInfo:nil)
                    completion(.failure(errorTemp))
                } else {
                    self.setToken(response: response)
                    let tmpUser = User(login: login, email: email, name: name, surname: surname, password: password)
                    completion(.success(tmpUser))
                }
            }
        }.resume()
    }
    
    func getEvent(id: String, completion: @escaping (Result<Event, Error>) -> Void) {
        let url = URL(string: endpoint + "event/" + id)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(self.token, forHTTPHeaderField: "authorize")
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
                        let evResponse = try decoder.decode(serverEventAnswer.self, from: data)
                        completion(.success(evResponse.event))
                    } catch let error {
                        completion(.failure(error))
                    }
                }
            }
        }.resume()
    }
    
    func getInvites(completion: @escaping (Result<[String], Error>) -> Void) {
        let url = URL(string: endpoint + "event/invites")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(self.token, forHTTPHeaderField: "authorize")
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
                        let evResponse = try decoder.decode(serverInviteAnswer.self, from: data)
                        completion(.success(evResponse.invites))
                    } catch let error {
                        completion(.failure(error))
                    }
                }
            }
        }.resume()
    }
    
    func acceptInvite(id: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: endpoint + "event/accept/" + id)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(self.token, forHTTPHeaderField: "authorize")
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
                        let evResponse = try decoder.decode(serverAcceptAnswer.self, from: data)
                        completion(.success(evResponse.event_id ?? ""))
                    } catch let error {
                        completion(.failure(error))
                    }
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
                        let evResponse = try decoder.decode(serverEventsResponse.self, from: data)
                        completion(.success(evResponse.events))
                    } catch let error {
                        completion(.failure(error))
                    }
                }
            }
        }.resume()
    }
    
        
    func postEvent(event: EventPost, completion: @escaping (Result<EventAnswer, Error>) -> Void) {
        let jsonData = try? JSONEncoder().encode(event)
        let url = URL(string: endpoint + "event")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(self.token, forHTTPHeaderField: "authorize")
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
                } else {
                    let decoder = JSONDecoder()
                    do {
                        let evResponse = try decoder.decode(EventAnswer.self, from: data)
                        completion(.success(evResponse))
                    } catch let error {
                        completion(.failure(error))
                    }
                }
            }
        }.resume()
    }
    
    func updateEvent(event: EventPostEdit, completion: @escaping (Result<EventAnswer, Error>) -> Void) {
        let jsonData = try? JSONEncoder().encode(event)
        let url = URL(string: endpoint + "event/edit")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(self.token, forHTTPHeaderField: "authorize")
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
                } else {
                    let decoder = JSONDecoder()
                    do {
                        let evResponse = try decoder.decode(EventAnswer.self, from: data)
                        completion(.success(evResponse))
                    } catch let error {
                        completion(.failure(error))
                    }
                }
            }
        }.resume()
    }
    
    func deleteEvent(eventId: String, completion: @escaping (Result<serverAnswer, Error>) -> Void) {
        let url = URL(string: endpoint + "event/remove/" + eventId)!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue(self.token, forHTTPHeaderField: "authorize")
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
                if response.statusCode == self.codes.badRequest || response.statusCode == self.codes.noRights { // если 400 или 403 сразу отправляем ошибку
                    let errorTemp = NSError(domain:"", code:response.statusCode, userInfo:nil)
                    completion(.failure(errorTemp))
                } else {
                    let decoder = JSONDecoder()
                    do {
                        let evResponse = try decoder.decode(serverAnswer.self, from: data)
                        completion(.success(evResponse))
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
