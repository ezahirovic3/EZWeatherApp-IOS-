//
//  DailyHorizontalView.swift
//  WeatherApp
//
//  Created by MacBook Pro on 16. 11. 2022..
//

import SwiftUI

struct DailyHorizontalView: View {
    let geo:GeometryProxy
    @StateObject var weatherViewModel: WeatherViewModel
    
    @State var seeAll = false
    
    var body: some View {
        VStack{
            HStack{
                Text("Forecast")
                    .font(.system(size: geo.size.height*0.03))
                    .bold()
                Text("for next 7 days")
                    .font(.system(size: geo.size.height*0.03))
                Spacer()
                Button  {
                    seeAll = true
                } label: {
                    Text("See all")
                        .bold()
                }
                .font(.system(size: geo.size.height*0.03))
                .sheet(isPresented: $seeAll){
                    DailyVerticalView(weatherViewModel: weatherViewModel)
                }
            }
            HorizontalScrollView(
                geo: geo,
                weatherViewModel: weatherViewModel
            )
            Spacer()
        }
    }
}

struct HorizontalScrollView: View {
    let geo:GeometryProxy
    @StateObject var weatherViewModel: WeatherViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false)  {
            HStack {
                ForEach(weatherViewModel.weather.daily){index in
                    if index.date==weatherViewModel.weather.daily.first!.date {
                        CardView(
                            geo: geo,
                            date: "Today",
                            //image : weatherViewModel.getWeatherIconFor(icon: weatherViewModel.weatherIcon)
                            image: weatherViewModel.getWeatherIconFor(icon: index.weather[0].icon),
                            // temp: weatherViewModel.temperature
                            temp: weatherViewModel.getTempFor(index.temperature.max)
                        )
                        .foregroundColor(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color("BackgroundColor"))
                        )
                    }
                    else{
                        CardView(
                            geo: geo,
                            date: weatherViewModel.getDayNumber(index.date),
                            image: weatherViewModel.getWeatherIconFor(icon: index.weather[0].icon),
                            temp: weatherViewModel.getTempFor(index.temperature.max)
                        )
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.white.opacity(0.1))
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.black.opacity(0.5), lineWidth: 1)
                            }
                        )
                        .padding(geo.size.width*0.005)
                    }
                }
            }
        }
    }
}

struct CardView: View {
    let geo:GeometryProxy
    let date: String
    let image: Image
    let temp: String
    
    var body: some View {
        VStack(spacing:8){
            Text(date)
                .font(.system(size: geo.size.height*0.025))
                .opacity(0.5)
                .padding(.bottom, geo.size.height*0.015)
            image
                .resizable()
                .scaledToFit()
            //.frame(height: geo.size.height*0.05)
            Text(temp)
                .fontWeight(.bold)
                .font(.system(size: geo.size.height*0.025))
                .padding(.top, geo.size.height*0.015)
        }
        .frame(width: geo.size.width*0.15,height: geo.size.height*0.15)
        .padding()
    }
}

struct DailyHorizontalView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            DailyHorizontalView(geo: geo, weatherViewModel: WeatherViewModel())
                .padding()
        }
    }
}


