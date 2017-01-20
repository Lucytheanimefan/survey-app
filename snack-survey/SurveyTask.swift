//
//  SurveyTask.swift
//  snack-survey
//
//  Created by Lucy Zhang on 1/20/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import ResearchKit

public var SurveyTask: ORKOrderedTask {
    
    var steps = [ORKStep]()
    
    /*
 Favorite flavor of ice cream given 4 choices. Select one.
 Favorite snacks given a list of 8. Select multiple.
 Ask them to give in a short text answer why they like the ice cream or snacks they selected. (This is a follow-on question to the surveys).
 */
    
    //TODO: add instructions step
    let instructionStep = ORKInstructionStep(identifier: "IntroStep")
    instructionStep.title = "The Questions Three"
    instructionStep.text = "Who would cross the Bridge of Death must answer me these questions three, ere the other side they see."
    steps += [instructionStep]
    //can add image via image property later
    
    //favorite ice cream?
    let questQuestionStepTitle = "What is your favorite ice cream?"
    let textChoices = [
        ORKTextChoice(text: "Cookies and Cream", value: 0 as NSNumber),
        ORKTextChoice(text: "Chocolate Chip Cookie Dough", value: 1 as NSNumber),
        ORKTextChoice(text: "Strawberry", value: 2 as NSNumber),
        ORKTextChoice(text: "Vanilla", value: 3 as NSNumber)
    ]
    let questAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
    let questQuestionStep = ORKQuestionStep(identifier: "IceCreamStep", title: questQuestionStepTitle, answer: questAnswerFormat)
    steps += [questQuestionStep]
    
    //favorite snack
    let snackQuestionStepTitle = "What is your favorite snack?"
    let snackTextChoices = [
        ORKTextChoice(text: "Twix", value: 0 as NSNumber),
        ORKTextChoice(text: "Granola", value: 1 as NSNumber),
        ORKTextChoice(text: "Pizza", value: 2 as NSNumber),
        ORKTextChoice(text: "Caffeine", value: 3 as NSNumber),
        ORKTextChoice(text: "Chips", value: 4 as NSNumber),
        ORKTextChoice(text: "Ramen", value: 5 as NSNumber),
        ORKTextChoice(text: "Real Sushi", value: 6 as NSNumber),
        ORKTextChoice(text: "Fake Sushi", value: 7 as NSNumber)
        
    ]
    let snackAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .multipleChoice, textChoices: snackTextChoices)
    let snackQuestionStep = ORKQuestionStep(identifier: "SnackStep", title: snackQuestionStepTitle, answer: snackAnswerFormat)
    snackQuestionStep.isOptional = true
    steps += [snackQuestionStep]
    
    //why they chose what they chose
    let nameAnswerFormat = ORKTextAnswerFormat(maximumLength: 50)
    nameAnswerFormat.multipleLines = true
    let nameQuestionStepTitle = "Why did you choose those particular snacks and/or ice cream?"
    let nameQuestionStep = ORKQuestionStep(identifier: "QuestionStep", title: nameQuestionStepTitle, answer: nameAnswerFormat)
    nameQuestionStep.isOptional=true
    steps += [nameQuestionStep]
    
    //summary step
    let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
    summaryStep.title = "All done"
    summaryStep.text = "Thank you. The world is a little bit better knowing your favorite snacks."
    steps += [summaryStep]
    

    
    return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
}
