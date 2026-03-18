//
//  Question.swift
//  coLAge
//
//  Created by Developer on 5/5/25.
//


// MARK: - Question Model

struct Question {
    let text: String
    let options: [Option]
    
    struct Option: Hashable {
        let text: String
        let sports: Int
        let nightlife: Int
        let creativity: Int
    }
    
    static let allQuestions: [Question] = [
        Question(text: "What are some hobbies you enjoy doing?", options: [
            .init(text: "Sports", sports: 2, nightlife: 0, creativity: 0),
            .init(text: "Arts", sports: 0, nightlife: 0, creativity: 2),
            .init(text: "Networking", sports: 0, nightlife: 1, creativity: 1),
            .init(text: "Outdoor activities", sports: 0, nightlife: 0, creativity: 2),
            .init(text: "Media", sports: 0, nightlife: 2, creativity: 0)
        ]),
        Question(text: "How sociable are you?", options: [
            .init(text: "Very social", sports: 0, nightlife: 1, creativity: 1),
            .init(text: "Kind of social", sports: 0, nightlife: 1, creativity: 1),
            .init(text: "Not really social at all", sports: 0, nightlife: 0, creativity: 0),
            .init(text: "Trying to be more social", sports: 0, nightlife: 0, creativity: 0)
        ]),
        Question(text: "How interested are you in connecting with others who enjoy sports?", options: [
            .init(text: "Very likely", sports: 2, nightlife: 0, creativity: 0),
            .init(text: "Somewhat likely", sports: 1, nightlife: 0, creativity: 0),
            .init(text: "Not likely at all", sports: 0, nightlife: 0, creativity: 0)
        ]),
        Question(text: "How interested are you in connecting with others who enjoy nightlife or going out?", options: [
            .init(text: "Very likely", sports: 0, nightlife: 2, creativity: 0),
            .init(text: "Somewhat likely", sports: 0, nightlife: 1, creativity: 0),
            .init(text: "Not likely at all", sports: 0, nightlife: 0, creativity: 0)
        ]),
        Question(text: "How interested are you in connecting with others who enjoy the arts or creativity?", options: [
            .init(text: "Very likely", sports: 0, nightlife: 0, creativity: 2),
            .init(text: "Somewhat likely", sports: 0, nightlife: 0, creativity: 1),
            .init(text: "Not likely at all", sports: 0, nightlife: 0, creativity: 0)
        ])
    ]
}
