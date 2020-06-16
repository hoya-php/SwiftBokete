//
//  ShareViewController.swift
//  SwiftBokete
//
//  Created by 伊藤和也 on 2020/06/10.
//  Copyright © 2020 kazuya ito. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {

    var resultImage = UIImage()
    var contentString = String()
    
    var screenShotImage = UIImage()
        
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        resultImageView.image = resultImage
        contentLabel.text = contentString
        contentLabel.adjustsFontSizeToFitWidth = true
        
    }
    
    @IBAction func share(_ sender: Any) {
        
        //スクリーンショット
        takeScreenShot()
        
        let items = [screenShotImage] as [Any]
        
        //アクティビティビューにのせ、シェア
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        present(activityVC, animated: true, completion: nil)
        
    }
    
    private func takeScreenShot() {
        
        let width = CGFloat(UIScreen.main.bounds.size.width)
        let height = CGFloat(UIScreen.main.bounds.size.height)
        
        let size = CGSize(width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        //viewに書き出す
        self.view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        
        screenShotImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
    }
    
    @IBAction func back(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    

}
