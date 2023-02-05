//
//  SettingsView.swift
//  cryptofolio
//
//  Created by Marshall Kurniawan on 11/05/22.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var userSettings = UserSettings()
    
    var body: some View {
        Form{
            NavigationLink{
                Form{
                    TextField("User Name", text: $userSettings.userName)
                }.navigationTitle("User Name").navigationBarTitleDisplayMode(.inline)
            }label:{
                HStack{
                    Text("User Name")
                    Spacer()
                    Text(UserDefaults.standard.string(forKey: "userName") ?? "").foregroundColor(.secondary)
                }
            }
            Picker(selection: $userSettings.preferredCurrency, label: Text("Preferred Currency")) {
                Text("USD").tag("usd")
                Text("IDR").tag("idr")
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
