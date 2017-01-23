//
//  ViewController.swift
//  snack-survey
//
//  Created by Lucy Zhang on 1/19/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import UIKit
import ResearchKit

class ViewController: UIViewController {
    var finishedConsent = false
    var onConsent = false
    var onSurvey = false
    var i=0;
    let survey = surveyAPI();
    var surveyResults:[String: [Any]]=[:]
    
    var foodKey:[Int:String] = [0:"Cookies and Cream",1:"Chocolate Chip Cookie Dough",2:"Strawberry",3:"Vanilla",4:"Twix",5:"Granola",6:"Pizza",7:"Caffeine",8:"Chips",9:"Ramen",10:"Real Sushi",11:"Fake Sushi"]
    
    @IBOutlet weak var roundedCornerButton: UIButton! //consent button
    @IBOutlet weak var roundedCornerSurveyButton: UIButton! //survey button
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "foodyPenguin")!)
        roundedCornerButton.layer.cornerRadius = 5
        roundedCornerSurveyButton.layer.cornerRadius = 5
        /*
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "foodyPenguin")?.draw(in: self.view.bounds)
        
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
 */
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController : ORKTaskViewControllerDelegate {
    
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        print("taskViewController CALLED "+String(i))
        i += 1;
        let taskResult = taskViewController.result
        print("TASKRESULT--------")
        print(taskResult)
        let results = taskResult.results as! [ORKStepResult]
        for stepResult in results{
            print("STEP RESULT: ")
            print(stepResult)
            if ((stepResult.results?.count)!>0){
                //if (onConsent){
                if (stepResult.identifier=="ConsentReviewStep"){
                    let res = stepResult.results?[0] as? ORKConsentSignatureResult
                    let consent = res!.consented
                    if (consent){
                        finishedConsent = consent;
                    }
                }else if (stepResult.identifier=="SnackThoughts"){
                    surveyResults["Time Submitted"] = [Date().iso8601] as [Any]
                    let choices = stepResult.results?[0] as! ORKTextQuestionResult
                    let answers = [choices.answer]
                    //print("TEXT IDENTIFIER: "+stepResult.identifier)
                    
                    surveyResults[stepResult.identifier]=answers //as [Any]?;
                    
                }else if (stepResult.identifier=="Snack" || stepResult.identifier=="IceCream"){
                    let choices = stepResult.results?[0] as! ORKChoiceQuestionResult
                    var realAnswers:[String]=[];
                    let answers = choices.answer as! [Int]
                    for ans in answers{
                        realAnswers.append(foodKey[ans]!)
                    }
                    print("IDENTIFIER: "+stepResult.identifier)
                    surveyResults[stepResult.identifier] = realAnswers;
                }
                //}
            }
        }
        
        print("SURVET RESULTS: ")
        print(surveyResults)
        if (onSurvey){
            survey.logData(data: surveyResults)
        }
        taskViewController.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func consentTapped(_ sender: Any) {
        onConsent = true
        onSurvey = false
        let taskViewController = ORKTaskViewController(task: ConsentTask, taskRun: nil)
        print("CONSENT taskViewController: ")
        print(taskViewController)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }
    
    @IBAction func surveyTapped(_ sender: Any) {
        onSurvey = true
        surveyResults["Time Survey Began"] = [Date().iso8601]
        if (finishedConsent){
            print("Survey TAPPED, new taskviewcontroller so we hope");
            let taskViewController1 = ORKTaskViewController(task: SurveyTask, taskRun: nil)
            print("SURVEY taskViewController: ")
            print(taskViewController1)
            taskViewController1.delegate = self
            present(taskViewController1, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Alert", message: "You did not sign the consent form. Please do that first.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
}


extension String {
    var dateFromISO8601: Date? {
        return Date.iso8601Formatter.date(from: self)
    }
}

extension Date {
    static let iso8601Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
    var iso8601: String {
        return Date.iso8601Formatter.string(from: self)
    }
}

