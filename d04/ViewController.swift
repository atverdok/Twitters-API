//
//  ViewController.swift
//  d04
//
//  Created by Aleksey Tverdokhleb on 10/7/18.
//  Copyright © 2018 Aleksey Tverdokhleb. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, APITwitterDelegate {
    
    func processTweet(_ tweets: [Tweet]) {
        self.tweets = tweets
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func processError(_ error: Error) {
        print(error.localizedDescription)
    }
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var searchField: UITextField!
    
    var apiControllerClass: APIController?
    
    var tweets: [Tweet] = [] {
        willSet {
            if newValue.isEmpty {
                self.showAlert(withMessage: "Invalid query.")
            }
        }
    }
    
    var token: String = "" {
        willSet {
            if newValue != "" {
                self.apiControllerClass = APIController(withToken: newValue, andTwitterDelegate: self)
                self.apiControllerClass?.getAPITwitterRequest(withText: "school 42")
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getToken()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweatCell") as! TwitterTableViewCell

        if tweets.count > 0 {
            cell.tweat = tweets[indexPath.row]
        }
        return cell
    }
    
    func getToken() {
        let theBearer = ((TwitterApi.COSTUMER_KEY + ":" + TwitterApi.COSTUMER_SECRET).data(using: String.Encoding.utf8))!.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
        guard let url = URL(string: TwitterApi.URL_API + "oauth2/token") else { return }
        var request = URLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.setValue("Basic " + theBearer, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8)
        let theTask = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let error = error {
                self.showAlert(withMessage: error.localizedDescription)
            } else if let data = data {
                do {
                    let dic = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                    //                    print(dic)
                    guard let theToken = dic["access_token"] as? String else { return }
                    //                    print(theToken)
                    self.token = theToken
                }
                catch (let error) {
                    self.showAlert(withMessage: error.localizedDescription)
                }
            }
        }
        theTask.resume()
    }
    
    func showAlert(withMessage message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }

}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let theAPIController = self.apiControllerClass else {
            showAlert(withMessage: "Some problems with API Controller, try again")
            return false
        }
        guard let theTrimmedText = textField.text else {
            showAlert(withMessage: "Invalid text")
            return false
        }
        guard theTrimmedText.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
            showAlert(withMessage: "Empty text, type something!")
            return false
        }
        view.endEditing(true)
        theAPIController.getAPITwitterRequest(withText: theTrimmedText)
        return true
    }
    
}
