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
import CoreData

class FlickrCollectionViewController: UICollectionViewController, UITextFieldDelegate, NSFetchedResultsControllerDelegate, FlickrDelegate {
    
    // MARK: - var and let
    private var sizeAfterRotation: CGSize!
    private let flicrk = Flickr()
    private var progress: MBProgressHUD!
    private var fetchedResultsController: NSFetchedResultsController!
    private let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    private var images = [ImageEntity]()
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
        fetchedResultsControllerLoadData()
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
        return 1 ?? 0
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count ?? 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let reuseIdentifier = "FlickrCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! FlickrCollectionViewCell
    
        // Configure the cell
        let imageEntity = images[indexPath.row]
        let image = UIImage(data: imageEntity.imageData!)
        cell.flickrImageView!.image = image
        cell.layer.cornerRadius = 25
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        searchTextField.resignFirstResponder()
        let selectedImage = images[indexPath.row]
        let controller = UIUtility.mainStoryboard.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
        guard let latitude = selectedImage.latitude as? Double else { return }
        guard let longitude = selectedImage.longitude as? Double else { return }
        let coordinate = CoordinateEntity(latitude: latitude, longitude: longitude)
        controller.coordinate = coordinate
        showViewController(controller, sender: self)
    }
    
    // MARK: - IBActions
    
    // MARK: - functions
    private func search(text: String) {
        flicrk.removeOldImages()
        progress = MBProgressHUD.showHUDAddedTo(collectionView, animated: true)
        progress.removeFromSuperViewOnHide = true
        flicrk.delegate = self
        flicrk.searchFlickrForTerm(text) { (results, error) in
            if error == nil {
                if results != nil {
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

    // MARK: - model functions
    private func fetchedResultsControllerLoadData() {
        let managedObjectContext = appDelegate.managedObjectContext
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print(error.localizedDescription, error.userInfo)
        }
        images = fetchedResultsController.fetchedObjects as! [ImageEntity]
        collectionView?.reloadData()
        print(images.count)
    }
    
    private func fetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "ImageEntity")
        let sortDescriptor = NSSortDescriptor(key: "index", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    // MARK: - flickr delegate
    func flickrDidLoadData() {
        fetchedResultsControllerLoadData()
        collectionView?.reloadData()
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