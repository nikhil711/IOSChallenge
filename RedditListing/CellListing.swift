//
//  CellListing.swift
//  RedditListing
//
//  Created by NIkhilD on 19/08/21.
//

import UIKit
import SDWebImage

class CellListing: UICollectionViewCell {
    
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imageViewThumbnail: UIImageView!
        
    @IBOutlet weak var lblUpvotes: UILabel!
    @IBOutlet weak var lblComments: UIButton!
    
    var feedData: RedditChildrenData?
    
    
    // MARK: - Set Data
    func setData() -> Void {
        // Category
        lblCategory.text = feedData?.subreddit?.capitalized
        
        // Type
        lblType.text = "· \(feedData?.subreddit_name_prefixed ?? "type") ·"
        
        // Time
//        lblTime.text = "\(feedData?.created ?? 0)"
        lblTime.text = getTimeDifference(withTimestamp: feedData?.created ?? 0)
        
        // Title
        lblTitle.text = feedData?.title
        
        // Thumbnail
        let strUrl = feedData?.thumbnail ?? ""
        let url = URL(string: strUrl)
        imageViewThumbnail.sd_setImage(with: url, placeholderImage: UIImage(named: "PlaceholderImage"))
        
        // Upvotes
        let upvotes = feedData?.ups ?? 0
        lblUpvotes.text = "\(upvotes.roundedWithAbbreviations)"
        
        // Comments
        let comments = feedData?.num_comments ?? 0
        lblComments.setTitle("\(comments.roundedWithAbbreviations)", for: .normal)
    }
    
    // MARK: - Get Time Difference
    func getTimeDifference(withTimestamp timestamp: Int64) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let difference = offsetFrom(date: date)
        
        return difference
    }
    
    
    // MARK: - UIButton Actions
    // MARK: - Upvote
    @IBAction func btnUpvoteClicked(_ sender: Any) {
        print("Upvote button clicked")
    }
    
    // MARK: - Downvote
    @IBAction func btnDownVoteClicked(_ sender: Any) {
        print("Downvote button clicked")
    }
    
    // MARK: - Comments
    @IBAction func btnCommentsClicked(_ sender: Any) {
        print("Comments button clicked")
    }
    
    // MARK: - Share
    @IBAction func btnShareClicked(_ sender: Any) {
        print("Share button clicked")
    }
    
    
    func offsetFrom(date: Date) -> String {

        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: Date())

        let seconds = "\(difference.second ?? 0)s"
        let minutes = "\(difference.minute ?? 0)m" //+ " " + seconds
        let hours = "\(difference.hour ?? 0)h" //+ " " + minutes
        let days = "\(difference.day ?? 0)d" //+ " " + hours

        if let day = difference.day, day          > 0 { return days }
        if let hour = difference.hour, hour       > 0 { return hours }
        if let minute = difference.minute, minute > 0 { return minutes }
        if let second = difference.second, second > 0 { return seconds }
        
        return ""
    }
    
}
