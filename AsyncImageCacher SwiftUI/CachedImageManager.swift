//
//  CachedImageManager.swift
//  AsyncImageCacher SwiftUI
//
//  Created by Dmitry Zasenko on 15.12.22.
//

import Foundation

final class CachedImageManager: ObservableObject {
    
    @Published private(set) var currentState: CurrentState?
    private let imageRetriver = ImageRetriver()
    
    @MainActor
    func load(_ stringUrl: String, cache: ImageCache = .shared) async {
        self.currentState = .loading
        
        if let imageData = cache.object(forKey: stringUrl as NSString) {
            self.currentState = .succes(data: imageData)
#if DEBUG
            print("Fetching image from the cache: \(stringUrl)")
#endif
            return
        }
        
        do {
            let data = try await imageRetriver.fetch(stringUrl: stringUrl)
            self.currentState = .succes(data: data)
            cache.set(object: data as NSData, forKey: stringUrl as NSString)
#if DEBUG
            print("Caching image: \(stringUrl)")
#endif
        } catch {
            self.currentState = .failed(error: error)
        }
    }
}

extension CachedImageManager {
    enum CurrentState{
        case loading
        case failed(error: Error)
        case succes(data: Data)
    }
}

extension CachedImageManager.CurrentState: Equatable {
    static func == (lhs: CachedImageManager.CurrentState, rhs: CachedImageManager.CurrentState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (let .failed(lhsError), let .failed(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (let .succes(lhsData), let .succes(rhsData)):
            return lhsData == rhsData
        default:
            return false
        }
    }
}
