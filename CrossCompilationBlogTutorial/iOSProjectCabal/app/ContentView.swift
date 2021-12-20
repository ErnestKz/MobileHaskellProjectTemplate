//
//  ContentView.swift
//  app
//
//  Created by Ernests Kuznecovs on 16/12/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
       Text(String(cString: hello())).padding()
//       Text(String("hello")).padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
