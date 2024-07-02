//
//  WritingView.swift
//  Annong
//
//  Created by 이예형 on 6/13/24.
//
import SwiftUI
import FirebaseFirestore

struct WritingView: View {
    
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var selectedImage: Data? = nil
    @State var recipientUid: String
    @State private var isImagePickerPresented = false
    @State var authorUid: String
    
    @ObservedObject var firestoreManager: FireStoreManager
    
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
                    
                    if let imageData = selectedImage, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        savePost()
                        isShownFullScreenCover.toggle()
                    }) {
                        Text("완료")
                    }
                }
            }
        }
    }
    
    private func savePost() {
            let date = Date()
            let newPost = Post(id: nil, title: self.title, content: self.content, authorUid: self.authorUid, recipientUid: self.recipientUid, date: date)
            
            firestoreManager.addPost(newPost, recipientUid: self.recipientUid) { success in
                if success {
                    print("Post successfully saved!")
                } else {
                    print("Failed to save post.")
                }
            }
        }
}


// 이미지 피커
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: Data?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image.jpegData(compressionQuality: 1.0)
            }
            picker.dismiss(animated: true)
        }
    }
}
