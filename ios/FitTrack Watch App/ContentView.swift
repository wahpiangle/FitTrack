import SwiftUI


struct ContentView: View {
    @ObservedObject var viewModel: WatchViewModel = WatchViewModel()
    var body: some View {
        ScrollView{
            VStack(alignment: .leading) {
                Text("Quick Start")
                    .font(.headline)
                    .padding()
                Button(action:{}, label:
                        {
                    Text("Start New Workout")
                        .fontWeight(.semibold)
                        .foregroundColor(Color.black)
                })
                .tint(Color.theme.secondary)
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 10))
                .controlSize(.mini)
                Text("My Templates")
                    .font(.headline)
                    .padding()
                if viewModel.templates.count > 0 {
                    ForEach(viewModel.templates, id: \.id) { template in
                        Button(action: {
                            print(template.title)
                        }, label: {
                            HStack{
                                VStack(alignment: .leading) {
                                    Text(template.title)
                                        .font(.headline)
                                    Text(template.note)
                                        .font(.subheadline)
                                        .foregroundColor(Color.gray)
                                }
                                Spacer()
                            }
                        })
                        .buttonBorderShape(.roundedRectangle(radius: 10)
                        )
                    }
                }else{
                    Text("You have no templates")
                        .padding()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
