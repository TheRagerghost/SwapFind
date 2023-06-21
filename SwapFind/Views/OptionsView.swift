import SwiftUI

struct OptionsView: View {
    @AppStorage("colorTheme") var colorTheme: Bool = false
    @AppStorage("baseCurrency") var baseCurrency: String = "RUB"
    
    var body: some View {
        NavigationView{
            VStack {
                List {
                    Section("Основные") {
                        Toggle("Темная тема", isOn: $colorTheme)
                            .listRowBackground(Color("Foreground"))
                            .tint(Color("Secondary"))
                        
                        Picker("Основная валюта", selection: $baseCurrency) {
                            ForEach(Exchange.currencyList, id: \.self) {
                                Text("\($0.flag) \($0.code)").tag($0.code)
                            }
                        }
                        .listRowBackground(Color("Foreground"))
                    }
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
            }
            .background(Color("Background"))
            .navigationTitle("Настройки")
        }
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView()
    }
}
