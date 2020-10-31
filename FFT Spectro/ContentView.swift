//
//  ContentView.swift
//  FFT Spectro
//
//  Created by Anadyr on 5/24/20.
//  Copyright © 2020 Anadyr. All rights reserved.
//

import SwiftUI





struct ContentView: View {
   
    @State var difference = "hi"
    @State var i = 0
    var body: some View {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1/20) {
            self.i += 1
        }
        
        return VStack {
            Text(spectral.note.note)
            Text(spectral.note.difference)
            Text(String(repeating: " ", count: i % 16 + 1))
        }
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}
