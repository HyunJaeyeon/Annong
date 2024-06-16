//
//  WritingView.swift
//  Annong
//
//  Created by 이예형 on 6/13/24.
//

import SwiftUI

struct WritingView: View {
    
    @State var title: String = ""
    @State var content: String = ""
    @State var selectedImage: Image? = nil
    @State var isImagePickerPresented = false
    
    @Binding var isShownFullScreenCover: Bool
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .leading) {
                // 제목 입력 부분
                Text("제목")
                    .font(.headline)
                    .foregroundStyle(.accent)
                
                TextField("제목을 입력해주세요", text: $title)
                    .foregroundStyle(Color.placeholder)
                    .padding()
                    .background(Color.textBackground)
                    .cornerRadius(10)
                
                
                // 사진 추가 버튼 부분
                Text("사진")
                    .font(.headline)
                    .foregroundStyle(.accent)
                    .padding(.top, 26)
                
                HStack {
                    Button(action: {
                        isImagePickerPresented = true
                    }) {
                        VStack {
                            Image(systemName: "plus")
                                .font(.largeTitle).fontWeight(.light).foregroundStyle(Color.placeholder)
                        }
                        .frame(width: 100, height: 100)
                        .background(Color.textBackground)
                        .cornerRadius(10)
                    }
                    .sheet(isPresented: $isImagePickerPresented) {
                        ImagePicker(selectedImage: $selectedImage)
                    }
                    
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
                            .foregroundStyle(content.isEmpty ? .placeholder : .clear)
                            .opacity(0.5)
                            .font(.body)
                    }
                    .padding()
                    .contentMargins(.horizontal, -5)
                    .contentMargins(.top, -10)
                    .scrollContentBackground(.hidden)
                    .background(Color.textBackground)
                    .cornerRadius(10)
                    .frame(height: 200)
                
                Spacer()
            }
            .padding()
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
                        // TODO: SwiftData에 저장
                    }) {
                        Text("완료")
                    }
                }
            }
        }
    }
}

// 이미지 피커
struct ImagePicker: UIViewControllerRepresentable {
    // 이미지 변수명: selectedImage, 데이터 타입 Image
    @Binding var selectedImage: Image?
    @Environment(\.presentationMode) private var presentationMode
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = Image(uiImage: uiImage)
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {}
}


#Preview {
    WritingView(isShownFullScreenCover: .constant(true))
        .preferredColorScheme(.dark)
}
