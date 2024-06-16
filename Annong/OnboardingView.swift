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
        VStack(alignment: .leading){
            Text("안농?\n닉네임을 입력해주세요")
                .font(.title)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundStyle(.white)
            
            TextField("이름을 입력해주세요", text: $nickname)
                .padding()
                .background(Color.secondary.opacity(0.15))
                .clipShape(Capsule())
                .frame(width: 361)
        }
    }
}

#Preview {
    OnboardingView()
        .preferredColorScheme(.dark)
}
