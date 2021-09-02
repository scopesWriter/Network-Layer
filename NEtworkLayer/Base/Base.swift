//
//  Base.swift
//  Banoon
//
//  Created by bishoy on 26/11/2020.
//

import Foundation
import Alamofire

class BaseAPI<T: TargetType> {
    
    func fetchData<M: Decodable>(target: T, responseClass: M.Type, completion:@escaping (Result<M?, NSError>) -> Void) {
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
        let params = buildParams(task: target.task)
        AF.request(target.baseURL + target.path, method: method, parameters: params.0, encoding: params.1, headers: headers,interceptor: CustomInterceptor()).responseJSON { (response) in
            print(response.request?.url as Any)
            guard let statusCode = response.response?.statusCode else {
                // ADD Custom Error
                let error = NSError(domain: "com.example.error", code: 0, userInfo: [NSLocalizedDescriptionKey:"invalid status"])
                completion(.failure(error))
                return
            }
            print("Status Code is |\(statusCode)|")
            if statusCode == 200 {
                // Successful request
                guard let jsonResponse = try? response.result.get() else {
                    // ADD Custom Error
                    let error = NSError(domain: "com.example.error", code: 0, userInfo: [NSLocalizedDescriptionKey:"can't parse"])
                    completion(.failure(error))
                    return
                }
                print(jsonResponse)
                guard let theJSONData = try? JSONSerialization.data(withJSONObject: jsonResponse, options: []) else {
                    // ADD Custom Error
                    let error = NSError(domain: "com.example.error", code: 0, userInfo: [NSLocalizedDescriptionKey:"can't serialize"])
                    completion(.failure(error))
                    return
                }
                guard let responseObj = try? JSONDecoder().decode(M.self, from: theJSONData) else {
                    // ADD Custom Error
                    let error = NSError(domain: "com.example.error", code: 0, userInfo: [NSLocalizedDescriptionKey:"can not decode"])
                    completion(.failure(error))
                    return
                }
                completion(.success(responseObj))
            }else if statusCode == 201{
                completion(.success(.none))
            }else {
                // ADD custom error base on status code 404 / 401 / 422
                let error = NSError(domain: "com.example.error", code: 404, userInfo: [NSLocalizedDescriptionKey:"The given data is invalid"])
                
                completion(.failure(error))
            }
        }
    }
    
    func fetchMultiPartData<M: Decodable>(target: T, images: [UIImage], responseClass: M.Type, completion: @escaping (Result<M?, NSError>) -> Void) {
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
        let params = buildParams(task: target.task)
        AF.upload(multipartFormData: { (multiPart) in
            
            for p in params.0 {
                multiPart.append("\(p.value)".data(using: String.Encoding.utf8)!, withName: p.key)
            }
            
            for image in images {
                guard let imageCompressed = image.jpegData(compressionQuality: 0.4) else{return}
                multiPart.append(imageCompressed, withName: "img", fileName: "file.jpg", mimeType: "image/jpg")
            }
        }, to: "\(target.baseURL + target.path)", method: method, headers: headers,interceptor: CustomInterceptor()).responseJSON { (response) in
            print(response.request?.url as Any)
            guard let statusCode = response.response?.statusCode else {
                // ADD Custom Error
                let error = NSError(domain: "com.example.error", code: 0, userInfo: [NSLocalizedDescriptionKey:"invalid status"])
                completion(.failure(error))
                return
            }
            print("Status Code is |\(statusCode)|")
            if statusCode == 200 {
                // Successful request
                guard let jsonResponse = try? response.result.get() else {
                    // ADD Custom Error
                    let error = NSError(domain: "com.example.error", code: 0, userInfo: [NSLocalizedDescriptionKey:"can't parse"])
                    completion(.failure(error))
                    return
                }
                print(jsonResponse)
                guard let theJSONData = try? JSONSerialization.data(withJSONObject: jsonResponse, options: []) else {
                    // ADD Custom Error
                    let error = NSError(domain: "com.example.error", code: 0, userInfo: [NSLocalizedDescriptionKey:"can't serialize"])
                    completion(.failure(error))
                    return
                }
                guard let responseObj = try? JSONDecoder().decode(M.self, from: theJSONData) else {
                    // ADD Custom Error
                    let error = NSError(domain: "com.example.error", code: 0, userInfo: [NSLocalizedDescriptionKey:"can not decode"])
                    completion(.failure(error))
                    return
                }
                completion(.success(responseObj))
            }else if statusCode == 201{
                completion(.success(.none))
            }else {
                // ADD custom error base on status code 404 / 401 / 422
                let error = NSError(domain: "com.example.error", code: 404, userInfo: [NSLocalizedDescriptionKey:"The given data is invalid"])
                
                completion(.failure(error))
            }
        }
    }
        
    private func buildParams(task: Task) -> ([String:Any], ParameterEncoding) {
        switch task {
        case .requestPlain:
            return ([:], URLEncoding.default)
        case .requestParameters(parameters: let parameters, encoding: let encoding):
            return (parameters, encoding)
        }
    }
    
    class func getAPIToken()->String?{
        let def = UserDefaults.standard
        return def.object(forKey: "UserToken") as? String
    }
    
    func decode(jwtToken jwt: String) -> [String: Any] {
        let segments = jwt.components(separatedBy: ".")
        return decodeJWTPart(segments[1]) ?? [:]
    }
    
    func base64UrlDecode(_ value: String) -> Data? {
        var base64 = value
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
        let requiredLength = 4 * ceil(length / 4.0)
        let paddingLength = requiredLength - length
        if paddingLength > 0 {
            let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
            base64 = base64 + padding
        }
        return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }
    
    func decodeJWTPart(_ value: String) -> [String: Any]? {
        guard let bodyData = base64UrlDecode(value),
              let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
            return nil
        }
        
        return payload
    }
}
