//
//  WriteTweetViewController.swift
//  twitter_alamofire_demo
//
//  Created by Will Xu  on 10/4/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class WriteTweetViewController: UIViewController, UITextViewDelegate {

    var titleString: String = "Post a Tweet"
    @IBOutlet weak var tweetField: UITextView!
    let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.titleString
        navigationController?.navigationBar.barTintColor = "00aced".colorFromHex()
        
        self.tweetField.delegate = self
        
        numberToolbar.barStyle = .default
        numberToolbar.items = [
            UIBarButtonItem(title: "0/140", style: .plain, target: self, action: nil),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(WriteTweetViewController.doneWithNumberPad))]
        numberToolbar.sizeToFit()
        tweetField.inputAccessoryView = numberToolbar
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if (textView.text.count > 140) {
            textView.deleteBackward()
        }
        numberToolbar.items?[0] = UIBarButtonItem(title: String(textView.text!.count) + "/140", style: .plain, target: self, action: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = "";
        textView.textColor = UIColor.black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text.count == 0) {
            numberToolbar.items?[0] = UIBarButtonItem(title: "0/140", style: .plain, target: self, action: nil)
            textView.text = "Post a Tweet..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    func doneWithNumberPad() {
        APIManager.shared.composeTweet(status: tweetField.text) { (error: Error?) in
            self.performSegue(withIdentifier: "toHome", sender: nil)
            print(error)
        }
    }

    @IBAction func cancelPressed(_ sender: Any) {
        performSegue(withIdentifier: "toHome", sender: nil)
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
