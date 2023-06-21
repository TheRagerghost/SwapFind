import SwiftUI

struct FallingMoneyRandomized: View {
    var sign: String = "rublesign"
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            ZStack{
                ForEach(0..<9) { i in
                    RandomFallingCoin(sign: sign)
                }
            }
            Spacer()
        }
        .aspectRatio(1.0, contentMode: .fit)
        .frame(maxWidth: .infinity)
        .background(Color("Foreground"))
        .cornerRadius(8)
        .padding(.horizontal, 16)
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.04), radius: 6)
    }
}

struct FallingMoneyRandomized_Previews: PreviewProvider {
    static var previews: some View {
        FallingMoneyRandomized()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("Background"))
    }
}
