//
//  ImageRetriver.swift
//  AsyncImageCacher SwiftUI
//
//  Created by Dmitry Zasenko on 15.12.22.
//

import Foundation

struct ImageRetriver {
    
    func fetch(stringUrl: String) async throws -> Data {
        guard let url = URL(string: stringUrl) else {
            throw RetriverError.invalidUrl
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}

private extension ImageRetriver {
    enum RetriverError: Error {
        case invalidUrl
    }
}
