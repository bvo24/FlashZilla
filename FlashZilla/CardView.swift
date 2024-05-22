//
//  CardView.swift
//  FlashZilla
//
//  Created by Brian Vo on 5/21/24.
//

import SwiftUI


extension View{
    func stacked(at position: Int, in total: Int) -> some View{
        let offset = Double(total - position)
        return self.offset(y: offset * 10)
        
    }
    
    
}

struct CardView: View {
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled
    
    let card : Card
    @State private var offset = CGSize.zero
    @State private var isShowingAnswer = false
    
    var removal: (() -> Void)? = nil
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    //If we have someone color blind we want to just have white other wise we allot for opacity
                    accessibilityDifferentiateWithoutColor ?
                        .white :
                            .white.opacity(1-Double(abs(offset.width/50)))
                )
                .background(
                    accessibilityDifferentiateWithoutColor ?
                    nil :
                    RoundedRectangle(cornerRadius: 25)
                        .fill(offset.width == 0 ? .white : ( offset.width > 0 ? .green : .red))
                )
                .shadow(radius: 10)
            
            VStack{
                if accessibilityVoiceOverEnabled {
                    Text(isShowingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                }
                else{
                    Text(card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                    if isShowingAnswer{
                        Text(card.answer)
                            .font(.title )
                            .foregroundStyle(.secondary)
                    }
                }
                
                
            }
            .padding()
            .multilineTextAlignment(.center)
            
            
            
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(offset.width / 5.0 ))
        .offset(x: offset.width * 5)
        .opacity(2 - Double(abs(offset.width / 50)))
        .accessibilityAddTraits(.isButton)
        .gesture(
        
            DragGesture()
                .onChanged{
                    gesture in
                    offset = gesture.translation
                    
                }
                .onEnded{ _ in
                    //We should not do abs we should check if it's negative or positive in order to see if we want to add it back into the deck
                    //Or we can just keep this and then add a addmethod if the width is negative also this would allow us to add the card to the bottom of the deck
                    if abs(offset.width) > 100{
                        removal?()
                    }else{
                        
                            offset = .zero
                        
                        
                    }
                     
                    
                    
                }
        
        )
        
        .onTapGesture {
            isShowingAnswer.toggle()
        }
        .animation(.default, value: offset)
    }
}

#Preview {
    CardView(card: .example)
}
