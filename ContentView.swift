//
//  ContentView.swift
//  Created by Nikhil Krishnaswamy on 4/14/23.

import SwiftUI
import AudioToolbox

struct CustomButtonStyle:ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Color.clear : Color.blue)
    }
}
struct ContentView: View {
    
    @State private var messageText = ""
    @State var messages: [String] = ["Welcome! My name is Emi!"]
    @ObservedObject var viewModel = ViewModel()
    @State private var showSettings = false
    
    var body: some View {
        VStack {
            ZStack {
                HStack{
                    Image("Title")
                }
            }
            ScrollView {
                ForEach(messages, id: \.self) { message in
                    // If the message contains [USER], that means it's us
                    if message.contains("[USER]") {
                        let newMessage = message.replacingOccurrences(of: "[USER]", with: "")
                        // User message styles
                        HStack {
                            Spacer()
                            Text(newMessage)
                                .padding()
                               
                                .background(Color.blue.opacity(0.5))
                                .cornerRadius(20)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 10)
                        }
                    } else {
                        // Bot message styles
                        HStack {
                            Text(message)
                                .padding()
                                
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(20)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 10)
                            Spacer()
                        }
                    }
                }.rotationEffect(.degrees(180))
            }
            .rotationEffect(.degrees(180))
            // Contains the Message bar
            HStack {
                
                TextField("Type here...", text: $messageText)
                   
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(30)
                    .font(.system(size: 16))
                    .onSubmit {
                        sendMessage(message: messageText)
                        AudioServicesPlaySystemSound(1004)
                    }
                Button {
                    sendMessage(message: messageText)
                    AudioServicesPlaySystemSound(1004)
                } label: {
                    Image(systemName: "paperplane.fill").buttonStyle(CustomButtonStyle())
                }
                .font(.system(size: 20))
                .padding(.horizontal, 10)
            }
            .padding()
        }
        .onAppear {
                    viewModel.setup()
        }
    }
    func sendMessage(message: String) {
        withAnimation {
            
            messages.append("[USER]" + message)
            self.messageText = ""
                withAnimation {
                    viewModel.getBotResponse(text: message) {response in
                        DispatchQueue.main.async {
                            
                            messages.append(response)
                            AudioServicesPlaySystemSound(1003)
                        }
                    }
                    
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
