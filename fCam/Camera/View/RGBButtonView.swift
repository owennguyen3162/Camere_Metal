//
//  RGBButtonView.swift
//  fCam
//
//  Created by Muhammad M. Munir on 18/11/23.
//

import SwiftUI

struct ColorFilterItem: Identifiable {
    let id: Int
    var color: Color
}

struct RGBButtonView: View {
    private let colorFilters = [
        ColorFilterItem(id: 0, color: .red),
        ColorFilterItem(id: 1, color: .green),
        ColorFilterItem(id: 2, color: .blue),
    ]
    
    @State private var selectedIndex: Int?
    
    @Binding var selectedColor: Color
    
    var body: some View {
        HStack(spacing: 32) {
            ForEach(colorFilters) { colorFilter in
                Button(
                    action: {
                        filterButtonAction(index: colorFilter.id)
                    }
                ) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 70, height: 70)
                            .opacity(selectedIndex == colorFilter.id ? 1 : 0)
                        
                        Circle()
                            .fill(Color.black)
                            .frame(width: 62, height: 62)
                        
                        Circle()
                            .fill(colorFilter.color)
                            .frame(width: 54, height: 54)
                    }
                }
            }
        }
    }
    
    private func filterButtonAction(index: Int) {
        if let selectedIndex, selectedIndex == index {
            self.selectedIndex = nil
            selectedColor = Color.clear
        } else {
            selectedIndex = index
            selectedColor = colorFilters[index].color
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        RGBButtonView(selectedColor: .constant(Color.clear))
    }
}
