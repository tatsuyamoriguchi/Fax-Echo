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
            .cornerRadius(10)
            .border(.gray)
            .foregroundColor(.black)
            .background(Color.white)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)


    }
    
    func credentialFieldStyle() -> some View {
        self.disableAutocorrection(true)
            .autocapitalization(.none)

    }
    
}
