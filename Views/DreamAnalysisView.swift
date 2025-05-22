//
//  DreamAnalysisView.swift
//  Oneiroi
//
//  Created by Jessica Flores Olmos on 4/16/25.
//

import SwiftUI
import GoogleGenerativeAI
import SwiftData

//specify the prompt to give to Gemini, global, attach the actual dream received in
//viewmodel method
let dreamAnalysisSystemInstruction = ModelContent(
    role: "model",
    parts: """
    You are a professional dream interpreter, your goal is to provide three keywords. Focus on the feel of the dream and categorize it as a specific genre of music such as rock, hip-hop, etc., and for the other two keywords please focus on the emotion and overall underlying themes of the dream. Please keep the tags respfectful but creative.
    """
)

struct DreamAnalysisView: View {
    @Bindable var dream: Dream
    @StateObject private var geminiResponseManager = DreamAnalysisViewModel()
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Your dream can be categorized into the following three tags:")
                .font(.custom("AnticDidone-Regular", size: 24))
                .font(.headline)
            
            if geminiResponseManager.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .indigo))
                    .scaleEffect(2)
            } else {
                //call resuable view, no need for result from viewmodel
                DreamTagView(dreamTags: $dream.tags)
            }
        }
        .frame(height: 200)
        .padding()
        .task {
            await geminiResponseManager.getResponse(for: dream, context: modelContext)
        }
        Image("rabbitandcarrot")
            .resizable()
            .frame(width: 400, height:500)
            .padding(.bottom, 20)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Dream.self, configurations: config)
    let dream = Dream(description: "Test dream", title: "Test")
    let context = ModelContext(container)
    
    return DreamAnalysisView(dream: dream)
        .modelContainer(container)
        .environment(\.modelContext, context)
}
