import SwiftUI
import PhotosUI

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
                               let data = try? await newValue.loadTransferable(type: Data.self),
                               let image = UIImage(data: data) {
                                await MainActor.run {
                                    vm.addPhoto(image)
                                }
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
                        let sortedPhotos = vm.state.progressPhotos.sorted { $0.date > $1.date }
                        
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 12),
                                GridItem(.flexible(), spacing: 12),
                                GridItem(.flexible(), spacing: 12)
                            ],
                            spacing: 12
                        ) {
                            ForEach(sortedPhotos) { photo in
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
            } else {
                // Если фото не загрузилось, показываем заглушку
                Color.black
                    .ignoresSafeArea()
                    .overlay(
                        Text("Image not found")
                            .foregroundColor(.white)
                    )
            }
        }
    }
}

// MARK: - Photo Grid Item
struct PhotoGridItem: View {
    let image: UIImage
    let day: Int
    let date: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width / 3 - 20, height: 120)
                .clipped()
                .cornerRadius(12)
            
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
            .padding(.horizontal, 4)
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
    let image: UIImage
    let day: Int
    let date: Date
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Верхняя панель с информацией
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
                
                // Фото
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black)
                
                Spacer()
            }
        }
    }
}
