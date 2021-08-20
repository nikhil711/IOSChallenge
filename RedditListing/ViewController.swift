//
//  ViewController.swift
//  RedditListing
//
//  Created by NIkhilD on 19/08/21.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionViewListing: UICollectionView!

    var feedResponse: RedditListing?
    var arrayFeed = [RedditChildren]()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Navigation Bar Title
        self.title = "Reddit Listing"
        
        // Get Feed List
        self.getFeedList(WithPagination: "")
    }


}

// MARK: - UICollectionView Delegates / DataSources
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        return CGSize(width: UIScreen.main.bounds.width, height: 200)
        
        // Screen Width
        let screenWidth = UIScreen.main.bounds.width
        
        // Get Thumbnail height and Width, calculate w.r.t. Device's
        let model = self.arrayFeed[indexPath.row]
        let thumb_width = CGFloat(model.data?.thumbnail_width ?? Int(screenWidth))
        let thumb_height = CGFloat(model.data?.thumbnail_height ?? Int(screenWidth / 2))
        
        // Calculate Width and Height
        let percentage = screenWidth / thumb_width
        var newHeight = thumb_height * percentage
        newHeight = newHeight + 62 + 53 // Top and Bottom Padding for other components
        
        return CGSize(width: screenWidth, height: newHeight)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayFeed.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellListing", for: indexPath) as! CellListing
        
        // Get Model
        let model = self.arrayFeed[indexPath.row]
        
        // Set Data
        cell.feedData = model.data
        cell.setData()
        
        // Pagination, check for last cell
        if indexPath.row + 1 == self.arrayFeed.count && (self.feedResponse?.data?.after != "" || self.feedResponse?.data?.after != nil) {
            // Get page Key
            let pageKey = self.feedResponse?.data?.after ?? "page"
            self.getFeedList(WithPagination: pageKey)
        }
        
        return cell
    }
}


// MARK: - API
extension ViewController {
    
    // MARK: - Get Feed List
    func getFeedList(WithPagination page: String) -> Void {
        
        RedditListingModel.getFeedListing(WithPagination: page, showLoader: true) { (isSuccess, response, error) in
            //Check Response
            if isSuccess == true {
                //Success
                if let data = response as? [String: Any] {
                    self.feedResponse = getObjectViaCodable(dict: data)
                    
                    // Get Array
                    self.arrayFeed.append(contentsOf: self.feedResponse?.data?.children ?? [])
                    print("Array Count: \(self.arrayFeed.count)")
                    
                    // Reload Data
                    DispatchQueue.main.async {
                        self.collectionViewListing.reloadData()
                    }
                }
            } else {
                // Show Error
            }
        }
    }
    
}

