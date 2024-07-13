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
        ScrollView{
            VStack(alignment: .leading) {
                Text(template?.title ?? "")
                    .font(.headline)
                Text(template?.note ?? "")
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
                Spacer()
                ForEach(template?.exerciseSetsInfo ?? [], id: \.exerciseId) { exerciseSetInfo in
                    HStack{
                        VStack(alignment: .leading) {
                            Text(exerciseSetInfo.exerciseName)
                                .font(.headline)
                            
                        }
                        Spacer()
                        Image(template?.exerciseSetsInfo[0].exerciseImage ?? "")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 75, height: 75)
                    }
                }
                Button(action:{}, label:
                        {
                    Text("Start Workout")
                        .fontWeight(.semibold)
                        .foregroundColor(Color.black)
                })
                .tint(Color.theme.secondary)
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 10))
                .controlSize(.mini)
            }
        }
    }
} 

#Preview {
    TemplateDetailView(
        template: WorkoutTemplate(id: 1, title: "Test", note: "Test note", exerciseSetsInfo: [
           ExerciseSetsInfo(exerciseId: 1, exerciseName: "Test name ex", exerciseImage: "belt-squat-muscles-1024x581-half", bodyPart: "Test bodypart", category: "category", sets: [
               ExerciseSets(id: 1, reps: 1, weight: 1.0)
           ]),
           ExerciseSetsInfo(exerciseId: 1, exerciseName: "Test", exerciseImage: "belt-squat-muscles-1024x581-half", bodyPart: "Test", category: "Test", sets: [
               ExerciseSets(id: 1, reps: 1, weight: 1.0)
           ])
       ]))
}
