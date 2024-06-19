//
//  NicknameCheckView.swift
//  Annong
//
//  Created by Hyun Jaeyeon on 6/14/24.
//

import SwiftUI

struct NicknameCheckView: View {
    
    @State private var friendNickname = ""
    @State private var isNavigate = false
    
    @Binding var isShownFullScreenCover: Bool
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                Text("친구의 닉네임을 입력해주세요")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                TextField("이름을 입력해주세요", text: $friendNickname)
                    .padding()
                    .background(Color.secondary.opacity(0.15))
                    .clipShape(Capsule())
                    .frame(width: 361)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isShownFullScreenCover.toggle()
                    }) {
                        Text("취소")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isNavigate.toggle()
                    }) {
                        Text("다음")
                    }
                }
            }
            .navigationDestination(isPresented: $isNavigate, destination: {
                WritingView(isShownFullScreenCover: $isShownFullScreenCover)
            })
        }
    }
}

#Preview {
    NicknameCheckView(isShownFullScreenCover: .constant(true))
        .preferredColorScheme(.dark)
}


