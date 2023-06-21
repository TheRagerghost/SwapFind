import SwiftUI

struct OverviewView: View {
    @AppStorage("baseCurrency") var baseCurrency: String = "RUB"
    
    @State var searchText: String = ""
    @State var valueSwitch: Bool = false
    
    @State var latestStamp: LatestRatesStamp?
    
    var body: some View {
        NavigationView{
            ScrollView {
                VStack(spacing: 16) {
                    if filterCurrencies().isEmpty {
                        Text("Список пуст.")
                    } else {
                        ForEach(filterCurrencies(), id: \.self) { c in
                            NavigationLink{
                                CurrencyDetail(currency: c, currFrom: Exchange.getCurrencyByCode(baseCurrency).symbol, x: getRateByCode(c.code), xAmount: getAmountByCode(c.code), y: getRateByCode(baseCurrency), yAmount: getAmountByCode(baseCurrency))
                            } label: {
                                CurrencyItem(label: c.name, sign: c.symbol, image: c.countryCode, toggle: $valueSwitch, x: getRateByCode(c.code), xAmount: getAmountByCode(c.code), y: getRateByCode(baseCurrency), yAmount: getAmountByCode(baseCurrency), signBase: Exchange.getCurrencyByCode(baseCurrency).symbol)
                            }
                            .buttonStyle(.plain)
                        }
                        
                        HStack(spacing: 6){
                            Image(systemName: "clock.arrow.circlepath")
                            Text(latestStamp?.timestamp ?? Date.now, formatter: timeFormatter)
                        }
                        .font(.system(size: 16, weight: .bold))
                        .opacity(0.1)
                        .padding(.top, 16)
                    }
                }
                .padding()
                .padding(.bottom, 72)
            }
            .frame(maxWidth: .infinity)
            .background(Color("Background"))
            .navigationTitle("\(Exchange.getCurrencyByCode(baseCurrency).name)  \(Exchange.getCurrencyByCode(baseCurrency).flag)")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Поиск")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            valueSwitch.toggle()
                        }
                    }) {
                        Label("Add Item", systemImage: "arrow.left.arrow.right")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color("Primary"))
                            .rotationEffect(Angle(degrees: valueSwitch ? -180 : 0))
                            .animation(.default, value: valueSwitch)
                    }
                }
            }
        }
        .onAppear{
            latestStamp = Exchange.getLatestRates()
            
            if latestStamp == nil  {
                Task {
                    latestStamp = await Exchange.syncLatestRates()
                }
            }
        }
        .refreshable {
            Task {
                latestStamp = await Exchange.syncLatestRates()
            }
        }
    }
    
    func filterCurrencies() -> [Currency] {
        
        let newList = Exchange.currencyList.filter({$0.code != baseCurrency})
        
        if searchText != "" {
            return newList.filter({
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.code.lowercased().contains(searchText.lowercased())
            })
        }
        return newList
    }
    
    func getRateByCode(_ code: String) -> Float {
        return Float(latestStamp?.rates.first(where: {$0.code == code})?.rate ?? "1.0") ?? 1.0
    }
    
    func getAmountByCode(_ code: String) -> Float {
        return Exchange.currencyList.first(where: {$0.code == code})?.amount ?? 1.0
    }
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm:ss dd.MM.yyyy"
        return formatter
    }()
}

struct OverviewView_Previews: PreviewProvider {
    static var previews: some View {
        OverviewView()
    }
}
