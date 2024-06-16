//
//  OnboardingView.swift
//  Annong
//
//  Created by Hyun Jaeyeon on 6/14/24.
//

import SwiftUI

struct OnboardingView: View {
    
    @State var nickname = ""
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                Text("안농?\n닉네임을 입력해주세요")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                TextField("이름을 입력해주세요", text: $nickname)
                    .padding()
                    .background(Color.secondary.opacity(0.15))
                    .clipShape(Capsule())
                    .frame(width: 361)
            }
            
            NavigationLink {
                MessageBoxView(myNickname: $nickname)
                    .navigationBarHidden(true)
            } label: {
                Text("안농 시작하기")
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                    .padding()
                    .padding(.horizontal, 8)
            }
            .background(.accent)
            .clipShape(.capsule)
            .padding(.top, 80)
        }
    }
}

#Preview {
    OnboardingView()
        .preferredColorScheme(.dark)
}
