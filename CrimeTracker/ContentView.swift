import SwiftUI
import MapKit

struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: viewModel.binding, showsUserLocation: true, userTrackingMode: .none)
           .edgesIgnoringSafeArea(.all)
           .onAppear(perform: {
            viewModel.checkIfLocationIsEnabled()
                           })
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.centerMapOnUserLocation()
                    }) {
                        Image(systemName: "location.fill")
                            .font(.title2)
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    }
                    .padding()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
