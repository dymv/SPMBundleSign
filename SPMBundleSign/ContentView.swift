import SwiftUI
import TargetWithResources
import TargetWithoutResources

struct ContentView: View {
    @ObservedObject var model = Model()
    var body: some View {
        Text(model.data)
            .padding()
    }
}

class Model: ObservableObject {
    @Published var data: String = ""
    init() { self.load() }
    func load() {
        guard let contents = try? TargetWithResources().contents() else {
            self.data = "Loading error"
            return
        }
        self.data = contents + TargetWithoutResources().contents()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
