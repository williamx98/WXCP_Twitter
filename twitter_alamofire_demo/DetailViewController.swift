//
//  DetailViewController.swift
//  twitter_alamofire_demo
//
//  Created by Will Xu  on 10/11/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var tweet: Tweet!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var statImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var profileImgURL = tweet.user?.profileImageURL! ?? "";
        profileImgURL = profileImgURL.replacingOccurrences(of: "_normal", with: "")
        usernameLabel.text = tweet.user?.name
        tweetLabel.text = tweet.text
        handleLabel.text = "@" + String(tweet.user?.screenName ?? "")
        profileImageView.af_setImage(withURL: URL(string: profileImgURL)!)
        dateLabel.text = tweet.timeAgo
        
        if (tweet.retweeted!) {
            retweetImageView.image = UIImage(named: "retweet-icon-green")
        } else {
            retweetImageView.image = UIImage(named: "retweet-icon")
        }
        
        if (tweet.favorited!) {
            favoriteImageView.image = UIImage(named: "favor-icon-red")
        } else {
            favoriteImageView.image = UIImage(named: "favor-icon")
        }

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
        statImageView.addGestureRecognizer(tap4)
        statImageView.isUserInteractionEnabled = true
    }

    func favorited() {
        tweet.favorited = !tweet.favorited!
        if (tweet.favorited!) {
            tweet.favoriteCount! += 1
            self.favoriteImageView.image = UIImage(named: "favor-icon-red")
            APIManager.shared.favorite(self.tweet, completion: {(tweet: Tweet?, error: Error?) -> () in
                
            })
        } else {
            tweet.favoriteCount! -= 1
            self.favoriteImageView.image = UIImage(named: "favor-icon")
            APIManager.shared.unfavorite(self.tweet, completion: {(tweet: Tweet?, error: Error?) -> () in
                
            })
        }
    }
    
    func retweet() {
        tweet.retweeted = !tweet.retweeted!
        if (tweet.retweeted!) {
            tweet.retweetCount! += 1
            self.retweetImageView.image = UIImage(named: "retweet-icon-green")
            APIManager.shared.retweet(self.tweet, completion: {(tweet: Tweet?, error: Error?) -> () in
                
            })
        } else {
            tweet.retweetCount! -= 1
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
