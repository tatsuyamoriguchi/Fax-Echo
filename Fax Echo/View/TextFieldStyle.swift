//
//  TextFieldStyle.swift
//  Fax Echo
//
//  Created by Tatsuya Moriguchi on 4/23/24.
//

import Foundation
import SwiftUI

extension View {
    func textFieldStyle() -> some View {
        self.frame(minWidth: 250)
            .fixedSize(horizontal: true, vertical: false)
        
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .background(Color.white)
            .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .background(RoundedRectangle(cornerRadius: 20).fill(Color(red: 237/255, green: 237/255, blue: 237/255)))


    }
    
    func credentialFieldStyle() -> some View {
        self.disableAutocorrection(true)
            .autocapitalization(.none)

    }
    
}
