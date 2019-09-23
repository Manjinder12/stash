//
//  MpinViewController.swift
//  Stashfin
//
//  Created by Macbook on 11/06/19.
//  Copyright © 2019 Stashfin. All rights reserved.
//

import UIKit

class MpinViewController: UIViewController{
//,UICollectionViewDelegate,UICollectionViewDataSource{

//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//    }
    
    static func getInstance(storyboard: UIStoryboard) -> MpinViewController{
        return storyboard.instantiateViewController(withIdentifier: String(describing: self.classForCoder())) as! MpinViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.colorPrimary
        
        // Do any additional setup after loading the view.
    }
    
    
    
}
