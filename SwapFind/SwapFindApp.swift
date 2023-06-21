import SwiftUI

@main
struct SwapFindApp: App {
    @AppStorage("colorTheme") var colorTheme: Bool = false
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .ignoresSafeArea(.container)
                .preferredColorScheme(colorTheme ? .dark : .light)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
