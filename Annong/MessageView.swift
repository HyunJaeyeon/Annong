//
//  MessageView.swift
//  Annong
//
//  Created by Hyun Jaeyeon on 6/14/24.
//

import SwiftUI
import SensitiveContentAnalysis

struct MessageView: View {
    
    let post: Post
    
    @State private var analysisState: AnalysisState = .notStarted
    @State private var errorMessage = ""
    @State private var showSensitiveContent = false
    
    enum AnalysisState {
        case notStarted
        case analyzing
        case isSensitive
        case notSensitive
        case error(message: String)
    }
    
    func isSensitive(image: Data?) async {
        analysisState = .analyzing
        let analyzer = SCSensitivityAnalyzer()
        let policy = analyzer.analysisPolicy
        
        if policy == .disabled {
            print("Policy is disabled")
        }
        
        do {
            guard let image = UIImage(data: image!)
            else {
                print("Image not found")
                analysisState = .error(message: "Image not found")
                return
            }
            let response = try await analyzer.analyzeImage(image.cgImage!)
            analysisState = response.isSensitive ? .isSensitive : .notSensitive
        } catch {
            print("Unable to get a response", error)
            analysisState = .error(message: error.localizedDescription)
        }
    }
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading) {
                // 제목 입력 부분
                Text("제목")
                    .font(.headline)
                    .foregroundStyle(.accent)
                
                Text(post.title)
                    .padding()
                    .background(Color.textBackground)
                    .cornerRadius(10)
                
                // 사진 추가 버튼 부분
                Text("사진")
                    .font(.headline)
                    .foregroundStyle(.accent)
                    .padding(.top, 26)
                
                Group {
                    switch analysisState {
                    case .notStarted:
                        EmptyView()
                    case .analyzing:
                        ProgressView()
                    case .isSensitive:
                        if let imageData = post.image, let uiImage = UIImage(data: imageData) {
                            ZStack {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                                    .cornerRadius(10)
                                    .blur(radius: showSensitiveContent ? 0 : 10)
                                    .animation(.easeInOut, value: showSensitiveContent)
                                
                                if !showSensitiveContent {
                                    Color.black.opacity(0.5)
                                        .frame(height: 200)
                                        .cornerRadius(10)
                                    
                                    VStack {
                                        Image(systemName: "eye.slash")
                                            .font(.system(size: 50))
                                            .foregroundColor(.white)
                                        Text("Sensitive Content")
                                            .font(.title)
                                            .foregroundColor(.white)
                                            .padding(.top, 10)
                                        Text("This photo may contain graphic or violent content.")
                                            .font(.body)
                                            .foregroundColor(.white)
                                            .padding(.top, 5)
                                        Button(action: {
                                            withAnimation {
                                                showSensitiveContent = true
                                            }
                                        }) {
                                            Text("See why")
                                                .foregroundColor(.white)
                                                .padding()
                                                .background(Color.gray.opacity(0.7))
                                                .cornerRadius(10)
                                                .padding(.top, 20)
                                        }
                                    }
                                    .padding()
                                    .background(Color.black.opacity(0.5))
                                    .cornerRadius(20)
                                }
                            }
                        }
                    case .notSensitive:
                        if let imageData = post.image, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(10)
                        }
                    case .error(let message):
                        Text("Error: \(message)")
                    }
                }
                
                // 내용 입력 부분
                Text("내용")
                    .font(.headline)
                    .foregroundStyle(.accent)
                    .padding(.top, 26)
                
                Text(post.content)
                    .font(.body)
                
                Spacer()
                HStack { Spacer() }
            }.padding(.leading, 20)
            
            .onAppear {
                Task {
                    await isSensitive(image: post.image)
                }
            }
        }
    }
}
