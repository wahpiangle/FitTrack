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
    var bodyPart: String
    var category: String
    var sets: Array<ExerciseSets>
    
    init(exerciseId: Int, exerciseName: String, bodyPart: String, category: String, sets: Array<ExerciseSets>) {
        self.exerciseId = exerciseId
        self.exerciseName = exerciseName
        self.bodyPart = bodyPart
        self.category = category
        self.sets = sets
    }
}
