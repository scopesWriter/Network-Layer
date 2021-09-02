//
//  Constants.swift
//  Banoon
//
//  Created by bishoy on 26/11/2020.
//

import Foundation

struct Constants {
    
    static let BaseURL: String = "http://phpstack-597257-1931215.cloudwaysapps.com/public/api/"
    
    enum Authentication: String {
        case login = "login"
        case register = "register"
    }
    
}

enum HTTPHeadersField: String {
    
    case authentication = "Authorization"
    case acceptType = "Accept"
    case contentType = "Content_Type"
    case acceptEncoding = "Accept_Encoding"
    
}

enum ContentType: String {
    
    case json = "application/x-www-form-urlencoded; charset=utf-8"
    case accept = "application/josn"
    case acceptEncoding = "gzip;q=1.0, compress;q=0.5"
    
}
