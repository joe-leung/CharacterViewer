//
//  CharacterDetailViewController.swift
//  GenericViewer
//
//  Created by Joe Leung on 5/8/21.
//

import UIKit

class CharacterDetailViewController: UIViewController {
   
    var characterData: Dictionary<String, Any> = [:]
    var characterName: String = "" {
        didSet {
            refreshUI()
        }
    }

    @IBOutlet weak var characterTitle: UILabel!
    @IBOutlet weak var characterDescription: UILabel!
    @IBOutlet weak var characterImage: UIImageView!
    
    private func refreshUI() {
        if !self.characterData.isEmpty {
            loadViewIfNeeded()
            view.backgroundColor = UIColor.white
            characterImage.subviews.forEach {
                $0.removeFromSuperview()
            }
            characterTitle.text = characterName
            let icon = characterData["Icon"] as! Dictionary<String, String>
            let iconURL = icon["URL"]
            characterDescription.text = characterData["Text"] as! String
            let baseURL = Bundle.main.object(forInfoDictionaryKey: "ViewerAppBaseURL") as! String
            let url = URL(string: baseURL + iconURL!)
            let data = try? Data(contentsOf: url!)
            if let imageData = data, iconURL != "" {
                let image = UIImage(data: imageData)
                let imageView = UIImageView(image: image!)
                imageView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
                self.characterImage.addSubview(imageView)
            } else {
                let image = UIImage(named: "NotFound")
                let imageView = UIImageView(image: image!)
                imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
                self.characterImage.addSubview(imageView)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CharacterData = \(self.characterData)")
        if self.characterName.isEmpty {
            self.view.backgroundColor = UIColor.black
        }
        refreshUI()
    }
}

extension CharacterDetailViewController: CharacterSelectionDelegate {
    func characterSelected(characterName: String, characterDetail: Dictionary<String, Any>) {
        self.characterData = characterDetail
        self.characterName = characterName
    }
}
