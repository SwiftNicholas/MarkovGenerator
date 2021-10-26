

import SwiftUI
import UIKit

@main
struct MarkovGeneratorApp: App {
   
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

enum SourceGenre: String, CaseIterable, Identifiable {
    case LOTR
    case Pokemon
    case Naruto
    case Normal
    case Lands
    
    var id: String {self.rawValue}
    
    func loadArray(genre: SourceGenre)-> MarkovGenerator{
        switch genre {
       
        case .LOTR:
            return MarkovGenerator(words: Names.LOTR, genre: self)
        case .Pokemon:
            return MarkovGenerator(words: Names.pokemon, genre: self)
        case .Naruto:
            return MarkovGenerator(words: Names.Naruto, genre: self)
        case .Normal:
            return MarkovGenerator(words: Names2.k, genre: self)
        case .Lands:
            return MarkovGenerator(words: Names.Lands, genre: self)
        }
    }
}


struct ContentView: View {
    @State private var generatedName: String = ""
    @State private var length: String = ""
    @State private var genre: SourceGenre = .LOTR
    
    var body: some View {
        VStack{
            Form{
            if #available(iOS 15.0, *) {
                TextField("Length", text: $length, prompt: Text("Length of name"))
                    .keyboardType(.numberPad)
            } else {
                // Fallback on earlier versions
            }
            Text("\(generatedName)")
            Picker("Base names", selection: $genre){
                Text("People").tag(SourceGenre.Normal)
                Text("LOTR").tag(SourceGenre.LOTR)
                Text("Pokemon").tag(SourceGenre.Pokemon)
                Text("Lands").tag(SourceGenre.Lands)
                }
            }.pickerStyle(SegmentedPickerStyle())
            
        Button("New Name"){
            print(length)
            let source: MarkovGenerator = genre.loadArray(genre: genre)
            generatedName = source.generateWord(randomPattern: false, length: Int(length) ?? 6)
            
            }
        }
            
            
            
        }
    }



