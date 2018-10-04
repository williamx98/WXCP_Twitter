//
//  TimelineViewController.swift
//  twitter_alamofire_demo
//
//  Created by Aristotle on 2018-08-11.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

extension String {
    func colorFromHex() -> UIColor {
        let cString:String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

class TimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!

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
        
        self.refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        self.tableView.insertSubview(refreshControl, at: 0)
        
        self.getTweets()
    }

    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        self.getTweets()
    }
    
    func getTweets() {
        APIManager.shared.getHomeTimeLine(completion: {(tweets: [Tweet]?, error: Error?) -> () in
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
            APIManager.shared.updateUser()
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tweets == nil) {
            return 0
        }
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! tweetCell
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
    
}
