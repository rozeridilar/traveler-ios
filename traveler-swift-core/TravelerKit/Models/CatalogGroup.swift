//
//  PurchasableGroup.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-10-25.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

/// Group of `CatalogItem`s
public struct CatalogGroup: Decodable {
    /// Determines if this is a featured group, featured groups are recommended to be highlighted to the user
    public let isFeatured: Bool
    /// Title
    public let title: String
    /// Secondary title
    public let subTitle: String?
    /// The type of item in the current group
    public let itemType: CatalogItemType
    /// The `CatalogItem`s in this group
    public let items: [CatalogItem]
    /// The `AnyQuery` for this group. Can be used to make additional searches and filtering related to this group.
    public let query: AnyQuery?

    enum CodingKeys: String, CodingKey {
        case isFeatured = "featured"
        case title = "title"
        case subTitle = "subTitle"
        case items = "items"
        case type = "type"
        case query = "groupSearch"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isFeatured = try container.decode(Bool.self, forKey: .isFeatured)
        self.title = try container.decode(String.self, forKey: .title)
        self.subTitle = try container.decode(String?.self, forKey: .subTitle)
        
        self.itemType = try container.decode(CatalogItemType.self, forKey: .type)

        switch itemType {
        case .item:
            let lossyItems = try container.decode(LossyDecodableArray<AnyItem>.self, forKey: .items)
            let items = lossyItems.payload.map({ $0.item })
            self.items = items
        case .query:
            let lossyItems = try container.decode(LossyDecodableArray<QueryItem>.self, forKey: .items)
            self.items = lossyItems.payload
        }
        self.query = try container.decode(AnyQuery?.self, forKey: .query)
    }
}

extension AnyItem {
    var item: CatalogItem {
        switch self.type {
        case .booking:
            return bookingItem!
        case .parking:
            return parkingItem!
        case .partnerOffering:
            return partnerOfferingItem!
        }
    }
}
