//
//  Client.swift
//  tmogaming
//
//  Created by Shishir Ahmed on 1/7/20.
//  Copyright © 2020 Shishir Ahmed. All rights reserved.
//

import Foundation

class Client {
    
    static let apiKey = "ZB43UN5agpmsh889A2qX4sOnrCwmp1mAjjpjsnkpVZmvtN15tl"
    
    struct Auth {
        static var accountId = 0
        static var requestToken = ""
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let base = "https://imdb8.p.rapidapi.com/"
        
        case getMovielist
        case search(String)
        case posterImage(String)
        
        var stringValue: String {
            switch self {
            case .getMovielist: return Endpoints.base + "/account/\(Auth.accountId)/watchlist/movies"
            case .search(let query):
                return Endpoints.base + "title/auto-complete?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" )"
            case .posterImage(let posterPath):
                return posterPath
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        
        var request = URLRequest(url: url)
        request.setValue("imdb8.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
        request.setValue("ZB43UN5agpmsh889A2qX4sOnrCwmp1mAjjpjsnkpVZmvtN15tl", forHTTPHeaderField: "x-rapidapi-key" )
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
        
        return task
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }

    
    class func newSearch(query: String, completion: @escaping ([D], Error?) -> Void) {
        
        _ = taskForGETRequest(url: Endpoints.search(query).url, responseType: Movie.self) { response, error in
            if let response = response {
                completion(response.d, nil)
            } else {
                completion([], error)
            }
        }

    }
    
    class func downloadPosterImage(path: String, completion: @escaping (Data?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.posterImage(path).url) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
        task.resume()
    }
    
}
