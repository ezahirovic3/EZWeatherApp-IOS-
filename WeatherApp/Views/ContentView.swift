//
//  ContentView.swift
//  WeatherApp
//
//  Created by MacBook Pro on 16. 11. 2022..
//

import SwiftUI

struct ContentView: View {
    //@StateObject var weatherViewModel = WeatherViewModel()
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        GeometryReader { geo in
            ScrollView (showsIndicators: false) {
                VStack {
                    LocationLabel(
                        geo: geo,
                        city:locationManager.city,
                        country: locationManager.country
                    )
                    CurrentWeatherView(
                        geo: geo,
                        weatherViewModel: locationManager.weatherViewModel
                    )
                    .padding(.bottom, geo.size.height*0.04)
                    DailyHorizontalView(
                        geo: geo,
                        weatherViewModel: locationManager.weatherViewModel
                    )
                    Spacer()
                }
                .padding()
            }
            .alert(isPresented: $locationManager.showAlert) {
                Alert(
                    title: Text("Location access denied"),
                    message: Text("Please go to Settings and turn on the permissions"),
                    primaryButton: .cancel(Text("Cancel")),
                    secondaryButton: .default(Text("Settings"), action: {
                        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }))
            }
        }
        .onAppear(){
            locationManager.startLocationServices()
        }
    }
}

struct LocationLabel: View {
    let geo:GeometryProxy
    let city: String
    let country: String
    
    var body: some View {
        HStack() {
            Text(city+",")
                .font(.system(size: geo.size.height*0.03))
                .bold()
            Text(country)
                .font(.system(size: geo.size.height*0.03))
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}

