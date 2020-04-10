//
//  ViewController.swift
//  HomekitSampleApp
//
//  Created by Nandan Prabhu on 08/01/20.
//  Copyright © 2020 Nandan Prabhu. All rights reserved.
//

import UIKit
import HomeKit

class ViewController: UITableViewController {

    var homeManager : HMHomeManager = HMHomeManager()
    var homes: [HMHome] = []
    var selectedHome: HMHome?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeManager = HMHomeManager()
        self.homeManager.delegate = self
        tableView.reloadData()
    }

    @IBAction func addHomeButton(_ sender: Any) {
        newHome()
    }

    @objc func newHome() {
        showInputDialog { homeName in

            self.homeManager.addHome(withName: homeName) { [weak self] home, error in
                guard let self = self else {
                    return
                }
                if let error = error {
                    print("Failed to add home: \(error.localizedDescription)")
                } else {
                    if let newHome = home {
                        self.homes.append(newHome)
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    func showInputDialog(_ handler: @escaping ((String)-> Void)) {
        let alertController = UIAlertController(title: "Create new home", message: "Enter name of new home", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Create", style: .default) { (_) in
            guard let homeName =  alertController.textFields?[0].text else {
                return
            }
            handler(homeName)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addTextField { (textField) in
            textField.placeholder = "Add New Home"
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    func addHomes(_ homes: [HMHome]) {
        self.homes.removeAll()
        for home in homes {
            self.homes.append(home)
        }
        tableView?.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        cell.textLabel?.text = homes[indexPath.row].name
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedHome = homes[indexPath.row]
        self.performSegue(withIdentifier: "accessory", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? AccessoryViewController {
            viewController.selectedHome = self.selectedHome
        }
    }
}

extension ViewController: HMHomeManagerDelegate {
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        self.addHomes(manager.homes)
    }
}
