import SwiftUI

struct BottomMenu: View {
    @Binding var selectedButton: Int
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: 8) {
                Rectangle()
                    .frame(maxHeight: 2)
                    .foregroundColor(.black)
                    .opacity(0.1)
                HStack(spacing: 28) {
                    MenuButton(id: 1, label: "Обзор", icon: "magnifyingglass", selection: $selectedButton)
                    MenuButton(id: 2, label: "Обмен", icon: "arrow.triangle.2.circlepath", selection: $selectedButton)
                    MenuButton(id: 3, label: "Настройки", icon: "gearshape", selection: $selectedButton)
                }
                .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity)
            .background(Color("Foreground"))
        }
        .ignoresSafeArea()
    }
}

struct BottomMenu_Previews: PreviewProvider {
    static var previews: some View {
        BottomMenu(selectedButton: .constant(1))
    }
}
