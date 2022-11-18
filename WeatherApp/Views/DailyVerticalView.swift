//
//  DailyVerticalView.swift
//  WeatherApp
//
//  Created by MacBook Pro on 16. 11. 2022..
//

import SwiftUI

struct DailyVerticalView: View {
    @StateObject var weatherViewModel: WeatherViewModel
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading){
                HeaderView(geo: geo)
                ForEach(weatherViewModel.weather.daily){ index in
                    if index.date==weatherViewModel.weather.daily.first!.date{}
                    else {
                        RowView(
                            geo: geo,
                            weatherViewModel: weatherViewModel,
                            index: index
                        )
                    }
                }
                Spacer()
            }
            .padding()
            .foregroundColor(.white)
            .background(Color("BackgroundColor"))
        }
    }
}

struct HeaderView: View {
    let geo: GeometryProxy
    
    var body: some View {
        HStack {
            Text("Next")
                .font(.system(size: geo.size.height*0.04))
                .bold()
            Text(" 7 days")
                .font(.system(size: geo.size.height*0.04))
        }
    }
}

struct RowView: View {
    let geo: GeometryProxy
    @StateObject var weatherViewModel: WeatherViewModel
    let index: WeatherDaily
    
    var body: some View {
        HStack(){
            weatherViewModel.getWeatherIconFor(icon: index.weather[0].icon)
                .resizable()
                .scaledToFit()
                .frame(width: geo.size.width*0.1)
                .padding()
            Text(weatherViewModel.getDayFor(index.date)+",")
                .fontWeight(.bold)
                .font(.system(size: geo.size.height*0.025))
            Text(weatherViewModel.getDayForV2(index.date))
                .font(.system(size: geo.size.height*0.025))
                .opacity(0.5)
            Spacer()
            Text(weatherViewModel.getTempFor(index.temperature.max))
                .font(.system(size: geo.size.height*0.035))
                .fontWeight(.bold)
            Text("/ \(weatherViewModel.getTempFor(index.temperature.min))")
                .font(.system(size: geo.size.height*0.025))
                .opacity(0.5)
        }
    }
}

struct DailyVerticalView_Previews: PreviewProvider {
    static var previews: some View {
        DailyVerticalView(weatherViewModel: WeatherViewModel())
    }
}


