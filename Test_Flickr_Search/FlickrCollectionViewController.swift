//
//  FlickrCollectionViewController.swift
//  Test_Flickr_Search
//
//  Created by Alexsander  on 3/28/16.
//  Copyright © 2016 Alexsander Khitev. All rights reserved.
//

import UIKit
import Foundation
import MBProgressHUD

class FlickrCollectionViewController: UICollectionViewController, UITextFieldDelegate {
    
    // MARK: - var and let
    private var sizeAfterRotation: CGSize!
    private var flicrkResults = [FlickrSearchResults]()
    private let flicrk = Flickr()
    private var progress: MBProgressHUD!
    // MARK: - IBOutlets
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }
    
    // MARK: - Lificycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes

        // Do any additional setup after loading the view.
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        print("view will transition")
        sizeAfterRotation = size
        collectionView?.performBatchUpdates(nil, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return flicrkResults.count ?? 0
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flicrkResults[section].searchResults.count ?? 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let reuseIdentifier = "FlickrCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! FlickrCollectionViewCell
    
        // Configure the cell
        let currentImage = flicrkResults[indexPath.section].searchResults[indexPath.row]
        cell.flickrImageView!.image = currentImage.thumbnail
        cell.layer.cornerRadius = 25
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedImage = flicrkResults[indexPath.section].searchResults[indexPath.row]
        print(selectedImage.photoID)
        
        let controller = UIUtility.mainStoryboard.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController

        Flickr.flickrGetImageLocation(selectedImage.photoID) { (coordinate) in
            controller.coordinate = coordinate
            self.showViewController(controller, sender: self)
        }
    }
    
    // MARK: - IBActions
    
    // MARK: - functions
    private func search(text: String) {
        progress = MBProgressHUD.showHUDAddedTo(collectionView, animated: true)
        progress.removeFromSuperViewOnHide = true
        flicrkResults.removeAll()
        flicrk.searchFlickrForTerm(text) { (results, error) in
            if error == nil {
                if results != nil {
                    self.flicrkResults.append(results!)
                    self.progress.hide(true)
                    self.collectionView?.reloadData()
                }
            } else {
                print(error?.localizedDescription, error?.userInfo)
            }
        }
    }
    
    // MARK: - TextFieldDelegate's functions
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.text != "" {
            search(textField.text!)
        }
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }

    
}

// MARK: - UICollectionViewDelegateFlowLayout functions

extension FlickrCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var sizeValue: CGFloat!
        if sizeAfterRotation == nil {
            sizeValue = collectionView.frame.width
            let sizeWidth = sizeValue / 2 - 8
            return CGSize(width: sizeWidth, height: sizeValue / 2)
        } else {
            sizeValue = sizeAfterRotation.width
            let sizeWidth = sizeValue / 2 - 8
            return CGSize(width: sizeWidth, height: sizeValue / 2)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 8
    }
}