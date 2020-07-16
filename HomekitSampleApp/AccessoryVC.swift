//
//  AccessoryViewController.swift
//  HomekitSampleApp
//
//  Created by Nandan Prabhu on 01/04/20.
//  Copyright © 2020 Nandan Prabhu. All rights reserved.
//

import Foundation
import HomeKit

class AccessoryViewController: UITableViewController {
    var selectedHome: HMHome?
    var accessory: HMAccessory?
    var accessoryBrowser = HMAccessoryBrowser()
    var discoveredAccessories: [HMAccessory] = []
    var addedAccessories: [HMAccessory] = []
    var services: [HMService] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.accessoryBrowser.delegate = self
        self.discoveredAccessories.removeAll()
        self.accessoryBrowser.startSearchingForNewAccessories()
        if let selectedHome = selectedHome {
            addedAccessories = selectedHome.accessories
        }
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return addedAccessories.count
        }
        return discoveredAccessories.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Added Accessories"
        }
        return "Discovered Accessories"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accessory", for: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = addedAccessories[indexPath.row].name
        } else {
            cell.textLabel?.text = discoveredAccessories[indexPath.row].name
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
            self.selectedHome?.removeAccessory(self.addedAccessories[indexPath.row], completionHandler: { error in
                if error == nil {
                    self.addedAccessories.remove(at: indexPath.row)
                    self.tableView.reloadData()
                }
            })
        }
        return [action]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            accessory = addedAccessories[indexPath.row]
            self.performSegue(withIdentifier: "service", sender: nil)
        } else {
            discoveredAccessories[indexPath.row].identify { error in
                if error == nil {
                    self.selectedHome?.addAccessory(self.discoveredAccessories[indexPath.row], completionHandler: { error in
                        if error == nil {
                            self.addedAccessories.append(self.discoveredAccessories.remove(at: indexPath.row))
                            self.tableView.reloadData()
                        }
                    })
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ServiceVC {
            vc.accessory = accessory
        }
    }
}

extension AccessoryViewController: HMAccessoryDelegate {

}

extension AccessoryViewController: HMAccessoryBrowserDelegate {
    func accessoryBrowser(_ browser: HMAccessoryBrowser, didFindNewAccessory accessory: HMAccessory) {
        discoveredAccessories.append(accessory)
        tableView.reloadData()
    }
}

