import SwiftUI

struct MenuButton: View {
    var id: Int = 0
    var label: String = "Default"
    var icon: String = "terminal"
    @Binding var selection: Int
    var baseColor: Color = .gray
    var activeColor: Color = Color("Primary")
    
    var body: some View {
        Button(action: {
            withAnimation {
                selection = id
            }
        }){
            VStack(spacing: 4){
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                Text(label)
                    .font(.system(size: 12, weight: .regular))
            }
            .foregroundColor(isActive() ? activeColor : baseColor)
            .frame(minWidth: 64, maxHeight: 64)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
    
    func isActive() -> Bool {
        return selection == id
    }
}

struct MenuButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack{
            MenuButton(id: 1, selection: .constant(1))
            MenuButton(id: 2, selection: .constant(1))
        }
    }
}
