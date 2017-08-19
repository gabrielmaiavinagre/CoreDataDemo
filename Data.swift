//
//  Data.swift
//  CoreDataDemo
//
//  Created by Gabriel Maia Vinagre Costa on 18/08/17.
//  Copyright © 2017 gabrielVinagre. All rights reserved.
//

import Foundation

final class DataAPI {
    
    static let shared = DataAPI()
    
    var people:[Person] = []
    
    private init(){
        
    }
    
}
