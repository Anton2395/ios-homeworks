//
//  BruteForcer.swift
//  Navigation
//
//  Created by Toha Shilin on 6.10.25.
//
import Foundation

final class BruteForcer {
    private var cancelled = false
    private let workQueue = DispatchQueue(label: "com.example.bruteforce", qos: .userInitiated)
    
    func cancel() {
        workQueue.sync { cancelled = true }
    }
    
    func bruteForce(target: String,
                    charset: [Character],
                    progress: ((String) -> Void)? = nil,
                    completion: @escaping (String?) -> Void) {
        workQueue.async { [weak self] in
            guard let self = self else { return }
            self.cancelled = false
            let length = target.count
            guard length > 0 else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            let base = charset.count
            let total = Int(pow(Double(base), Double(length)))
            
            func stringFromIndex(_ index: Int) -> String {
                var n = index
                var chars = Array(repeating: charset[0], count: length)
                var i = length - 1
                while i >= 0 {
                    let digit = n % base
                    chars[i] = charset[digit]
                    n /= base
                    i -= 1
                }
                return String(chars)
            }
            
            for i in 0..<total {
                if self.cancelled {
                    DispatchQueue.main.async { completion(nil) }
                    return
                }
                let attempt = stringFromIndex(i)
                if i % 1000 == 0 {
                    DispatchQueue.main.async { progress?(attempt) }
                }
                if attempt == target {
                    DispatchQueue.main.async { completion(attempt) }
                    return
                }
            }
            DispatchQueue.main.async { completion(nil) }
        }
    }
}
