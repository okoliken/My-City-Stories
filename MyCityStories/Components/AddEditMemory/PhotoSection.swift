//
//  PhotoSection.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 18/11/2025.
//


import SwiftUI
import PhotosUI

struct PhotoSection: View {
    @Binding var photoImage: Image?
    @Binding var selectedPhoto: PhotosPickerItem?
    @Binding var showingCamera: Bool
    var body: some View {
        VStack(spacing: 12) {
            if let photoImage {
                ZStack(alignment: .topTrailing) {
                    photoImage
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .clipped()
                    
                    RemovePhotoSection(photoImage: $photoImage, selectedPhoto: $selectedPhoto)
                }
                .padding(.horizontal)
            } else {
                HStack(spacing: 12) {
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        HStack {
                            Image(systemName: "photo.on.rectangle")
                            Text("Choose Photo")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    Button {
                        showingCamera = true
                    } label: {
                        HStack {
                            Image(systemName: "camera")
                            Text("Take Photo")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(.horizontal)
            }
        }
        .onChange(of: selectedPhoto) { oldValue, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    photoImage = Image(uiImage: uiImage)
                }
            }
        }
        .sheet(isPresented: $showingCamera) {
            Text("Camera View")
        }
    }
}


private struct RemovePhotoSection: View {
    @Binding var photoImage: Image?
    @Binding var selectedPhoto: PhotosPickerItem?
    var body: some View {
        Button {
            withAnimation {
                self.photoImage = nil
                self.selectedPhoto = nil
            }
        } label: {
            Image(systemName: "xmark.circle.fill")
                .font(.title2)
                .foregroundStyle(.white)
                .background(Circle().fill(.black.opacity(0.5)))
        }
        .padding(8)
    }
}
 
