import SwiftUI

struct LoadingIndicator: View {
    @State var isLoading = false
    
    var body: some View {
        Image(systemName: "arrow.clockwise.circle.fill")
            .font(.system(size: 24))
            .foregroundColor(Color("Secondary"))
            .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
            .animation(.linear
                .repeatForever(autoreverses: false), value: isLoading)
            .onAppear{
                isLoading = true
            }
    }
}

struct LoadingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        LoadingIndicator()
    }
}
