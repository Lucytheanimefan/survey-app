//
//  surveyAPI.swift
//  snack-survey
//
//  Created by Lucy Zhang on 1/21/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import Foundation

class surveyAPI{
    func logData(data: [String: [Any]]){
        print("LOGGING DATA")
        let request = "https://survey-database.herokuapp.com/logData"
        makeHTTPPostRequest(path: request, body:data)

    }
    
    //performs post request
    private func makeHTTPPostRequest(path: String, body: [String: Any]) {
        let request = NSMutableURLRequest(url: NSURL(string: path)! as URL)
        
        // Set the method to POST
        request.httpMethod = "POST"
        
        do {
            // Set the POST body for the request
            //let jsonBody = try NSJSONSerialization.dataWithJSONObject(body, options: .PrettyPrinted)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = try! JSONSerialization.data(withJSONObject: body, options: [])
            //request.HTTPBody = jsonBody
            let session = URLSession.shared
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                if let jsonData = data {
                    //let json:JSON = JSON(data: jsonData)
                    //onCompletion(json, nil)
                    print("The Response: ")
                    //print(json)
                } else {
                    //onCompletion(nil, error)
                    print("The Response: ")
                    print("Hello")
                }
            })
            task.resume()
        } catch {
            // Create your personal error
            //onCompletion(nil, nil)
        }
    }
}
