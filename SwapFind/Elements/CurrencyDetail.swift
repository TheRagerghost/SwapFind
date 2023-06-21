import SwiftUI

struct CurrencyDetail: View {
    var currency: Currency
    var currFrom: String
    
    var x: Float = 10.0
    var xAmount: Float = 1.0
    var y: Float = 10.0
    var yAmount: Float = 1.0
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                HStack(spacing: 8) {
                    Image(systemName: currency.symbol)
                    Spacer()
                    Text("\(getInterRate(xAmount, yAmount))")
                    Spacer()
                }
                .padding(.leading, 24)
                Image(systemName: "arrow.left.arrow.right")
                    .opacity(0.2)
                HStack(spacing: 8) {
                    Spacer()
                    Text("\(convertFormat(y, x, yAmount, xAmount))")
                    Spacer()
                    Image(systemName: currFrom)
                }
                .padding(.trailing, 24)
            }
            .font(.system(size: 20, weight: .semibold))
            .frame(maxWidth: .infinity, maxHeight: 80)
            .background(Color("Foreground"))
            .cornerRadius(8)
            .padding(.horizontal, 16)
            .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.04), radius: 6)
            
            FallingMoneyRandomized(sign: currency.symbol)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Background"))
        .navigationTitle(currency.name)
    }
    
    func convertFormat(_ x: Float, _ y: Float, _ xA: Float = 1.0, _ yA: Float = 1.0) -> String {
        
        var flt: Float = 0.0
        if y != 0.0 {
            flt = x * Float(getInterRate(yA, xA)) / y
        }
        
        let str = flt >= 100.0 ? String(format: "%.1f", flt) : String(format: "%.2f", flt)
        return "\(str)"
    }
    
    func getInterRate(_ x: Float, _ y: Float) -> Int {
        let iRate = Int(x / y)
        if iRate == 0 { return 1 }
        return iRate
    }
}

struct CurrencyDetail_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyDetail(currency: Currency("Рубль", "RUB", "RU", "rublesign", "🇷🇺"), currFrom: "dollarsign")
    }
}
