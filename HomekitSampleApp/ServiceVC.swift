//
//  ServiceViewController.swift
//  HomekitSampleApp
//
//  Created by Nandan Prabhu on 15/07/20.
//  Copyright © 2020 Nandan Prabhu. All rights reserved.
//

import Foundation
import UIKit
import HomeKit

class ServiceVC: UITableViewController {
    var accessory: HMAccessory?
    var services: [HMService] = []
    var service: HMService?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let accessory = accessory {
            for service in accessory.services {
                services.append(service)
            }
            tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "service", for: indexPath)
        cell.textLabel?.text = services[indexPath.row].uniqueIdentifier.uuidString
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        service = services[indexPath.row]
        performSegue(withIdentifier: "characteristic", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CharacteristicVC {
            vc.service = service
        }
    }
}
