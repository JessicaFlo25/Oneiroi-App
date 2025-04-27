//
//  DreamAnalysisViewModel.swift
//  Oneiroi
//
//  Created by Jessica Flores Olmos on 4/17/25.
//

import Foundation
import GoogleGenerativeAI
import SwiftData


//although defined model content in the view as a global; still need to 'attach' the actual dream to the instructions
//holdS logic with transformations of view including call to gemini
@MainActor
class DreamAnalysisViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var result: String = "" //not used to display recieved response in the view but rather debugging
    @Published var tags: [String] = [] //gemini response
    
    //model with specific settings
    private let model = GenerativeModel(
        name: "gemini-2.0-flash",
        apiKey: APIKey.default,
        safetySettings: [
            SafetySetting(harmCategory: .hateSpeech, threshold: .blockLowAndAbove),
            SafetySetting(harmCategory: .sexuallyExplicit, threshold: .blockLowAndAbove),
            SafetySetting(harmCategory: .harassment, threshold: .blockLowAndAbove),
            SafetySetting(harmCategory: .dangerousContent, threshold: .blockLowAndAbove)
        ],
        systemInstruction: dreamAnalysisSystemInstruction
    )
    
    //function that performs the api call asynchornously
    //method adkusted to accept passed down dream to get tags and save them to the 'current dream'
    func getResponse(for dream: Dream, context: ModelContext) async {
        isLoading = true
        //remove the loading screen until after the response is recieved
        defer { isLoading = false }
        // Print initial dream details
        print("🔵 Starting analysis for dream:")
        print("Title: \(dream.title)")
        print("Description: \(dream.dreamDescription)")
        print("Current tags (before analysis): \(dream.tags)")
        
        
        do {
            let response = try await model.generateContent("""
                Analyze: \(dream.dreamDescription)
                Respond with: music_genre|emotion|theme
""")
            //go through the response and remove the whitespace and |
            if let text = response.text {
                let parsedTags = text.components(separatedBy: "|")
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines)
                            .replacingOccurrences(of: "\n", with: "")//without this the last tag was being saved with a whitespace
                            .replacingOccurrences(of: "\"", with: "")
                    }
                tags = parsedTags
                result = text
                dream.tags = parsedTags
                //print before saving
                print("🔴 Dream tags before save:", dream.tags)
                try context.save()
                
                //print after saving
                print("🟠 Dream tags after save:", dream.tags)
                print("🟤 Context saved successfully")
                
            }
        } catch {
            result = "Error: \(error.localizedDescription)"
        }
    }
}
