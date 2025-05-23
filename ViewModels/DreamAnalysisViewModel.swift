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
        do {
            let response = try await model.generateContent("""
            Analyze this dream: \(dream.dreamDescription)
            Respond EXACTLY in this format ONLY: music_genre|emotion|theme
            Rules:
            1. No markdown (**, _)
            2. No quotation marks
            3. No additional text
            4.Use spaces between words (e.g. "indie pop", not "indie_pop")
            5. Only 3 tags separated by pipes
            Example: lofi|longing|regret
        """)
            //go through the response and remove the whitespace and other special characters
            if let text = response.text {
                let parsedTags = text.components(separatedBy: "|")
                    .map {
                        $0.trimmingCharacters(in: .whitespacesAndNewlines)
                          .replacingOccurrences(of: "[*\"“”]", with: "", options: .regularExpression)
                          .replacingOccurrences(of: "_", with: " ")
                    }
                    .filter { !$0.isEmpty }
                tags = parsedTags
                result = text
                dream.tags = parsedTags
                try context.save()
                
            }
        } catch {
            result = "Error: \(error.localizedDescription)"
        }
    }
}
