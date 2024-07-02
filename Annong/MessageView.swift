//
//  MessageView.swift
//  Annong
//
//  Created by Hyun Jaeyeon on 6/14/24.
//

import SwiftUI

struct MessageView: View {
    
    let post: Post
    
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
                
                Image("")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
                
                // 내용 입력 부분
                Text("내용")
                    .font(.headline)
                    .foregroundStyle(.accent)
                    .padding(.top, 26)
                
                Text(post.content)
                    .font(.body)
                
                Spacer()
                
                HStack { Spacer() }
            }
            .padding(.leading, 20)
        }
    }
}
