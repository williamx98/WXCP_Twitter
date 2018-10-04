//
//  tweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Will Xu  on 10/3/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import DateToolsSwift

class tweetCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var statsImageView: UIImageView!
    
    var tweet: Tweet!
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.favorited))
        favoriteImageView.addGestureRecognizer(tap)
        favoriteImageView.isUserInteractionEnabled = true
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.retweet))
        retweetImageView.addGestureRecognizer(tap2)
        retweetImageView.isUserInteractionEnabled = true
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.reply))
        replyImageView.addGestureRecognizer(tap3)
        replyImageView.isUserInteractionEnabled = true
        
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(self.stats))
        statsImageView.addGestureRecognizer(tap4)
        statsImageView.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func favorited() {
        tweet.favorited = !tweet.favorited!
        if (tweet.favorited!) {
            self.favoriteImageView.image = UIImage(named: "favor-icon-red")
            APIManager.shared.favorite(self.tweet, completion: {(tweet: Tweet?, error: Error?) -> () in
                
            })
        } else {
            self.favoriteImageView.image = UIImage(named: "favor-icon")
            APIManager.shared.unfavorite(self.tweet, completion: {(tweet: Tweet?, error: Error?) -> () in
                
            })
        }
    }
    
    func retweet() {
        tweet.retweeted = !tweet.retweeted!
        if (tweet.retweeted!) {
            self.retweetImageView.image = UIImage(named: "retweet-icon-green")
            APIManager.shared.retweet(self.tweet, completion: {(tweet: Tweet?, error: Error?) -> () in
                
            })
        } else {
            self.retweetImageView.image = UIImage(named: "retweet-icon")
            APIManager.shared.unretweet(self.tweet, completion: {(tweet: Tweet?, error: Error?) -> () in
                
            })

        }
    }

    func reply() {
        print("reply")
    }
    
    func stats() {
        print(self.tweet.desciption)
        var message = "@" + self.tweet.user!.screenName! + " said:\n\n" + self.tweet.text!
        message += "\n\nfavorited: " + String(self.tweet.favoriteCount!) + " times\n"
        message += "retweeted: " + String(self.tweet.retweetCount!) + " times\n"
        message += "created at: " + self.tweet.createdAtString!
        let alertController = UIAlertController(title: "Stats", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
