//
//  ViewController.swift
//  SwiftBokete
//
//  Created by 伊藤和也 on 2020/06/10.
//  Copyright © 2020 kazuya ito. All rights reserved.
//

import UIKit
import Photos
import Keys
import Alamofire
import SwiftyJSON
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet weak var odaiImageView: UIImageView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var searchTextField: UITextField!
    
    let requestsURL = "https://pixabay.com/api"
    let APIKey = SwiftBoketeKeys()
    var indicator = UIActivityIndicatorView()
    
    var count: Int = 0
    
//    static let decorder: JSONDecoder = {
//      let jsonDecoder = JSONDecoder()
//      jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
//      return jsonDecoder
//    }()
    
    struct ResponseImageUrlString: Codable {
        let imageUrlString: String?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentTextView.layer.cornerRadius = 20.0
        
        // status待ちするクロージャ
        PHPhotoLibrary.requestAuthorization { (status) in
        
            switch(status){
                case.authorized: break
                case.denied: break
                case.notDetermined: break
                case.restricted: break
                
            @unknown default:
                print(status)
            }
            
        }
        
        DispatchQueue.global().async {
                
            self.getImage("funny")
            
            DispatchQueue.main.async {
                
                self.indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                self.indicator.center = self.view.center
                self.indicator.hidesWhenStopped = true
                self.indicator.style = .large
                self.view.addSubview(self.indicator)
                self.indicator.startAnimating()
                
            }
        }
        
    }
    
    
    func getImage(_ keyword: String){
        
        let url = "\(requestsURL)/?key=\(APIKey.aPIToken)&q=\(keyword)"
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { (response) in
            
            switch response.result {
                
                case .success:
                    
                    // loading End
                    self.indicator.stopAnimating()
                    
                    let json: JSON = JSON(response.data as Any)
                    var imageString = json["hits"][self.count]["webformatURL"].string
                    
                    if imageString == nil {
                        
                        imageString = json["hits"][0]["webformatURL"].string
                        
                    }
                
                    self.odaiImageView.sd_setImage(with: URL(string: imageString!), completed: nil)
                
                    
                    //debug
                    print (json)
                    print (imageString!)
                
                case .failure(let AFError):
                
                    print(AFError)
                
            }
            
        }
        
    }
    
    //次のお題画像を取得するボタン
    @IBAction func nextOdai(_ sender: Any) {
        
        count += 1
        
        if searchTextField.text == "" {
            
            getImage("funny")
            
        } else {
            
            DispatchQueue.global().async {
                    
                self.getImage(self.searchTextField.text!)
                
                DispatchQueue.main.async {
                    
                    self.indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                    self.indicator.center = self.view.center
                    self.indicator.hidesWhenStopped = true
                    self.indicator.style = .large
                    self.view.addSubview(self.indicator)
                    self.indicator.startAnimating()
                    
                }
            }
            
        }
        
    }
    
    //お題画像を検索するボタン
    @IBAction func searchAction(_ sender: Any) {
        
        count = 0
            
            if searchTextField.text == "" {
                
                getImage("funny")
                
            } else {
                
                getImage(searchTextField.text!)
                
            }
            
        }
    
    @IBAction func nextPaging(_ sender: Any) {
        
        performSegue(withIdentifier: "nextPaging", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let shareVC = segue.destination as? ShareViewController
        shareVC?.contentString = contentTextView.text
        shareVC?.resultImage = odaiImageView.image!
        
        
    }
    
}

