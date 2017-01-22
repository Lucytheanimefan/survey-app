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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                }else if (stepResult.identifier=="QuestionStep"){
                    let choices = stepResult.results?[0] as! ORKTextQuestionResult
                    let answers = [choices.answer]
                    print("TEXT IDENTIFIER: "+stepResult.identifier)
                    
                    surveyResults[stepResult.identifier]=answers //as [Any]?;
                    
                }else if (stepResult.identifier=="SnackStep" || stepResult.identifier=="IceCreamStep"){
                    let choices = stepResult.results?[0] as! ORKChoiceQuestionResult
                    let answers = choices.answer
                    print("IDENTIFIER: "+stepResult.identifier)
                    surveyResults[stepResult.identifier]=answers as! [Any]?;
                }
                //}
            }
        }
        
        print("SURVET RESULTS: ")
        print(surveyResults)
        survey.logData(data: surveyResults)
        taskViewController.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func consentTapped(_ sender: Any) {
        //onConsent = true
        //onSurvey = false
        let taskViewController = ORKTaskViewController(task: ConsentTask, taskRun: nil)
        print("CONSENT taskViewController: ")
        print(taskViewController)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }
    
    @IBAction func surveyTapped(_ sender: Any) {
        //onSurvey = true
        //onConsent = false
        if (finishedConsent){
            print("Survey TAPPED, new taskviewcontroller so we hope");
            let taskViewController1 = ORKTaskViewController(task: SurveyTask, taskRun: nil)
            print("SURVEY taskViewController: ")
            print(taskViewController1)
            taskViewController1.delegate = self
            present(taskViewController1, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Alert", message: "You did not sign the consent form. Please do that first.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /*
     @IBAction func consentTapped(sender : AnyObject) {
     let taskViewController = ORKTaskViewController(task: ConsentTask, taskRun: nil)
     taskViewController.delegate = self
     present(taskViewController, animated: true, completion: nil)
     }*/
    
}

