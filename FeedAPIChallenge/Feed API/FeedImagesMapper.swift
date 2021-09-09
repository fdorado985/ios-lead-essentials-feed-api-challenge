//
//  FeedImagesMapper.swift
//  FeedAPIChallenge
//
//  Created by Juan Francisco Dorado Torres on 04/09/21.
//  Copyright © 2021 Essential Developer Ltd. All rights reserved.
//

import Foundation

enum FeedImagesMapper {
	private struct Root: Decodable {
		let items: [Item]
	}

	private struct Item: Decodable {
		let id: UUID
		let description: String?
		let location: String?
		let url: URL

		var item: FeedImage {
			FeedImage(id: id, description: description, location: location, url: url)
		}

		private enum CodingKeys: String, CodingKey {
			case id = "image_id"
			case description = "image_desc"
			case location = "image_loc"
			case url = "image_url"
		}
	}

	static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedImage] {
		guard response.statusCode == 200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
			throw RemoteFeedLoader.Error.invalidData
		}

		return root.items.map(\.item)
	}
}
