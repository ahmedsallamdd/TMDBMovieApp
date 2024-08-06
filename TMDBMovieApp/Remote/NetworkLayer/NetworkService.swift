//
//  NetworkService.swift
//  GenericNetworkLayer
//
//  Created by Ahmed Sallam on 30/07/2024.
//

import Foundation

public protocol NetworkServiceProtocol {
    func requestData<T: Codable>(request: Requestable,
                                 expectedModelType: T.Type,
                                 completion: @escaping (Result<T, NetworkError>) -> Void)
}

public class NetworkService: NetworkServiceProtocol {
    private init() {}
    
    static let shared: NetworkService = NetworkService()
    private let logger: NetworkErrorLogger = NetworkErrorLogger()
    
    public func requestData<T>(request: Requestable,
                               expectedModelType: T.Type,
                               completion: @escaping (Result<T, NetworkError>) -> Void) where T : Codable {
        
        guard let urlRequest = request.urlRequest() else {
            completion(.failure(.invalidURL))
            return
        }
        
        self.logger.log(request: request)
        let timeRequestIsFired = Date()
        URLSession.shared.dataTask(with: urlRequest,
                                   completionHandler: {[weak self] data, response, error in
            
            // Make sure the response is valid
            guard let data = data else {
                completion(.failure(.invalidResponseData))
                return
            }
            
            if request.isPrintable {
                self?.logger.log(for: request, responseData: data, response: response, at: timeRequestIsFired)
            }
            
            if let requestError = error {
                self?.logger.log(error: requestError)
                if let response = response as? HTTPURLResponse, response.statusCode == 401 {
                    completion(.failure(.unauthorized))
                    
                } else {
                    completion(.failure(.genericError(description: requestError.localizedDescription)))
                }
                
            } else {
                
                if let parsedData = self?.parseData(from: data, to: expectedModelType) {
                    completion(.success(parsedData))
                } else {
                    completion(.failure(.parsingError))
                } 
                
            }
        }).resume()
    }
    
    fileprivate func parseData<T: Codable>(from data: Data,
                                           to expectedModelType: T.Type) -> T? {
        do {
            
            let parsingResult = try JSONDecoder().decode(expectedModelType,
                                                         from: data)
            
            return parsingResult
            
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
}



public enum HTTPMethodType: String {
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}



public final class NetworkErrorLogger {
    public init() { }

    public func log(request: Requestable) {
        print("-------------")
        print("FullURL: \(request.fullURL?.absoluteString ?? "N/A")")
        print("Headers: \(request.headerParameters)")
        print("Method: \(request.method)")
        
        if request.queryParameters.count > 0 {
            print("Query params: \(request.queryParameters)")
        }
        
        if request.bodyParameters.count > 0 {
            print("Body: \(request.bodyParameters)")
            
        }
        print("-------------")
    }

    public func log(for request: Requestable, responseData data: Data?, response: URLResponse?, at timeWhenRequestWasFired: Date? = nil) {
        guard let data = data else { return }
        if let timeWhenRequestWasFired {
            let timeElapsedSinceRequestFired = Date().timeIntervalSince(timeWhenRequestWasFired)
            print("ElapsedTime: \(String(format: "%.2f", timeElapsedSinceRequestFired)) sec")
        }
        
        if let dataDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            print("\nResponseOf \(request.endpointURL) :-\n\(String(describing: dataDict))")
        }
    }

    public func log(error: Error) {
        print("\(error)")
    }
}
