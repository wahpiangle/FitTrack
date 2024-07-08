//
//  TemplateDetailView.swift
//  FitTrack Watch App
//
//  Created by Tan Quan Ming on 08/07/2024.
//

import SwiftUI

struct TemplateDetailView: View {
    var template: WorkoutTemplate?
    var body: some View {
        Image(template?.exerciseSetsInfo[0].exerciseImage ?? "arnold-press-muscles-1024x753-half")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
    }
}

#Preview {
    TemplateDetailView()
}
