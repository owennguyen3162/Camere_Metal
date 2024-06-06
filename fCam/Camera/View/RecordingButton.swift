//
//  RecordingButton.swift
//  fCam
//
//  Created by Muhammad M. Munir on 18/11/23.
//

import SwiftUI

struct RecordingButton: View {
    @Binding var isRecording: Bool
    var action: () -> Void = {}
    
    var body: some View {
        Button(action: {
            isRecording.toggle()
            action()
        }) {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 70, height: 70)
                
                Circle()
                    .fill(Color.black)
                    .frame(width: 62, height: 62)
                
                if isRecording {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.red)
                        .frame(width: 25, height: 25)
                } else {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 54, height: 54)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    RecordingButton(isRecording: .constant(false))
}
