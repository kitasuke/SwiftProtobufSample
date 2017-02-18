//
//  ViewController.swift
//  Client
//
//  Created by Yusuke Kita on 12/18/16.
//  Copyright © 2016 Yusuke Kita. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private var tagLabels: [UILabel]!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var introductionLabel: UILabel!
    
    let apiClient = APIClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        apiClient.talks(success: { [weak self] response in
            print(response)
            
            let talk = response.talks[0]
            guard let data = try? Data(contentsOf: URL(string: talk.speaker.photoURL)!),
                let image = UIImage(data: data) else {
                return
            }
                    
            DispatchQueue.main.async {
                self?.titleLabel.text = talk.title
                self?.descriptionLabel.text = talk.desc
                if let labels = self?.tagLabels {
                    for (index, label) in labels.enumerated() {
                        label.text = talk.tags[index]
                    }
                }
                self?.nameLabel.text = talk.speaker.name
                self?.imageView.image = image
                self?.introductionLabel.text = talk.speaker.introduction
            }
        }) { error in
            print(error)
        }
    }
    
    @IBAction private func likeButtonPressed() {
        let body = LikeRequest.with {
            $0.id = 1
        }
        
        apiClient.like(body: body, success: { response in
            print(response)
        }) { [weak self] error in
            print(error)
            
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: error.code.json, message: error.message, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(action)
                self?.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

