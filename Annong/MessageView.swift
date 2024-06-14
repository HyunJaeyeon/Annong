//
//  MessageView.swift
//  Annong
//
//  Created by Hyun Jaeyeon on 6/14/24.
//


import SwiftUI

struct MessageView: View {
    @Binding var title: String
    @State var selectedImage: Image? = Image("")
    @Binding var content: String
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                // 제목 입력 부분
                Text("제목")
                    .font(.headline)
                    .foregroundStyle(.accent)
                
                Text(title)
                    .padding()
                    .background(Color.textBackground)
                    .cornerRadius(10)
                
                
                // 사진 추가 버튼 부분
                Text("사진")
                    .font(.headline)
                    .foregroundStyle(.accent)
                    .padding(.top, 26)
                
                HStack {
                    if let selectedImage = selectedImage {
                        selectedImage
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .cornerRadius(10)
                            .padding(.leading, 10)
                    }
                }
                
                // 내용 입력 부분
                Text("내용")
                    .font(.headline)
                    .foregroundStyle(.accent)
                    .padding(.top, 26)
                
                TextEditor(text: $content)
                    .overlay(alignment: .topLeading) {
                        Text("내용을 입력해주세요")
                            .foregroundStyle(content.isEmpty ? Color.placeholder : .clear)
                            .font(.body)
                    }
                    .padding()
                    .disabled(true)
                    .contentMargins(.horizontal, -5)
                    .contentMargins(.top, -10)
                    .scrollContentBackground(.hidden)
                    .background(Color.textBackground)
                    .cornerRadius(10)
                    .frame(height: 200)
                
                Spacer()
            }
            .padding()
        }.background(Color.background)
    }
}


#Preview {
    MessageView(title: .constant("나 스티브 잡슨데, 이 앱 좋다"), content: .constant("그러게"))
}
