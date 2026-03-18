import SwiftUI

struct QuizView: View {
    @EnvironmentObject private var appState: AppState
    @State private var currentQuestionIndex = 0
    @State private var sports = 0
    @State private var nightlife = 0
    @State private var creativity = 0
    @State private var showResults = false
    
    let questions: [Question] = Question.allQuestions
    
    var body: some View {
        VStack {
            if showResults {
                ResultView(sports: sports, nightlife: nightlife, creativity: creativity)
            } else {
                Text("Question \(currentQuestionIndex + 1)/\(questions.count)")
                Spacer()
                let question = questions[currentQuestionIndex]
                Text(question.text)
                    .font(.title2)
                    .padding()
                
                ForEach(question.options, id: \.self) { option in
                    Button(option.text) {
                        sports += option.sports
                        nightlife += option.nightlife
                        creativity += option.creativity
                        
                        if currentQuestionIndex < questions.count - 1 {
                            currentQuestionIndex += 1
                        } else {
                            showResults = true
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                }
                
                Spacer()
            }
        }
        .padding()
    }
}

#Preview {
    NavigationView {
        QuizView()
    }
} 
