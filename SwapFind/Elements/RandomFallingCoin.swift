import SwiftUI

struct RandomFallingCoin: View {
    @State var isRotating: Bool = false
    var sign: String = "rublesign"
    let randX = CGFloat(Float.random(in: -200.0...200.0))
    let randSpread = CGFloat(Float.random(in: -5.0...5.0))
    let randSize = CGFloat(Int.random(in: 80...160))
    let randBrightness = CGFloat(Float.random(in: -0.1...0.1))
    
    var body: some View {
        Image(systemName: "\(sign).circle.fill")
            .font(.system(size: randSize))
            .foregroundColor(Color("Golden"))
            .brightness(randBrightness)
            .rotationEffect(Angle(degrees: isRotating ? 360 : 0))
            .offset(x: randX + randSpread,y: isRotating ? 360 : -360)
            .animation(
                .linear
                    .repeatForever(autoreverses: false)
                    .speed(0.2 * 120 / randSize), value: isRotating)
            .onAppear{
                isRotating = true
            }
    }
}

struct RandomFallingCoin_Previews: PreviewProvider {
    static var previews: some View {
        RandomFallingCoin()
    }
}
