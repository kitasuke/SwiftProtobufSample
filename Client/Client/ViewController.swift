//
//  ViewController.swift
//  Client
//
//  Created by Yusuke Kita on 12/18/16.
//  Copyright © 2016 Yusuke Kita. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
            return UITableViewCell()
        }
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "protobuf"
        } else {
            cell.textLabel?.text = "JSON"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: String(describing: TalkViewController.self)) as? TalkViewController else {
            return
        }
        
        if indexPath.row == 0 {
            viewController.contentType = .protobuf
        } else {
            viewController.contentType = .json
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
}

