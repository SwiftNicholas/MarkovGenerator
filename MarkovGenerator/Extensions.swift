//
//  ArrayExt_RandomFromCount.swift
//  MarkovGenV1.0
//
//  Created by Nicholas Verrico on 5/28/17.
//  Copyright © 2017 Nicholas Verrico. All rights reserved.
//

import Foundation
import GameKit

extension Array{
    func randomElement<T:Any>()-> T{
        let index = self.count.random()
        if index > (self.count - 1) {return self[count - 1] as! T}
        else{return self[index] as! T}
    }
}


extension String{
    func isVowel() -> Bool{
        let vowels:[String] = ["a","e","i","o","u"]
        return vowels.contains(self)
    }

}


extension Int{
    func random()->Int{
      
        let randomSource = GKRandomSource.sharedRandom()
        let newRandomNumber = randomSource.nextInt(upperBound: self - 1)
        
      
        
        return (newRandomNumber)
    }

    
    
}

