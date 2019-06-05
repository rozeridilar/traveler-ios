//
//  OrderResultViewController.swift
//  Traveler
//
//  Created by Ata Namvari on 2019-05-06.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

let orderCellIdentifier = "orderCellIdentifier"
let loadingCellIdentifier = "loadingCellIdentifier"

open class OrderResultViewController: UITableViewController {
    public var orderResult: OrderResult?

    private var _volatileResult: OrderResult?
    private var selectedOrder: Order?
    private var pagesLoading = Set<Int>()

    override open func viewDidLoad() {
        super.viewDidLoad()

        _volatileResult = orderResult
    }

    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as OrderDetailViewController):
            vc.order = selectedOrder
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }

    // MARK: UITableViewDataSource

    override open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderResult?.total ?? 0
    }

    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let order = orderResult!.orders[indexPath.row]

        switch order {
        case .none:
            let cell = tableView.dequeueReusableCell(withIdentifier: loadingCellIdentifier, for: indexPath)
            cell.contentView.subviews.forEach({ $0.startShimmering() })
            return cell
        case .some(let order):
            let cell = tableView.dequeueReusableCell(withIdentifier: orderCellIdentifier, for: indexPath) as! OrderCell
            cell.numberLabel.text = order.referenceNumber
            cell.dateLabel.text = DateFormatter.dateOnlyFormatter.string(from: order.createdDate)
            cell.productsLabel.text = order.products.map({ $0.title }).joined(separator: "\n")
            cell.priceLabel.text = order.total.localizedDescription
            cell.statusLabel.text = order.status.rawValue
            return cell
        }
    }

    // MARK: UITableViewDelegate

    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedOrder = orderResult!.orders[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "orderDetailSegue", sender: nil)
    }
}

extension OrderResultViewController: UITableViewDataSourcePrefetching {
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let orderResult = orderResult else {
            return
        }
        
        let indexesRequested = indexPaths.map({ $0.row }).filter({ orderResult.orders[$0] == nil })
        let pages = Set(indexesRequested.map({ $0 / OrderQuery.pageSize }))
        let pagesNotRequested = pages.filter({ !orderResult.hasPage($0, pageSize: OrderQuery.pageSize) })
        for page in pagesNotRequested where !pagesLoading.contains(page) {
            pagesLoading.insert(page)

            let query = OrderQuery(page: page, from: orderResult.fromDate, to: orderResult.toDate)
            Traveler.fetchOrders(query, identifier: page, delegate: self)
        }
    }
}

extension OrderResultViewController: OrderFetchDelegate {
    public func orderFetchDidSucceedWith(_ result: OrderResult, identifier: AnyHashable?) {
        self.orderResult = _volatileResult

        _ = (identifier as? Int).flatMap({ pagesLoading.remove($0) })

        tableView.indexPathsForVisibleRows.flatMap({ tableView.reloadRows(at: $0, with: .none) })
    }

    public func orderFetchDidFailWith(_ error: Error, identifier: AnyHashable?) {
        _ = (identifier as? Int).flatMap({ pagesLoading.remove($0) })

        Log("Error fetching", data: error, level: .error)
    }

    public func previousResult() -> OrderResult? {
        return _volatileResult
    }

    public func orderFetchDidReceive(_ result: OrderResult, identifier: AnyHashable?) {
        _volatileResult = result
    }
}

extension OrderQuery {
    static let pageSize = 10

    init(page: Int, from: Date?, to: Date) {
        self.init(offset: page * OrderQuery.pageSize, limit: OrderQuery.pageSize, from: from, to: to)
    }
}

extension OrderResult {
    func hasPage(_ page: Int, pageSize: Int) -> Bool {
        for i in (page * pageSize)..<((page + 1) * pageSize) where orders[i] == nil {
            return false
        }

        return true
    }
}