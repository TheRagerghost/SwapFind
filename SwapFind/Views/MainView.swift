import SwiftUI

struct MainView: View {
    @State var selectedView: Int = 1
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                switch selectedView {
                    case 1:
                        OverviewView()
                            .transition(.opacity)
                        
                    case 2:
                        ExchangeView()
                            .transition(.opacity)
                        
                    case 3:
                        OptionsView()
                            .transition(.opacity)
                        
                    default:
                        Text("Default")
                }
            }
            
            BottomMenu(selectedButton: $selectedView)
        }
        .background(Color("Background"))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
