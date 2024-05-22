//
//  ContentView.swift
//  FlashZilla
//
//  Created by Brian Vo on 5/21/24.
//

import SwiftUI

struct ContentView: View {
    
    
    
    @State private var cards = [Card]() 
    
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var showingEditScreen = false
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    
    @Environment(\.scenePhase) var scenePhase
    
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled
    
    @State private var isActive = true
    
    var body: some View {
        ZStack{
            Image(decorative: "background")
                .resizable()
                .ignoresSafeArea()
                
            VStack{
                Text("Time: \(timeRemaining )")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical,5)
                    .background(.black.opacity(0.75))
                    .clipShape(.capsule)

                ZStack{
                    //Here we should implement an id also for our loop
                    ForEach(0..<cards.count, id: \.self){
                        index in
                        CardView(card: cards[index]){
                            withAnimation{
                                removeCard(at: index)
                            }
                        }
                            .stacked(at: index, in: cards.count)
                            .allowsHitTesting(index == cards.count - 1)
                            .accessibilityHidden(index < cards.count -  1)
                    }
                    
                    
                }
                .allowsHitTesting(timeRemaining > 0)
                
                if cards.isEmpty{
                    Button("Start again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundStyle(.black)
                        .clipShape(.capsule)
                    
                }
                
                
            }
            
            
            VStack{
                HStack{
                    Spacer()
                    
                    Button{
                        showingEditScreen = true
                    } label:{
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(.circle)
                        
                    }
                    
                }
                Spacer()
                
                
                
            }
            .foregroundStyle(.white)
            .font(.largeTitle)
            .padding()
            
            if accessibilityDifferentiateWithoutColor || accessibilityVoiceOverEnabled{
                VStack{
                    Spacer()
                    HStack{
                        Button{
                            withAnimation{
                                removeCard(at: cards.count - 1)
                            }
                        } label:{
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect")
                        
                        Spacer()
                        
                        Button{
                            withAnimation{
                                removeCard(at: cards.count - 1)
                            }
                            
                            
                        }label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                            
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as being correct")
                        
                       
                    }
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .padding()
                    
                }
            }
            
        }
        .onReceive(timer){
            time in
            guard isActive else{ return }
            if timeRemaining > 0 {
                timeRemaining -= 1
                
            }
        }
        .onChange(of:  scenePhase){
            if scenePhase == .active{
                if cards.isEmpty == false{
                    isActive = true
                }
            }else{
                isActive = false
            }
            
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards, content: EditCards.init)
        .onAppear(perform: resetCards)
    }
    
    func removeCard (at Index : Int){
        
        guard Index >= 0 else {return}
        
        cards.remove(at: Index)
        
        if cards.isEmpty{
            isActive = false
        }
        
        
    }
    
    func resetCards(){
        loadData()
        timeRemaining = 100
        isActive = true
    }
    
    func loadData(){
        
        if let data = UserDefaults.standard.data(forKey: "Cards"){
            if let decoded = try? JSONDecoder().decode([Card].self, from: data){
                cards = decoded
                
            }
                
        }
        
        
        
    }
    
    
}

#Preview {
    ContentView()
}
