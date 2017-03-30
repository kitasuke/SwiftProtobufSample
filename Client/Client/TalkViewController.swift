//
//  TalkViewController.swift
//  Client
//
//  Created by Yusuke Kita on 2/20/17.
//  Copyright © 2017 Yusuke Kita. All rights reserved.
//

import UIKit

class TalkViewController: UIViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private var tagLabels: [UILabel]!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var introductionLabel: UILabel!
    
    var contentType: APIClient.ContentType!
    var apiClient: APIClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        apiClient = APIClient(contentType: contentType)
        
        updateViews()
    }
    
    private func updateViews() {
        
        // fetch talk information from server
        apiClient.fetchTalks(success: { [weak self] response in
            print(response)
            
            // show talk information
            let talk = response.talks[0]
            self?.titleLabel.text = talk.title
            self?.descriptionLabel.text = talk.desc
            if let labels = self?.tagLabels {
                for (index, label) in labels.enumerated() {
                    label.text = talk.tags[index]
                }
            }
            self?.nameLabel.text = talk.speaker.name
            self?.introductionLabel.text = talk.speaker.introduction
            
            DispatchQueue.global().async {
                guard let data = try? Data(contentsOf: URL(string: talk.speaker.photoURL)!),
                    let image = UIImage(data: data) else {
                        return
                }
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            }
        }) { [weak self] error in
            // it's required to run server app to get response
            let alertController = UIAlertController(title: "Network error", message: "Make sure that your server app is running. See README for more details", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { _ in
                let _ = self?.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(action)
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction private func likeButtonPressed() {
        let body = LikeRequest.with {
            $0.id = 1
        }
        
        // this API always returns network error
        apiClient.like(body: body, success: { response in
            print(response)
        }) { [weak self] error in
            print(error)
            
            let title: String
            let message: String
            switch error.code {
            case .badRequest:
                title = "\(error.code)"
                message = error.message
            default:
                title = "Error"
                message = "Unexpected error occured"
            }
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(action)
            self?.present(alertController, animated: true, completion: nil)
        }
    }
}
