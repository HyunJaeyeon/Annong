//
//  SignInView.swift
//  Annong
//
//  Created by Hyun Jaeyeon on 7/2/24.
//

import SwiftUI

struct SignInView: View {
    var body: some View {
        VStack(alignment: .leading){
            Text("안농하세요?")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    SignInView()
        .preferredColorScheme(.dark)
}
