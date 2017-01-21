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
        let taskResult = taskViewController.result
        print("TASKRESULT--------")
        print(taskResult)
        let results = taskResult.results as! [ORKStepResult]
        for stepResult in results{
            print("STEP RESULT: ")
            print(stepResult)
            if ((stepResult.results?.count)!>0){
                print("STEP RESULTS GREATER THAN 0")
                print("SIGNATURE:")
                let res = stepResult.results?[0] as? ORKConsentSignatureResult
                let consent = res!.consented
                if (consent){
                    finishedConsent = consent;
                }
            }
        }
        
        taskViewController.dismiss(animated: true, completion: nil)
    }

    @IBAction func consentTapped(_ sender: Any) {
        let taskViewController = ORKTaskViewController(task: ConsentTask, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }
    
    @IBAction func surveyTapped(_ sender: Any) {
        if (finishedConsent){
        print("Survey TAPPED");
        let taskViewController = ORKTaskViewController(task: SurveyTask, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
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

