//
//  PetListCard.swift
//  PeTrack
//
//  Created by STUDENT on 9/2/25.
//

import SwiftUI

struct PetListCard: View {
    let pet: Pet
    let onMenuTap: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Pet Avatar
            Circle()
                .fill(avatarColor)
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: pet.breed.lowercased().contains("cat") ? "pawprint.fill" : "pawprint.fill")
                        .foregroundColor(.white)
                        .font(.title3)
                )
            
            // Pet Information
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(pet.name)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("\(pet.ageInYears) years")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }
                
                Text(pet.breed)
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                
                HStack(spacing: 16) {
                    Text(pet.gender)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    Circle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 4, height: 4)
                    
                    Text(pet.weight)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            // Menu Button
            Button(action: onMenuTap) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                    .rotationEffect(.degrees(90))
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private var avatarColor: Color {
        switch pet.avatarColor {
        case "orange":
            return Color.orange
        case "gray":
            return Color.gray.opacity(0.6)
        case "brown":
            return Color.brown
        default:
            return Color.blue
        }
    }
}
