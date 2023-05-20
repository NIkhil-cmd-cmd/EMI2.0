//
//  BotResponse.swift
//  ChatTest
//
//  Created by Nikhil Krishnaswamy on 4/14/23.

import Foundation
import OpenAISwift
import UIKit

class ViewModel: ObservableObject {
    init () {}
    
    var client: OpenAISwift?
    
    func setup() {
        client = OpenAISwift(authToken: "API KEY GOES HERE (REMOVED FOR PUBLICATION)")
        
    }
    var hiResponse = ["Hello there, my name is Emi! How are you doing?", "My name is Emi, an intelligent and creative virtual assistant designed to help you with your emotions!",
                      "Hello! I am Emi, a virtual assistant and friend.",
                      "Hii! My name is Emi, inspired by thise suffering mental health issues around the world, I can help you feel better or just talk if you need :)",
                      "Hi I'm Emi, how are you?",
                      "Hey, my name is Emi, how may I be of assistance?",
                      "Hi! My name is Emi, created to help you regain confidence, learn more, or just have some fun."]
    func getBotResponse(text: String,
                        completion: @escaping (String) -> Void)
    {
        let query = text.lowercased()+" "
        if (query.contains("hello ") || query.contains("hi ") || query.contains("hey ") || query.contains("yo ")) {
            let num = Int.random(in: 0...6)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
                completion(hiResponse[num])
            }
            
        }
        else if (query.contains("emi stand for") || query.contains("emi mean") || query.contains("emi stands for")) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
                completion("EMI is short for Emotional and Mental Intelligence.")
            }
            
        }
        else if (query.contains("sad") || query.contains("depressed") || query.contains("frustrated") || query.contains("hurt") || query.contains("lonely") || query.contains("frustrated")) {
            client?.sendCompletion(with: ("Respond as a helpful friend/chatbot to help the user with their mental health: "+text),
                                   maxTokens: 85,
                                   completionHandler: {result in
                switch result {
                case .success(let model):
                    let output = model.choices?.first?.text.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                    if output.contains("\n\n"){
                        completion(String(output.dropFirst(2)))
                        
                    }
                    else {
                        completion(output)
                    }
                case .failure:
                    break
                }
            })
        }
        else {
            client?.sendCompletion(with: ("Respond as a friend helping another with their mental health: "+text),
                                   maxTokens: 150,
                                   completionHandler: {result in
                switch result {
                case .success(let model):
                    let output = model.choices?.first?.text ?? ""
                    if output.contains("\n\n"){
                        completion(String(output.dropFirst(2)))
                        
                    }
                    else {
                        completion(output)
                    }
                case .failure:
                    break
                }
            })
            
        }
        
    }
    
}
