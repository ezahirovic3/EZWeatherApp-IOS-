//
//  CurrentWeatherView.swift
//  WeatherApp
//
//  Created by MacBook Pro on 16. 11. 2022..
//

import SwiftUI

struct CurrentWeatherView: View {
    let geo:GeometryProxy
    @StateObject var weatherViewModel: WeatherViewModel
    
    var body: some View {
        VStack(spacing:10){
            weatherViewModel.getWeatherIconFor(icon: weatherViewModel.weatherIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: geo.size.width*0.2, height: geo.size.height*0.08)
            Text(weatherViewModel.conditions)
                .font(.system(size: geo.size.height*0.05))
            Text(weatherViewModel.date)
                .font(.system(size: geo.size.height*0.025))
                .foregroundColor(.white).opacity(0.5)
            
            Text(weatherViewModel.temperature)
                .font(.system(size: geo.size.height*0.08))
                .fontWeight(.bold)
            Divider().background(.white)
            HStack{
                WidgetView(image:"wind", text: "wind",value:weatherViewModel.windSpeed+" km/h")
                Divider()
                    .background(.white)
                
                WidgetView(image:"thermometer", text: "feels like",value:weatherViewModel.feelsLike)
            }
            .frame(height: geo.size.height*0.1)
            Divider().background(.white)
            HStack{
                WidgetView(image:"humidity", text: "humidity",value:weatherViewModel.humidity)
                Divider()
                    .background(.white)
                WidgetView(image:"barometer", text: "pressure",value:weatherViewModel.pressure)
            }
            .frame(height: geo.size.height*0.1)
        }
        .padding()
        .foregroundColor(.white)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("BackgroundColor"))
        )
    }
}

struct WidgetView: View {
    let image: String
    let text: String
    let value: String
    
    var body: some View {
        GeometryReader { geo in
            HStack(){
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geo.size.width*0.25 ,height: geo.size.height*0.5)
                VStack(alignment: .leading){
                    Text(text.uppercased())
                        .opacity(0.5)
                        .font(.system(size: geo.size.height*0.25))
                    Text(value)
                        .font(.system(size: geo.size.height*0.25))
                }
            }
            .frame(height: geo.size.height)
        }
    }
}

struct CurrentWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            CurrentWeatherView(geo: geo, weatherViewModel: WeatherViewModel())
                .padding()
        }
    }
}

