//
//  CharacteristicVC.swift
//  HomekitSampleApp
//
//  Created by Nandan Prabhu on 15/07/20.
//  Copyright © 2020 Nandan Prabhu. All rights reserved.
//

import Foundation
import HomeKit
import UIKit

class CharacteristicVC: UITableViewController {
    var service: HMService?
    var characteristics: [HMCharacteristic] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        if let service = service {
            for ch in service.characteristics {
                characteristics.append(ch)
            }
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characteristics.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "characteristic", for: indexPath)
        cell.textLabel?.text = characteristics[indexPath.row].uniqueIdentifier.uuidString
//        cell.detailTextLabel?.text = characteristics[indexPath.row].uniqueIdentifier.uuidString
        return cell
    }
}
