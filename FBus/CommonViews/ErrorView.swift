//
//  ErrorView.swift
//  FB
//
//  Created by Aftab Ahmed on 7/19/19.
//  Copyright © 2019 FAMCO. All rights reserved.
//

import SwiftUI

struct ErrorView : View {
    
    var errortext: String
    
    var body: some View {
        Text("\(errortext)")
    }
}

#if DEBUG
struct Error_Previews : PreviewProvider {
    static var previews: some View {
        ErrorView(errortext: "Error Getting Response! Please try again in a while.")
    }
}
#endif
