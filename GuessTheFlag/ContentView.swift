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
    
    @State private var tapedFlag = 0
    
    @State private var showingScore = false
    @State private var showingFinalAlert = false
    @State private var scoreTitle = ""
    @State private var playerScore = 0
    @State private var questionsLeft = 8
    @State private var animationAmounts = [0.0, 0.0, 0.0] // an array of animation amounts, one for each button
    @State private var opacityAmounts = [1.0, 1.0, 1.0] // an array of opacity amounts, one for each button
    @State private var scaleAmounts = [CGSize(width: 1.0, height: 1.0), CGSize(width: 1.0, height: 1.0), CGSize(width: 1.0, height: 1.0)] // an array of size amounts, one for each button
    
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
                            withAnimation(.spring(duration: 1, bounce: 0.5)) {
                                self.flagTapped(number) // pass the index of the button to the flagTapped function
                            }
                        }
                       
                    label: {
                            flagImage(flagFileName: countries[number])
                        }
                    .rotation3DEffect(.degrees(animationAmounts[number]), axis: (x: 0, y: 1, z: 0)) // use the animation amount for
                    .opacity(opacityAmounts[number])
                    .scaleEffect(scaleAmounts[number])
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
    
    func flagTapped(_ number: Int) {
        
        if number == correctAnswer {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                askQuestion()
            }
            
//            scoreTitle = "Correct"
            playerScore += 1
            animationAmounts[number] += 360 // update the animation amount for the correct button
            switch number {
            case 0:
                opacityAmounts = [1.0, 0.3, 0.3]
                scaleAmounts = [CGSize(width: 1.0, height: 1.0), CGSize(width: 0.8, height: 0.8), CGSize(width: 0.8, height: 0.8)]
            case 1:
                opacityAmounts = [0.3, 1.0, 0.3]
                scaleAmounts = [CGSize(width: 0.8, height: 0.8), CGSize(width: 1.0, height: 1.0), CGSize(width: 0.8, height: 0.8)]
            default:
                opacityAmounts = [0.3, 0.3, 1.0]
                scaleAmounts = [CGSize(width: 0.8, height: 0.8), CGSize(width: 0.8, height: 0.8), CGSize(width: 1.0, height: 1.0)]
            }
        } else {
            animationAmounts[number] -= 360 // update the animation amount for the correct button
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
            withAnimation {
                showingFinalAlert = true
            }
            
        } else if number != correctAnswer {
            withAnimation {
                showingScore = true
            }
        }
        
       
    }
    
    func askQuestion() {
        withAnimation(.spring(duration: 1, bounce: 0.5)) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        animationAmounts = [0.0, 0.0, 0.0] // reset the animation amounts
        opacityAmounts = [1.0, 1.0, 1.0]
        scaleAmounts = [CGSize(width: 1.0, height: 1.0), CGSize(width: 1.0, height: 1.0), CGSize(width: 1.0, height: 1.0)]
        }
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

