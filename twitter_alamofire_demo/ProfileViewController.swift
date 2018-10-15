//
//  TimelineViewController.swift
//  twitter_alamofire_demo
//
//  Created by Aristotle on 2018-08-11.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import DateToolsSwift

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MyCustomCellDelegator {
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    
    var selectedTweet: Tweet!
    var tweet: Tweet? = nil
    var tweets: [Tweet]! = []
    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = "00aced".colorFromHex()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50
        self.tableView.isHidden = true
        self.tableView.layer.borderWidth = 2.0
        self.tableView.layer.borderColor = UIColor.lightGray.cgColor
        self.refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        self.tableView.insertSubview(refreshControl, at: 0)
        tableView.tableFooterView = UIView()
        var profileImgURL = User.current?.profileImageURL! ?? "";
        profileImgURL = profileImgURL.replacingOccurrences(of: "_normal", with: "")
        self.profileImageView.af_setImage(withURL: URL(string: profileImgURL)!);
        
        APIManager.shared.getBannerURLs(completion: { (banners: [String: Any]?, error: Error?) -> () in
            var size = banners!["web_retina"]! as? [String: Any]
            let bannerImgURL = size!["url"]
            self.bannerImageView.af_setImage(withURL: URL(string: bannerImgURL as! String)!);
        })
        
        let user = User.current!

        self.nameLabel.text = user.name
        self.screenNameLabel.text = "@" + (user.screenName)!
        self.tweetCountLabel.text = String(user.tweetCount!)
        self.followersCountLabel.text = String(user.followers!)
        self.followingCountLabel.text = String(user.following!)
        
        self.getTweets()
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        getTweets()
    }
    
    func getTweets() {
        APIManager.shared.getUserTimeLine(completion: {(tweets: [Tweet]?, error: Error?) -> () in
            self.tweets = tweets
            self.tableView.isHidden = false
            if (error != nil) {
                print("load error")
                print(error?.localizedDescription as Any)
                let alertController = UIAlertController(title: error?.localizedDescription, message:"", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                self.tweets = [];
                self.tableView.isHidden = true
            }
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tweets == nil) {
            return 0
        }
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedTweet = tweets[indexPath.row]
        performSegue(withIdentifier: "toDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? DetailViewController {
            dest.tweet = self.selectedTweet
        } else if let dest = segue.destination as? WriteTweetViewController {
            if (self.selectedTweet != nil) {
                dest.titleString = "Reply to " + (self.selectedTweet.user?.name)!
                dest.tweet = self.selectedTweet
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! tweetCell
        cell.delegate = self
        let tweet = tweets[indexPath.row]
        return APIManager.shared.getTweetCell(cell: cell, tweet: tweet)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        APIManager.logout()
    }
    
    
    func callSegueFromCell(dataObject: Tweet) {
        //try not to send self, just to avoid retain cycles(depends on how you handle the code on the next controller)
        print(dataObject.desciption)
        self.selectedTweet = dataObject
        self.performSegue(withIdentifier: "toWrite", sender: dataObject)
    }
}

