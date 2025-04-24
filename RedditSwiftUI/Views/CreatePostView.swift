//
//  CreatePostView.swift
//  RedditSwiftUI
//
//  Created by Володимир on 10.04.2025.
//

import SwiftUI
import PhotosUI

struct CreatePostView: View {
    @StateObject private var vm = CreatePostViewModel()
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack(alignment: .leading){
            Text(vm.user != nil ? "username: \(vm.user!.name)" : "please set username")
            
            TextField("Title", text: $vm.postTitle)
                .font(.title)
                .bold()
                .padding(.bottom, 5)
            
            TextEditor(text: $vm.postDescription)
                    .frame(height: 150)
                    .overlay(alignment: .topLeading) {
                        if vm.postDescription.isEmpty {
                            Text("Enter description...")
                                .foregroundColor(.gray)
                                .padding(.leading, 5)
                                .padding(.top, 8)
                        }
                    }
            imagePicker()
            publishButton()
        }
        .onAppear {
            vm.user = PostService.loadUser()
        }
        .padding(.horizontal, 40)
        .onChange(of: vm.selectedPhotoItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    vm.imageToShow = uiImage
                }
            }
        }
    }
    
    @ViewBuilder
    func imagePicker() -> some View {
        VStack {
            if let image = vm.imageToShow {
                ZStack(alignment: .topTrailing){
                    Button(action: {
                        vm.imageToShow = nil
                        vm.selectedPhotoItem = nil
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                    }
                    .padding(5)
                    
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 170)
                        .frame(maxWidth: .infinity)
                        .clipped()
                }
                
            } else {
                PhotosPicker(
                    selection: $vm.selectedPhotoItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    VStack {
                        Text("Choose image")
                    }
                    .frame(maxWidth: .infinity, maxHeight: 40)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
            }
        }
    }
    
    @ViewBuilder
    func publishButton() -> some View {
        Button(action: {
            vm.publishButtonAction(selectedTab: $selectedTab)
        }, label: {
            Text("Publish")
                .bold(true)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .foregroundColor(.white)
                .background(Color.green)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        })
        .alert(item: $vm.activeAlert) { alert in
            switch alert {
            case .missingUsername:
                return Alert(
                    title: Text(alert.message),
                    primaryButton: .default(Text("Open settings")) {
                        vm.activeAlert = nil
                        selectedTab = 2
                    },
                    secondaryButton: .cancel {
                        vm.activeAlert = nil
                    }
                )

            case .incompletePost:
                return Alert(
                    title: Text(alert.message),
                    dismissButton: .default(Text("OK")) {
                        vm.activeAlert = nil
                    }
                )
            }
        }
    }
}

#Preview {
    CreatePostView(selectedTab: .constant(0))
}
