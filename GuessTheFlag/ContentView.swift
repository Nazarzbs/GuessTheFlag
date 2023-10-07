//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Nazar on 13.08.2023.
//

import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundStyle(.blue)
    }
}

struct ContentView: View {
    
    @State private var showingScore = false
    @State private var showingFinalAlert = false
    @State private var scoreTitle = ""
    @State private var playerScore = 0
    @State private var questionsLeft = 8
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Ukraine", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guest the Flag")
                    .modifier(Title())
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTaped(number)
                        } label: {
                            flagImage(flagFileName: countries[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(playerScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Spacer()
                
                Text("Questions left: \(questionsLeft)")
                    .foregroundStyle(.white)
                    .font(.title.italic())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(playerScore)")
        }
        .alert(scoreTitle, isPresented: $showingFinalAlert) {
            Button("Restart Game", action: restartGame)
        } message: {
            Text("Your Final score is \(playerScore)")
        }
    }
    
    func flagImage(flagFileName: String) -> some View {
        return Image(flagFileName)
            .renderingMode(.original)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
    
    func flagTaped(_ number: Int) {
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            playerScore += 1
        } else {
            if number == 0 {
                scoreTitle = "Wrong! That’s the flag of \(countries[0])"
            } else if  number == 1 {
                scoreTitle = "Wrong! That’s the flag of \(countries[1])"
            } else {
                scoreTitle = "Wrong! That’s the flag of \(countries[2])"
            }
            if playerScore >= 1 {
                playerScore -= 1
            }
        }
        
        questionsLeft -= 1
        if questionsLeft <= 0 {
            showingFinalAlert = true
        } else {
            showingScore = true
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func restartGame() {
        questionsLeft = 8
        playerScore = 0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

#Preview {
    ContentView()
}
