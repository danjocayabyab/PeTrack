//
//  PetCard.swift
//  PeTrack
//
//  Created by STUDENT on 9/2/25.
//

import SwiftUI

struct PetCard: View {
    let pet: Pet
    
    var body: some View {
        VStack(spacing: 12) {
            // Pet avatar placeholder
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "pawprint.fill")
                        .foregroundColor(.gray.opacity(0.6))
                        .font(.title2)
                )
            
            VStack(spacing: 4) {
                Text(pet.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(pet.breed)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                Text(pet.age)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
