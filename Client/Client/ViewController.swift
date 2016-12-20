//
//  ViewController.swift
//  Client
//
//  Created by Yusuke Kita on 12/18/16.
//  Copyright © 2016 Yusuke Kita. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let apiClient = APIClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction private func getToken() {
        apiClient.getToken(success: { response in
            print(response)
        }) { error in
            print(error)
        }
    }
    
    @IBAction private func postToken() {
        var token = Token()
        token.accessToken = "old token"
        
        var body = PostTokenRequest()
        body.accessToken = token.accessToken
        
        apiClient.postToken(body: body, success: { response in
            print(response)
        }) { error in
            print(error)
        }
    }
    
    @IBAction private func getError() {
        apiClient.getError(success: { response in
            print(response)
        }) { error in
            print(error)
        }
    }
}

