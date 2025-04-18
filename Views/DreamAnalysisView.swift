//
//  DreamAnalysisView.swift
//  Oneiroi
//
//  Created by Jessica Flores Olmos on 4/16/25.
//

import SwiftUI
import GoogleGenerativeAI

//specify the prompt to give to Gemini, global
let dreamAnalysisSystemInstruction = ModelContent(
    role: "model",
    parts: """
    You are a professional dream interpreter, your goal is to provide three keywords. Focus on the feel of the dream and categorize it as a specific genre of music such as rock, hip-hop, etc., and for the other two keywords please focus on the emotion and overall underlying themes of the dream. Please keep the tags respfectful but creative.
    """
)

struct DreamAnalysisView: View {
    @Binding var dreamDescription: String
    @StateObject private var geminiResponseManager = DreamAnalysisViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("Your dream can be categorized to the following three tags:")
                .font(.headline)

            if geminiResponseManager.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .indigo))
                    .scaleEffect(2)
            } else {
                Text(geminiResponseManager.result)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        .padding()
        .task {
            await geminiResponseManager.getResponse(for: dreamDescription)
        }
    }
}

#Preview {
    DreamAnalysisView(dreamDescription: .constant("I was flying through a purple sky, being chased by shadows."))
}


//require systemInstruction
//can also enable safety setting: safetySettings
