//
//  URLSessionProtocol.swift
//  ChatCompanion
//
//  Created by Nazik on 6.04.2024.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}
