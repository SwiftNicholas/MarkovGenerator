

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


struct ContentView: View {
    @State private var generatedName: String = ""
    @State private var length: String = ""
    var people = MarkovGenerator(words:Names2.k)
    var body: some View {
        VStack{
            if #available(iOS 15.0, *) {
                TextField("Length", text: $length, prompt: Text("Length of name"))
                    .keyboardType(.numberPad)
            } else {
                // Fallback on earlier versions
            }
            Text("\(generatedName)")
            Button("New Name"){
                generatedName = people.generateWord(randomPattern: true, length: Int(length) ?? 5)
            }
            
            
            
        }
    }
}


