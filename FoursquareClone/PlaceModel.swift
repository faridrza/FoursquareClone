//
//  PlaceModel.swift
//  FoursquareClone
//
//  Created by Farid Rzayev on 30.11.21.
//

import Foundation
import UIKit

class PlaceModel {
    
    static let shared = PlaceModel()
    
    var PlaceNameModel = ""
    var PlaceAtmosphereModel = ""
    var PlaceTypeModel = ""
    var PlaceImageModel = UIImage()
    
    private init(){}
}
