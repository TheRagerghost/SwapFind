import SwiftUI

struct ExchangeView: View {
    @State var xCurrencyCode: String = "RUB"
    @State var yCurrencyCode: String = "USD"
    
    @State var xText: Float = 0.0
    @State var yText: Float = 0.0
    
    @FocusState var xFocus: Bool
    @FocusState var yFocus: Bool
    
    @State var lastYenValue: Float = 0.0
    
    @State var isFromTop: Bool = true
    
    let latestStamp: LatestRatesStamp? = Exchange.getLatestRates()
    
    var body: some View {
        NavigationView{
            VStack(spacing: 16){
                VStack(spacing: 0){
                    HStack(spacing: 0){
                        Image(systemName: Exchange.getCurrencyByCode(xCurrencyCode).symbol)
                            .font(.system(size: 32, weight: .semibold))
                            .frame(minWidth: 48)
                            .padding(.horizontal, 16)
                        
                        Button(action: {
                            xFocus = true
                            isFromTop = true
                        }){
                            ZStack {
                                if isFromTop {
                                    TextField("0", value: $xText, format: .number)
                                        .textFieldStyle(.plain)
                                        .focused($xFocus)
                                        .keyboardType(.decimalPad)
                                } else {
                                    Text(xValue)
                                }
                            }
                            .font(.system(size: 32, weight: .semibold))
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: .infinity, maxHeight: 64)
                            .padding(.horizontal, 8)
                            .overlay{
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(xFocus == true ? Color("Secondary") : Color(.sRGBLinear, white: 0, opacity: 0.1), lineWidth: 2)
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        
                        Spacer()
                        Picker("Первая валюта", selection: $xCurrencyCode) {
                            ForEach(xCurrencyList, id: \.self) {
                                Text("\($0.flag) \($0.code)").tag($0.code)
                            }
                        }
                        .pickerStyle(.inline)
                        .frame(maxWidth: 120, maxHeight: .infinity)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: 128)
                .background(Color("Foreground"))
                .cornerRadius(8)
                .padding(.horizontal, 16)
                .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.04), radius: 6)
                
                Image(systemName: "arrow.down")
                    .font(.system(size: 24, weight: .black))
                    .opacity(0.1)
                    .rotationEffect(Angle(degrees: isFromTop ? 0 : 180))
                    .animation(.default, value: isFromTop)
                
                VStack(spacing: 0){
                    HStack(spacing: 0){
                        Image(systemName: Exchange.getCurrencyByCode(yCurrencyCode).symbol)
                            .font(.system(size: 32, weight: .semibold))
                            .frame(minWidth: 48)
                            .padding(.horizontal, 16)
                        
                        Button(action: {
                            yFocus = true
                            isFromTop = false
                        }){
                            ZStack {
                                if !isFromTop {
                                    TextField("0", value: $yText, format: .number)
                                        .textFieldStyle(.plain)
                                        .focused($yFocus)
                                        .keyboardType(.decimalPad)
                                } else {
                                    Text(yValue)
                                }
                            }
                            .font(.system(size: 32, weight: .semibold))
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: .infinity, maxHeight: 64)
                            .padding(.horizontal, 8)
                            .overlay{
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(yFocus == true ? Color("Secondary") : Color(.sRGBLinear, white: 0, opacity: 0.1), lineWidth: 2)
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        
                        Spacer()
                        Picker("Вторая валюта", selection: $yCurrencyCode) {
                            ForEach(yCurrencyList, id: \.self) {
                                Text("\($0.flag) \($0.code)").tag($0.code)
                            }
                        }
                        .pickerStyle(.inline)
                        .frame(maxWidth: 120, maxHeight: .infinity)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: 128)
                .background(Color("Foreground"))
                .cornerRadius(8)
                .padding(.horizontal, 16)
                .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.04), radius: 6)
                
                HStack(spacing: 6){
                    Image(systemName: "clock.arrow.circlepath")
                    Text(latestStamp?.timestamp ?? Date.now, formatter: timeFormatter)
                }
                .font(.system(size: 16, weight: .bold))
                .opacity(0.1)
                .padding(.top, 16)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Color("Background")
                    .ignoresSafeArea()
                    .onTapGesture {
                        xFocus = false
                        yFocus = false
                    }
            }
            .navigationTitle("Обмен валюты")
        }
    }
    
    var xCurrencyList: [Currency] {
        return Exchange.currencyList.filter({ $0.code != yCurrencyCode })
    }
    
    var yCurrencyList: [Currency] {
        return Exchange.currencyList.filter({ $0.code != xCurrencyCode })
    }
    
    var xValue: String {
        let val: Float = yText * getRateByCode(xCurrencyCode) / getRateByCode(yCurrencyCode)
        return String(format: "%.2f", val)
    }
    
    var yValue: String {
        let val: Float = xText * getRateByCode(yCurrencyCode) / getRateByCode(xCurrencyCode)
        return String(format: "%.2f", val)
    }
    
    func getRateByCode(_ code: String) -> Float {
        return Float(latestStamp?.rates.first(where: {$0.code == code})?.rate ?? "0.0") ?? 0.0
    }
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm:ss dd.MM.yyyy"
        return formatter
    }()
}

struct ExchangeView_Previews: PreviewProvider {
    static var previews: some View {
        ExchangeView()
    }
}
