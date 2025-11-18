//
//  EditPetSheet.swift
//  PeTrack
//
//  Created by STUDENT on 10/30/25.
//

import SwiftUI
import PhotosUI

struct EditPetSheet: View {
    let original: Pet
    var onSave: (Pet) -> Void
    @Environment(\.dismiss) private var dismiss

    // Prefill state from original
    @State private var name: String
    @State private var breed: String
    @State private var gender: String
    @State private var ageYears: Int
    @State private var weightKg: Double
    @State private var colorText: String
    @State private var photoItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?

    init(original: Pet, onSave: @escaping (Pet) -> Void) {
        self.original = original
        self.onSave = onSave
        _name = State(initialValue: original.name)
        _breed = State(initialValue: original.breed)
        _gender = State(initialValue: original.gender)
        _ageYears = State(initialValue: original.ageInYears)
        // parse "xx.x kg"
        let kg = Double(original.weight.replacingOccurrences(of: " kg", with: "")) ?? 0.5
        _weightKg = State(initialValue: kg)
        _colorText = State(initialValue: original.avatarColor.capitalized)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Text("Edit Pet")
                        .font(.system(size: 24, weight: .bold))
                        .padding(.top, 8)
                    Text("Update the details and save your changes")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)

                    // Basic Information
                    Card {
                        HStack(spacing: 8) {
                            Image(systemName: "person.crop.circle").foregroundColor(.blue)
                            Text("Basic Information").font(.system(size: 16, weight: .semibold))
                            Spacer()
                        }
                        VStack(alignment: .leading, spacing: 12) {
                            LabeledField("Pet Name") {
                                TextField("Enter Pet Name", text: $name).textFieldStyle(SoftFieldStyle())
                            }
                            LabeledField("Breed") {
                                TextField("Enter Breed", text: $breed).textFieldStyle(SoftFieldStyle())
                            }
                            LabeledField("Gender") {
                                HStack(spacing: 16) {
                                    SelectablePill(title: "Male",   isSelected: gender == "Male")   { gender = "Male" }
                                    SelectablePill(title: "Female", isSelected: gender == "Female") { gender = "Female" }
                                    Spacer()
                                }
                            }
                        }
                    }
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.blue.opacity(0.5), lineWidth: 2))

                    // Physical Details
                    Card {
                        HStack(spacing: 8) {
                            Image(systemName: "pawprint.circle").foregroundColor(.blue)
                            Text("Physical Details").font(.system(size: 16, weight: .semibold))
                            Spacer()
                        }
                        VStack(alignment: .leading, spacing: 16) {
                            LabeledField("Age") {
                                HStack(spacing: 14) {
                                    RoundIconButton(systemName: "minus") { ageYears = max(0, ageYears - 1) }
                                    Text("\(ageYears)").font(.system(size: 16, weight: .medium)).frame(minWidth: 28)
                                    RoundIconButton(systemName: "plus") { ageYears += 1 }
                                    Spacer()
                                }
                            }
                            LabeledField("Weight") {
                                VStack(alignment: .leading, spacing: 8) {
                                    Slider(value: $weightKg, in: 0.5...50, step: 0.5)
                                    HStack {
                                        Text("0.5 kg").font(.system(size: 12)).foregroundColor(.gray)
                                        Spacer()
                                        Text("50 kg").font(.system(size: 12)).foregroundColor(.gray)
                                    }
                                }
                            }
                            LabeledField("Color") {
                                TextField("Enter Color", text: $colorText).textFieldStyle(SoftFieldStyle())
                            }
                        }
                    }

                    // Photo (optional)
                    Card {
                        HStack(spacing: 8) {
                            Image(systemName: "camera.circle").foregroundColor(.blue)
                            Text("Photo").font(.system(size: 16, weight: .semibold))
                            Spacer()
                        }
                        HStack(spacing: 16) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.15))
                                if let img = selectedImage {
                                    Image(uiImage: img).resizable().scaledToFill()
                                } else {
                                    Image(systemName: "photo.on.rectangle.angled")
                                        .font(.system(size: 24)).foregroundColor(.gray)
                                }
                            }
                            .frame(width: 64, height: 64).clipped().cornerRadius(10)

                            PhotosPicker(selection: $photoItem, matching: .images, photoLibrary: .shared()) {
                                Text("Choose Photo")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(.primary)
                                    .padding(.horizontal, 16).padding(.vertical, 10)
                                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.35)))
                            }
                            .onChange(of: photoItem) { oldItem, newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                                       let img = UIImage(data: data) { selectedImage = img }
                                }
                            }

                            Text("Optional").font(.system(size: 13)).foregroundColor(.gray)
                            Spacer()
                        }
                    }

                    // Actions
                    HStack(spacing: 16) {
                        Button(action: handleSave) {
                            Text("Save Changes")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity).padding()
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.black))
                        }
                        Button(action: { dismiss() }) {
                            Text("Cancel")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity).padding()
                                .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.35)))
                        }
                    }
                    .padding(.bottom, 24)
                }
                .padding(.horizontal)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark").font(.system(size: 16, weight: .semibold)).foregroundColor(.primary)
                    }
                }
            }
        }
    }

    private func handleSave() {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        guard !breed.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        guard gender == "Male" || gender == "Female" else { return }

        // Update the original pet's properties directly
        original.name = name
        original.breed = breed
        original.gender = gender
        original.ageInYears = ageYears
        original.age = "\(ageYears) year" + (ageYears == 1 ? "" : "s") + " old"
        original.weight = String(format: "%.1f kg", weightKg)
        original.avatarColor = normalizedAvatarColor(from: colorText)
        
        // Call onSave with the updated pet
        onSave(original)
        dismiss()
    }

    private func normalizedAvatarColor(from input: String) -> String {
        let key = input.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        switch key {
        case "orange", "amber": return "orange"
        case "gray", "grey", "silver": return "gray"
        case "brown", "tan": return "brown"
        default: return "blue"
        }
    }
}

// Reuse helpers from AddPetSheet:
private struct Card<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View {
        VStack(alignment: .leading, spacing: 16) { content }
            .padding(16)
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.black.opacity(0.08)))
            .shadow(color: .black.opacity(0.03), radius: 2, x: 0, y: 1)
    }
}
private struct LabeledField<Content: View>: View {
    var title: String; @ViewBuilder var content: Content
    init(_ title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title; self.content = content()
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.system(size: 14, weight: .semibold))
            content
        }
    }
}
private struct SoftFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration.padding(.horizontal, 14).padding(.vertical, 12)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.12)))
    }
}
private struct SelectablePill: View {
    let title: String; let isSelected: Bool; let onTap: () -> Void
    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.primary)
                .frame(width: 150)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? Color.blue : Color.gray.opacity(0.35), lineWidth: isSelected ? 2 : 1)
                )
        }.buttonStyle(.plain)
    }
}
private struct RoundIconButton: View {
    let systemName: String; let action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
                .frame(width: 32, height: 32)
                .background(RoundedRectangle(cornerRadius: 6).stroke(Color.gray.opacity(0.35)))
        }.buttonStyle(.plain)
    }
}
