//
//  PhotoSection.swift
//  MyCityStories
//
//  Created by Jeffery Okoli on 18/11/2025.
//

import PhotosUI
import SwiftUI

struct PhotoSection: View {
  @Binding var photoImages: [UIImage]
  @Binding var selectedPhotos: [PhotosPickerItem]
  @Binding var showingCamera: Bool

  var body: some View {
    VStack(spacing: 12) {
      if !photoImages.isEmpty {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: DesignTokens.Spacing.md) {
            ForEach(0 ..< photoImages.count, id: \.self) { imageIndex in
              ZStack(alignment: .topTrailing) {
                Image(uiImage: photoImages[imageIndex])
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 280, height: 200)
                  .clipShape(RoundedRectangle(cornerRadius: 12))
                  .clipped()

                RemovePhotoSection(
                  photoImages: $photoImages,
                  selectedPhotos: $selectedPhotos,
                  imageIndex: imageIndex
                )
              }
            }
          }
          .padding(.horizontal, DesignTokens.Spacing.md)
        }
        .frame(height: 200)

      } else {
        HStack(spacing: 12) {
          PhotosPicker(selection: $selectedPhotos, maxSelectionCount: 5, matching: .images) {
            let placeholderImage = Image(systemName: "photo.on.rectangle.angled")
            VStack(spacing: 16) {
              placeholderImage
                .font(.system(size: 48))

              Text("Tap to choose a photo")
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)
            .background(
              RoundedRectangle(cornerRadius: 16)
                .strokeBorder(
                  DesignTokens.Colors.cardStrokeColor,
                  style: StrokeStyle(lineWidth: 4, dash: [8, 4])
                )
            )
          }
          .buttonStyle(.plain)
        }
        .padding(.horizontal)
      }
    }
    .onChange(of: selectedPhotos) {
      Task {
        let startIndex = photoImages.count
        guard startIndex < selectedPhotos.count else { return }

        for index in startIndex..<selectedPhotos.count {
          let item = selectedPhotos[index]
          if let data = try? await item.loadTransferable(type: Data.self),
            let uiImage = UIImage(data: data)
          {
            photoImages.append(uiImage)
          }
        }
      }
    }
  }
}

private struct RemovePhotoSection: View {
  @Binding var photoImages: [UIImage]
  @Binding var selectedPhotos: [PhotosPickerItem]
  let imageIndex: Int

  var body: some View {
    Button {
      withAnimation {
        photoImages.remove(at: imageIndex)
        if imageIndex < selectedPhotos.count {
          selectedPhotos.remove(at: imageIndex)
        }
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
