import SwiftUI

struct CurrencyItem: View {
    var label: String
    var sign: String
    var image: String
    @Binding var toggle: Bool
    var x: Float = 16.0
    var xAmount: Float = 1.0
    var y: Float = 8.0
    var yAmount: Float = 1.0
    var signBase: String = "australsign"
    
    var body: some View {
        HStack(spacing: 0) {
            HStack {
                AsyncImage(url: URL(string: "https://countryflagicons.com/FLAT/64/\(image).png"),
                           content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                }, placeholder: {
                    LoadingIndicator()
                })
            }
            .frame(width: 80, height: 48)
            .contentShape(Rectangle())
            .offset(x: -2)
            
            Text("\(label)")
                .font(.system(size: 16, weight: .semibold))
                .padding(.leading, 16)
            
            Spacer()

            HStack(spacing: 8){
                HStack(spacing: 8){
                    Image(systemName: sign)
                    Text(toggle ? "\(getInterRate(xAmount, yAmount))" : convertFormat(x, y, xAmount, yAmount))
                }
                .frame(maxWidth: 100)
                Image(systemName: "arrow.left.arrow.right")
                    .opacity(0.2)
                    .rotationEffect(Angle(degrees: toggle ? -180 : 0))
                    .animation(.default, value: toggle)
                HStack(spacing: 8){
                    Text(toggle ? convertFormat(y, x, yAmount, xAmount) : "\(getInterRate(yAmount, xAmount))")
                        .fixedSize(horizontal: false, vertical: true)
                    Image(systemName: signBase)
                }
                .frame(maxWidth: 100)
            }
            .font(.system(size: 16, weight: .regular))
            .frame(maxWidth: 220)
            .padding(.trailing, 8)
        }
        .frame(height: 48)
        .frame(maxWidth: .infinity)
        .background(Color("Foreground"))
        .cornerRadius(8)
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.04), radius: 6)
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

struct CurrencyItem_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(Exchange.currencyList, id: \.self) {
                    CurrencyItem(label: $0.name, sign: $0.symbol, image: $0.countryCode, toggle: .constant(true))
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity)
        .background(Color("Background"))
    }
}
