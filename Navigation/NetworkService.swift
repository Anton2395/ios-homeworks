//
//  NetworkService.swift
//  Navigation
//
//  Created by Toha Shilin on 3.11.25.
//
import Foundation

enum AppConfiguration: String {
    case people = "https://swapi.dev/api/people/8"
    case starships = "https://swapi.dev/api/starships/3"
    case planets = "https://swapi.dev/api/planets/5"
    
    static func getRandom() -> AppConfiguration {
        let configurations: [AppConfiguration] = [
            .people,
            .starships,
            .planets
        ]
        return configurations.randomElement()!
    }
}

struct NetworkService {
    
    static func request(for configuration: AppConfiguration) {
        let session = URLSession.shared
        let url = URL(string: configuration.rawValue)!
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                print("Error: \(error?.localizedDescription ?? "")")
                print("Debug: \(error!)")
                /*
                 Error: The Internet connection appears to be offline.
                 Debug: Error Domain=NSURLErrorDomain Code=-1009 "The Internet connection appears to be offline." UserInfo={_kCFStreamErrorCodeKey=50, NSUnderlyingError=0x600000c11a70 {Error Domain=kCFErrorDomainCFNetwork Code=-1009 "(null)" UserInfo={_kCFStreamErrorDomainKey=1, _kCFStreamErrorCodeKey=50, _NSURLErrorNWResolutionReportKey=Resolved 0 endpoints in 26ms using unknown from cache, _NSURLErrorNWPathKey=unsatisfied (No network route)}}, _NSURLErrorFailingURLSessionTaskErrorKey=LocalDataTask <C3389B14-1F69-4810-8556-5907815A54F4>.<1>, _NSURLErrorRelatedURLSessionTaskErrorKey=(
                     "LocalDataTask <C3389B14-1F69-4810-8556-5907815A54F4>.<1>"
                 ), NSLocalizedDescription=The Internet connection appears to be offline., NSErrorFailingURLStringKey=https://swapi.dev/api/planets/5, NSErrorFailingURLKey=https://swapi.dev/api/planets/5, _kCFStreamErrorDomainKey=1}
                */
                return
            }
            if let urlResponse = response as? HTTPURLResponse {
                print(urlResponse.statusCode)
                print(urlResponse.allHeaderFields)
                if urlResponse.statusCode != 200 {
                    return
                }
            }
            
            if let data = data, let string = String(data: data, encoding: .utf8) {
                print("📦 Ответ сервера:\n\(string)")
            }
            
        }
        task.resume()
    }
}
