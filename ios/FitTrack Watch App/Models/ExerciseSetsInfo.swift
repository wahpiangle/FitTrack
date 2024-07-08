//
//  ExercisesSetsInfo.swift
//  FitTrack Watch App
//
//  Created by Tan Quan Ming on 16/06/2024.
//

import Foundation
class ExerciseSetsInfo {
    var exerciseId: Int
    var exerciseName: String
    var exerciseImage: String
    var bodyPart: String
    var category: String
    var sets: Array<ExerciseSets>
    
    init(exerciseId: Int, exerciseName: String, exerciseImage: String, bodyPart: String, category: String, sets: Array<ExerciseSets>) {
        self.exerciseId = exerciseId
        self.exerciseName = exerciseName
        self.exerciseImage = exerciseImage
        self.bodyPart = bodyPart
        self.category = category
        self.sets = sets
    }
}
