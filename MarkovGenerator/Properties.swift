// #Insert Info Block

import Foundation

class MarkovGenerator{
   
    init(words:[String], genre: SourceGenre){
        
    self.transitionTable = UserDefaults.standard.object(forKey: "\(genre.rawValue)Transitions") as? [String : [String]] ??
        self.createTransitions(wordList: words, currentTable: self.transitionTable)
        
        print(transitionTable)
        
        if let matrix = UserDefaults.standard.object(forKey: "\(genre.rawValue)Occurences") as? [String : [String : Int]] {
            self.occurrenceMatrix = matrix
            
        } else {
            self.occurrenceMatrix = self.createMatrixes(characterSet: self.characterSet)
            self.occurrenceMatrix = self.generateOccurrences(transitionTable: self.transitionTable, matrix: self.occurrenceMatrix, genre: genre)
        }
      
        if let probabilities = UserDefaults.standard.object(forKey: "\(genre.rawValue)Probabilities") as? [String : [String : Int]] {
            self.probabilitiesMatrix = probabilities
        } else {
            self.probabilitiesMatrix = self.generateProbabilities(characterSet: self.characterSet, occurenceMatrix: self.occurrenceMatrix, genre: genre)
        }
        
      
        
        self.patterns = observePatterns(words: words)
        
    }
    
    
    
    // Randomize maximum length
    var minWordLength = 3
    var maxWordLength = 24
    
    let characterSet:[String] = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    let consonants:[String] = ["b","c","d","f","g","h","j","k","l","m","n","p","q","r","s","t","v","w","x","y","z"]
    let vowels:[String] = ["a","e","i","o","u"]
    
    var commonPairs:[String:[String]] = [
        "a":["d","l","n","r","s","t"],
        "d":["e","i","t"],
        "e":["a","d","l","n","r","s","t","w"],
        "h":["a","e","i"],
        "i":["n","s","t"],
        "l":["e"],
        "m":["e"],
        "n":["d","e","g","o","t"],
        "o":["f","n","r","t","u"],
        "r":["a","e","i","o"],
        "s":["a","e","h","o","t"],
        "t":["a","e","h","i","o","t"],
        "v":["e"],
        "w":["a"]
    ]
    
    var nonstandardPairs:[String] = ["aa", "bb", "cc", "dd", "ee", "ff", "gg", "hh", "ii", "jj", "kk", "ll", "mm", "oo", "nn", "pp", "qq", "uu", "ww", "xx", "yy", "zz", "rv","pm","dh","aa","cv","pg","zf","fn","uu","dk", "arar","tn", "bd", "bn", "wm", "dn","gz","zd","mk","ggg","sdd","lt", "rf","cnn","hce","lpl", "lmz","ps","pael","kgrz", "gn", "cn", "ii", "pd", "cepl", "nnid", "hts", "dd", "ht", "tta", "mrt", "atr", "bn", "gg", "fs", "bm", "flb", "rmi", "bb", "ff", "uhn", "hc", "mr", "dlc", "yv", "iji", "ef", "ijq", "tst", "mhr", "crri", "brtr", "eev", "hsd", "lsd", "cst", "lfl", "daml", "mx", "uev", "hpe", "wohd", "gd", "itt", "geg", "hh", "kakc","tc", "eei", "rxk", "xq", "llsmm", "jcl", "zm", "zc", "giuf", "uyy",  "zw", "vcl", "iwr", "dp", "prd", "uat", "wrda", "Dmag", "hp", "ttso", "Pv", "wrro", "yt", "ssm", "ssn", "fdr", "fuib", "nrb", "rg", "drml", "kc", "ml", "dl", "aa", "bb", "cc", "dd", "gg", "hh", "ii", "jj", "kk", "mm", "nn", "pp", "uu", "vv", "ww", "xx", "yy", "zz", "ss", "zl", "wr", "xm", "swn", "sn", "byc", "wg", "rr", "qzv", "fj", "eee", "ufz", "stt", "rc", "dt", "ooo", "fb", "hf", "ucl", "yhn", "nfo", "gm", "fipl", "lgl", "tsa", "sjej", "ipf", "eea", "fwk", "lbe", "lll", "llg", "rbfl", "rpn", "fda", "bg", "wn", "glpr", "ydrb", "fm", "qq", "uq", "tt", "zrzt", "ftt",
        "wd", // must have vowel before it
        "hs", // Only in last 2
        "lk", // Only after a vowel
        "heob" // Replace with hoeb,
        // "ets", has uses but not at begginning
        // "bk" insert vowel in middle
        // "fr" common, not in last 2
        // "avr" only in beginning and with a vowel after
        // "rb" Should not start with
        // "abve" should be consonant, vowel, consonant, vowel
    ]

    // # Update to pull value from initializer
    
    var transitionTable: [String:[String]] = [:]
    
    var occurrenceMatrix:[String:[String:Int]] = [:]
    var probabilitiesMatrix:[String:[String:Int]] = [:]
    var patterns:[[LetterType]] = []
    
  }

