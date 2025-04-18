//
//  DreamAnalysisViewModel.swift
//  Oneiroi
//
//  Created by Jessica Flores Olmos on 4/17/25.
//

import Foundation
import GoogleGenerativeAI

//holdS logic with transformations of view including call to gemini
class DreamAnalysisViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var result: String = ""
    
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
    
    //function that performs the api call
    //perform api call asynchornously
    func getResponse(for dream: String) async {
        //because awaiting response toggle boolean to show progressview
        isLoading.toggle()
        defer { isLoading = false }
        //no need to set result to empty string since is already empty
        
        do {
            //although defined model content in the view as a global; still need to 'attach' the actual dream to the instructions
            let fullPrompt = """
            Analyze this dream according to the given instructions:
            
            Dream: \(dream)
            
            Respond EXACTLY with 3 pipe-separated values:
            music_genre|emotion|theme
            """
            //send full prompt with dream to Gemini
            let response = try await model.generateContent(fullPrompt)
            //remove loading preview
            isLoading = false
            result = response.text ?? "No response found"
        } catch {
            result = "Failed to analyze dream: \(error.localizedDescription)"
            let errorDetails = """
                    Error: \(String(describing: error))
                    Localized: \(error.localizedDescription)
                    """
            
            //print full error details to console
            print("API Error Details:\n\(errorDetails)")
                    
        }
        
        
    }

}
