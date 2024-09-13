//
//  ImageLoader.swift
//  
//
//  Created by Javier Manzo on 12/09/2024.
//

import UIKit

public actor ImageLoader {
    public static let shared = ImageLoader()

    private let cache: URLCache

    private init() {
        let memoryCapacity = 500 * 1024 * 1024
        let diskCapacity = 500 * 1024 * 1024
        cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "imageCache")
    }

    public func loadImage(from url: URL) async throws -> UIImage? {
        let request = URLRequest(url: url)

        if let cachedResponse = cache.cachedResponse(for: request),
           let cachedImage = UIImage(data: cachedResponse.data) {
            return cachedImage
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
              let image = UIImage(data: data) else {
            return nil
        }

        let cachedResponse = CachedURLResponse(response: response, data: data)
        cache.storeCachedResponse(cachedResponse, for: request)

        return image
    }
}
