//
//  SwiftUIView.swift
//  ChatTest
//
//  Created by Nikhil Krishnaswamy on 1/16/23.
//

import SwiftUI
import AudioToolbox

struct SwiftUIView: View {
    @State private var isActive = 0
    @State private var opacity = 0.1
    @State private var col = Color.purple
    
    var body: some View {
        if isActive == 1 {
            ContentView()
            
        } else if isActive == 0 {
            VStack{
                VStack{
                    Image("Load")
                        .frame(width: 40.0, height: 40.0).padding(.all)
                    
                }
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 0.5)){
                        
                        self.opacity = 1
                    }
                }
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    withAnimation{
                        
                        self.isActive = 1
                        
                    }
                    
                }
            }
        }
            
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
