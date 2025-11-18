//
//  ActivityRow.swift
//  PeTrack
//
//  Created by STUDENT on 9/2/25.
//

import SwiftUI

struct ActivityRow: View {
    let activity: Activity
    let onToggle: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onToggle) {
                Image(systemName: activity.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(activity.isCompleted ? .green : .gray.opacity(0.5))
                    .font(.title2)
            }
            .buttonStyle(PlainButtonStyle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(activity.title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                Text(activity.petName)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Text(activity.time)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                Text(activity.type.icon)
                    .font(.title2)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
}
