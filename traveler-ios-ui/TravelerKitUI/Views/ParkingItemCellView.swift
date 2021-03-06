//
//  ParkingItemCellView.swift
//  TravelerKitUI
//
//  Created by Ata Namvari on 2019-10-15.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation

public protocol ParkingItemCellDelegate: class {
    func parkingItemCellDidSelect(_ cell: ParkingItemCellView)
}

open class ParkingItemCellView: UICollectionViewCell {
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!

    public weak var delegate: ParkingItemCellDelegate?

    @IBAction func didView(_ sender: Any) {
        delegate?.parkingItemCellDidSelect(self)
    }
}
