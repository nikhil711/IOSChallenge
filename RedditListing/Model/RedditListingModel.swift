//
//  RedditListingModel.swift
//  RedditListing
//
//  Created by NIkhilD on 19/08/21.
//

import Foundation

// MARK: - Reddit Listin
struct RedditListing: Codable {
    let data: RedditData?
}

// MARK: - Reddit Data
struct RedditData: Codable {
    let after: String?
    let dist: Int?
    let children: [RedditChildren]?
}

// MARK: - RedditC hildren
struct RedditChildren: Codable {
    let kind: String?
    let data: RedditChildrenData?
}

// MARK: - Reddit Children Data
struct RedditChildrenData: Codable {
    let content_categories: [String]?
    let subreddit_name_prefixed: String?
    let subreddit: String?
    let created: Int64?
    let title: String?
    let thumbnail: String?
    let ups: Int?
    let num_comments: Int?
    
    let thumbnail_width: Int?
    let thumbnail_height: Int?
}


class RedditListingModel: NSObject {

    //MARK: - Get Report Data for Last Week
    class func getFeedListing(WithPagination page: String, showLoader:Bool, completionHandler:@escaping ((Bool?, Any?, Any?) -> Void)) {
                
        var url = Web_Service.Feed_Listing
        if page != "" {
            url = Web_Service.Feed_Listing + "?after=\(page)"
        }
        
        print("URL : \(url)")
        print("Page : \(page)")
        
        WebSerivceManager.request(url: url, method: .get, showLoader: true, parameters: [:], success: { (response) in
            completionHandler(true, response, nil)
            
        }) { (failure) in
            completionHandler(false, nil, failure)
        }
    }
}

