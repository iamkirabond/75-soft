import SwiftUI
import PhotosUI

#if os(iOS)
import UIKit
typealias PlatformImage = UIImage
#elseif os(macOS)
import AppKit
typealias PlatformImage = NSImage
#endif

struct PhotosView: View {
    let vm: AppViewModel
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedPhoto: ProgressPhoto?
    @State private var showingFullScreen = false
    
    var body: some View {
        ZStack {
            Color(red: 0.98, green: 0.97, blue: 0.94)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: - Заголовок
                    VStack(alignment: .leading, spacing: 4) {
                        Text("📸 Progress Photos")
                            .font(.title2)
                            .fontWeight(.light)
                            .foregroundColor(.primary)
                        
                        Text("Capture your journey day by day")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    .padding(.top, 44)
                    
                    // MARK: - Кнопка добавления фото
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        HStack {
                            Image(systemName: "camera.fill")
                                .font(.headline)
                            Text("Add Progress Photo")
                                .font(.headline)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.gray.opacity(0.06), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal)
                    .onChange(of: selectedItem) { _ in
                        Task {
                            if let newValue = selectedItem,
                               let data = try? await newValue.loadTransferable(type: Data.self) {
                                #if os(iOS)
                                if let image = UIImage(data: data) {
                                    await MainActor.run {
                                        vm.addPhoto(image)
                                    }
                                }
                                #elseif os(macOS)
                                if let image = NSImage(data: data) {
                                    await MainActor.run {
                                        vm.addPhoto(image)
                                    }
                                }
                                #endif
                            }
                            await MainActor.run {
                                selectedItem = nil
                            }
                        }
                    }
                    
                    // MARK: - Галерея фото
                    if vm.state.progressPhotos.isEmpty {
                        VStack(spacing: 16) {
                            Spacer()
                                .frame(height: 60)
                            
                            Image(systemName: "photo.stack")
                                .font(.system(size: 60))
                                .foregroundColor(.gray.opacity(0.3))
                            
                            Text("No photos yet")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            Text("Take a photo to track your progress")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 12),
                                GridItem(.flexible(), spacing: 12),
                                GridItem(.flexible(), spacing: 12)
                            ],
                            spacing: 12
                        ) {
                            ForEach(vm.state.progressPhotos.sorted(by: { $0.date > $1.date })) { photo in
                                if let image = vm.getPhotoImage(photo) {
                                    PhotoGridItem(
                                        image: image,
                                        day: photo.day,
                                        date: photo.date
                                    )
                                    .onTapGesture {
                                        selectedPhoto = photo
                                        showingFullScreen = true
                                    }
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            vm.removePhoto(photo)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                        .frame(height: 30)
                }
            }
        }
        .sheet(isPresented: $showingFullScreen) {
            if let photo = selectedPhoto,
               let image = vm.getPhotoImage(photo) {
                FullScreenPhotoView(
                    image: image,
                    day: photo.day,
                    date: photo.date
                )
            }
        }
    }
}

// MARK: - Photo Grid Item
struct PhotoGridItem: View {
    let image: PlatformImage
    let day: Int
    let date: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            #if os(iOS)
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 120)
                .cornerRadius(12)
                .clipped()
            #elseif os(macOS)
            Image(nsImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 120)
                .cornerRadius(12)
                .clipped()
            #endif
            
            HStack {
                Text("Day \(day)")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text(date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.gray.opacity(0.06), lineWidth: 1)
        )
    }
}

// MARK: - Full Screen Photo View
struct FullScreenPhotoView: View {
    let image: PlatformImage
    let day: Int
    let date: Date
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Day \(day)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(date.formatted(date: .long, time: .shortened))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                
                Spacer()
                
                #if os(iOS)
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                #elseif os(macOS)
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                #endif
                
                Spacer()
            }
        }
    }
}
