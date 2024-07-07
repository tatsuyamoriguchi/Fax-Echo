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
        
        self
            .padding(.horizontal, 10)
            .padding(.vertical,5)
//            .background(Color.gray.opacity(0.1))
            .background(Color.white)
            .cornerRadius(10)
            .frame(minWidth: 250, minHeight: 40)
            .fixedSize(horizontal: true, vertical: false)
            .foregroundColor(.black)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .padding(.horizontal)
    }
    
    func credentialFieldStyle() -> some View {
        self.disableAutocorrection(true)
            .autocapitalization(.none)

    }
    
}
