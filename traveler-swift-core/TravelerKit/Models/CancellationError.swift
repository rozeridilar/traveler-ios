//
//  CancellationError.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-05-27.
//  Copyright © 2019 GuestLogix Inc. All rights reserved.
//

import Foundation

public enum CancellationError: Error {
    case expiredQuote
    case notCancellable(traceId: String)
    case explanationRequired
}

extension CancellationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .expiredQuote:
            return NSLocalizedString("expiredQuoteError",value: "Quote has expired" ,comment: "Expired quote")
        case .notCancellable(let traceId):
            let description = NSLocalizedString("orderNotCancellableError", value: "Order not cancellable", comment: "Not Cancellable")
            return localizedDescription(description: description, withTraceId: traceId)
        case .explanationRequired:
            return NSLocalizedString("orderExplanationRequiredError", value: "A cancellation explanation is required", comment: "explanation required")
        }
    }
}
