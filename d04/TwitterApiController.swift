//
//  TwitterApiController.swift
//  d04
//
//  Created by Aleksey Tverdokhleb on 10/7/18.
//  Copyright © 2018 Aleksey Tverdokhleb. All rights reserved.
//

import Foundation

class APIController {
    
    weak var delegate: APITwitterDelegate?
    let token: String
    
    init(withToken token: String, andTwitterDelegate delegate: APITwitterDelegate) {
        self.token = token
        self.delegate = delegate
    }
    
    func getAPITwitterRequest(withText aText: String) {
        print("test")
        let newText = "\"\(aText)\""
        guard let theEncodedText = newText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return }
        guard let theUnwrappedURL = URL(string: TwitterApi.URL_API + "1.1/search/tweets.json?q=\(theEncodedText)&count=100") else { return }
        var theRequest = URLRequest(url: theUnwrappedURL as URL)
        theRequest.httpMethod = "GET"
        theRequest.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        let theTask = URLSession.shared.dataTask(with: theRequest) {
            (data, response, error) in
            if let theError = error {
                self.delegate?.processError(theError)
            } else if let theData = data {
                do {
                    let theDictionary = try JSONSerialization.jsonObject(with: theData, options: []) as! [String:Any]
                    guard let theArray = theDictionary["statuses"] as? NSArray else { return }
                    var theTweets: [Tweet] = []
                    
                    for theElement in theArray {
                        guard let theDecodedElement = theElement as? NSDictionary,
                            let theTweetText = theDecodedElement["text"] as? String,
                            let theTweetDate = theDecodedElement["created_at"] as? String,
                            let theUserInfoDecodedElement = theDecodedElement["user"] as? NSDictionary,
                            let theTweetUser = theUserInfoDecodedElement["name"] as? String else { continue }
                        
                        theTweets.append(Tweet(name: theTweetUser, date: self.formatDate(withString: theTweetDate),
                                               text: theTweetText))
                    }
                    print(theTweets)
                    
                    self.delegate?.processTweet(theTweets)
                }
                catch (let theError) {
                    self.delegate?.processError(theError)
                }
            }
        }
        theTask.resume()
    }
    
    private func formatDate(withString aStringDate: String) -> String {
        let theDateFormatter = DateFormatter()
        theDateFormatter.dateFormat = "E MMM d HH:mm:ss Z yyyy"
        guard let theTemporaryDate = theDateFormatter.date(from: aStringDate) else { return "Unknown" }
        let theNewDateFormatter = DateFormatter()
        theNewDateFormatter.dateFormat = "E d HH:mm:ss"
        theNewDateFormatter.timeZone = TimeZone(abbreviation: "GMT+3")
        return theNewDateFormatter.string(from: theTemporaryDate)
    }
    
}
