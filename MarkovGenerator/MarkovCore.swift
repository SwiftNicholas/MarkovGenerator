//
//  ExtensionMarkov-ReferenceSets.swift
//  wordplay
//
//  Created by Nicholas Verrico on 5/27/17.
//  Copyright © 2017 Nicholas Verrico. All rights reserved.
//

import Foundation

extension MarkovGenerator{
    
    internal func generateOccurrences(transitionTable:[String:[String]], matrix:[String:[String:Int]], genre: SourceGenre)->[String:[String:Int]]{
        var updatedMatrix:[String:[String:Int]] = matrix
  
        for character in transitionTable.keys{
            let currentTransitions = transitionTable[String(character)]!
            var matrixRow = matrix[character]!
            for character in currentTransitions{
                matrixRow.updateValue(currentTransitions.filter{$0 == character}.count, forKey: character)
            }
            updatedMatrix.updateValue(matrixRow, forKey: character)
        }
        
        UserDefaults.standard.set(updatedMatrix, forKey: "\(genre.rawValue)Occurences")
        return updatedMatrix
    }
}


extension MarkovGenerator{
    
    // Returns character matrix [Character:[Character:Int] for each character in character set
   internal func createMatrixes(characterSet:[String])->[String:[String:Int]]{
        
        var matrix:[String:[String:Int]] = [:]
        var valueDict:[String:Int] = [:]
        for letter in characterSet{
            
            for letter in characterSet{
                valueDict.updateValue(0, forKey:letter)
            }
            
            
            matrix.updateValue(valueDict, forKey: letter)
        }
       
        return matrix
    }
}

extension MarkovGenerator{
    
       
    enum LetterType: StringLiteralType{
        case V = "V"
        case C = "C"
    }
    
  internal func nextCharacter(currentLetter:String, nextTypeInPattern:LetterType)-> String{
    
        var transitionTable:[String:[String]] = self.transitionTable
        var probabilitiesMatrix:[String:[String:Int]] = self.probabilitiesMatrix
    
        let consonants:[String] = self.consonants
        let vowels:[String] = self.vowels
    
    
        guard currentLetter != "q" else{
            return "u"
        }
    
        let possibleTransitions = transitionTable[currentLetter]
        
        var vowelTransitionArray: [String] = []
        var consonantTransitionArray: [String] = []

        guard possibleTransitions != nil else{
            var result:String
            nextTypeInPattern == .V ? (result = vowels.randomElement()) : (result = consonants.randomElement())
            return result
        }
    
        var matrixRow = probabilitiesMatrix[currentLetter]!
    
        
        for (key,value) in matrixRow{
            if value == 0 || ((key == "$") || (self.characterSet.contains(key) == false)) {
                matrixRow.removeValue(forKey: key)
                continue
            } else {
                let repeatedValue = repeatElement(key, count: value)
                if key.isVowel() {
                    vowelTransitionArray.append(contentsOf: repeatedValue)
                } else {
                    consonantTransitionArray.append(contentsOf: repeatedValue)
                }
            }
        }
    
        var adjustedVowels = vowelTransitionArray
        var adjustedConsonants = consonantTransitionArray
        
        adjustedVowels = adjustedVowels.filter({$0 != currentLetter})
        adjustedConsonants = adjustedConsonants.filter({$0 != currentLetter})
        
        var result: String
    
        if adjustedVowels.count == 0 && adjustedConsonants.count == 0 {return "*"}
        if nextTypeInPattern == .C && adjustedConsonants.count == 0 {return "*"}
        if nextTypeInPattern == .V && adjustedVowels.count == 0 {return "*"}
        nextTypeInPattern == .V ? (result = adjustedVowels.randomElement()) : (result = adjustedConsonants.randomElement())
    
        return result
    
    }
}


extension MarkovGenerator{

   internal func observePatterns(words:[String])-> [[LetterType]]{
    
    let characterArrays = words.map({([String]($0.map {(Character) -> String in
        return String(Character)}))})
        var patternsMatrix:[[LetterType]] = []
        
        _ = characterArrays.map({
            (word: [String]) in
            
            var pattern:[LetterType] = []
           
            _ = word.map({
                (letter:String) in
                letter.isVowel() ? (pattern.append(LetterType.V)) : (pattern.append(LetterType.C))
            })
            
            patternsMatrix.contains(where: {$0 == pattern}) ? () : (patternsMatrix.append(pattern))
           
        })
        
       
        return patternsMatrix
    }
}



extension MarkovGenerator{
    
    
    /**
        Using occurences generates probabilities. Converts probabilities into whole numbers for distribution in array.
        Example: .556 = 6 (values in array of ~100 values) for better distribution.
        Passsed to distribution function to populate array of values.
    */
    
    internal func generateProbabilities(characterSet:[String],occurenceMatrix:[String:[String:Int]], genre:SourceGenre)->[String:[String:Int]]{
        var probabilities:[String:[String:Int]] = occurenceMatrix
      
        // Access character
        // Access characters list of characters
        // Access count for value in list
        
        for (primaryCharacter, characterList) in occurenceMatrix{
            let totalPossible = characterList.values.reduce(0, +)
      
            var matrixRow:[String:Int] = [:]
            for (character, occurences) in characterList{
                let probability: Float = Float(occurences)/Float(totalPossible)
                if probability > 0.0000001{
                    var formatted:[Character] = Array(String(format: "%.2f", probability))
             
                    formatted.remove(at: 0)
                    formatted.remove(at: 0)
                    let wholeInt = Int(String(formatted))!
         
                    matrixRow.updateValue(wholeInt, forKey: character)
                    
                    probabilities.updateValue(matrixRow, forKey: primaryCharacter)
                }
              
            }
        }
       UserDefaults.standard.set(probabilities, forKey: "\(genre.rawValue)Probabilities")
        return probabilities
    }
}


extension MarkovGenerator{
    
    internal func randomCharacter(characterSet:[String]) -> String {
        return characterSet.randomElement()
    }
}

extension MarkovGenerator{
    // Creates transitions table for each character from each word;
    // transitions can be considered the list of 'allowable' characters that follow after a given character
    internal func createTransitions(wordList:[String], currentTable:[String:[String]])->[String:[String]] {
        
        var transitionsTable:[String:[String]] = currentTable
        
        var mappedStrings:[[String]]
        mappedStrings = wordList.map({([String]($0.map {(Character) -> String in
            return String(Character)}))})
       
        
        
        _ = mappedStrings.map({
            (word: [String]) in
            
            var characterTransitions:[String] = []
            var letterIndex = 0
            _ = word.map({
                (letter:String) in
                guard characterSet.contains(letter) else{return}
                characterTransitions = transitionsTable[String(letter)] ?? []
                
                var nextLetter:String
                // $ used to denote no possible characters
                letterIndex < word.count - 1 ?
                    (nextLetter = word[letterIndex+1]) :
                    (nextLetter = "$")
                
                characterTransitions.append(String(nextLetter))
                letterIndex = 0
                transitionsTable[String(letter)] = characterTransitions
                
                })
           
        })
        
        UserDefaults.standard.set(transitionsTable, forKey: "Transitions")
        return transitionsTable
    }
}




extension MarkovGenerator{

    
    func generateWord(randomPattern: Bool, length: Int) -> String{
        var result:[String] = []
        
        var currentCharacter:String = "#"
        var currentPattern: [LetterType] = [.C,.V,.C,.V,.V]
        
        if randomPattern {
            for _ in 0..<length{
                let type = Int().random()
                if type % 2 == 0 {
                    currentPattern.append(.C)
                } else {
                    currentPattern.append(.V)
                }
            }
        }
        
     
        repeat {
    
        
        for (_, letterType) in currentPattern.enumerated(){
            var repeated: Int = 0
            repeat {
                
            if currentCharacter == "#"{
                currentCharacter = nextCharacter(currentLetter: currentCharacter, nextTypeInPattern: letterType)
            }
            
           else if currentCharacter == "$" {
                currentCharacter = nextCharacter(currentLetter: currentCharacter, nextTypeInPattern: letterType)
                
                
            } else {
                currentCharacter = nextCharacter(currentLetter: currentCharacter, nextTypeInPattern: letterType)
            }
                if repeated >= 10 {currentCharacter = randomCharacter(characterSet: self.characterSet); repeated = 0}
                repeated += 1
            } while currentCharacter == result.last
            
            if currentCharacter == "*"{break}
            result.append(currentCharacter)
        }
        
            var finalString = result.reduce("",+)
        
           
        func replaceCharacters(char:String, lastLetter:String, nextType: LetterType){
            let index = finalString.localizedStandardRange(of: char)
            var newCharacters:[String] = []
            let characters = (char.components(separatedBy: ""))
            for _ in characters{
                if newCharacters.count > 0{
                  
                    newCharacters.append((newCharacters.last!))
                } else {
                
                    
                    
                    var newCharacter = nextCharacter(currentLetter: lastLetter, nextTypeInPattern: nextType)
                   
                    var loop = true
                    repeat {
                        newCharacter = nextCharacter(currentLetter: lastLetter, nextTypeInPattern: nextType)
                   
                        if characters.contains(newCharacter){loop = true}
                        if newCharacter == "*"{break}
                        else {loop = false; newCharacters.append(newCharacter)}
                    }while loop
                  
                    
                    
                }
            }
        
            finalString = finalString.replacingCharacters(in: index!, with: newCharacters.reduce("",+))
        }
        
        var checkAgain = false
        repeat {
            checkAgain = false
            for pair in nonstandardPairs{
                
                guard finalString.contains(pair) else {
                    checkAgain = false
                    continue
                }
                
                var letterIndex:Int? = result.firstIndex(of: pair)
       
                if letterIndex != nil && letterIndex! <= 0 {
                    letterIndex = 0
                } else if letterIndex != nil {
                    letterIndex! -= 1
                }
                var previousLetter:String
                var patternPosition:LetterType = .V
                letterIndex != nil ? (previousLetter = result[letterIndex!]) : ( previousLetter = result[0])
                letterIndex != nil ? (patternPosition = currentPattern[letterIndex! + 1]) : (patternPosition = currentPattern[1])
                
                replaceCharacters(char: pair, lastLetter: previousLetter, nextType: patternPosition)
           
                checkAgain = true
            }
            
        } while checkAgain == true
       
            
            if result.count > 3 {return finalString.capitalized}
            
        } while result.count <= 3
        
       
         return result.reduce("",+)
    
    }
    
    


}
