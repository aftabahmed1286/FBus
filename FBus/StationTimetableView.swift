//
//  StationTimetableView.swift
//  FBus
//
//  Created by Aftab Ahmed on 8/11/19.
//  Copyright © 2019 FAMCO. All rights reserved.
//

import SwiftUI

struct StationTimetableView : View {
    
    @State var stationTimetableModel: StationTimetableModel? = StationTimetableModel()
    @State var isDepartures: Bool = true
    @State var errorText: String = ""
    
    enum Constants {
        static let screenTitle = "BERLIN ZOB"
        static let tryAgain = "Try Again!"
        static let departuresTitle = "Departures"
        static let arrivalsTitle = "Arrivals"
    }
    
    var body: some View {
        Group {
            if !errorText.isEmpty{
                NavigationView{
                    VStack {
                        ErrorView(errortext: errorText)
                        Button(action: {
                            self.fetch()
                        }){
                            Text(Constants.tryAgain)
                        }
                        
                    }.navigationBarTitle(Text(Constants.screenTitle), displayMode: .inline)
                }
            } else if self.sections().isEmpty {
                LoadingView(isShowing: .constant(true)){
                    NavigationView {
                        Text(" ")
                            .navigationBarTitle(Text(Constants.screenTitle), displayMode: .inline)
                    }
                }
            } else {
                NavigationView {
                    List {
                        ForEach(self.sections(), id:\.self) { section in
                            Section(header: Text(section).bold()) {
                                ForEach(self.journeyDetails(forDate: section)){ j in
                                    StationTimetableRow(journeyDetails: j.journeyDetails)
                                }
                            }
                        }
                        }
                        .listStyle(GroupedListStyle())
                        .navigationBarTitle(Text(Constants.screenTitle), displayMode: .inline)
                        .navigationBarItems(trailing:
                            Button(action: {
                                self.isDepartures = !self.isDepartures
                            }){
                                if isDepartures {
                                    Text(Constants.departuresTitle)
                                } else {
                                    Text(Constants.arrivalsTitle)
                                }}
                    )
                    }
            }
        }.onAppear(perform: fetch)
        
    }
    
    /*
     API Call
     */
    func fetch() {
        APIManager.shared.fetchStationTimetableResponseModel(stationId: "3", completion: { (model, error) in
            if error == nil {
                DispatchQueue.main.async {
                    self.stationTimetableModel = model
                    self.errorText = ""
                }
            } else {
                DispatchQueue.main.async {
                    self.errorText = error!.localizedDescription
                }
            }
        })
    }
}

extension StationTimetableView {
    
    /*
     Helper Methods
     */
    
    func sections() -> [String] {
        guard let dates = isDepartures ?
            stationTimetableModel?.timetable?.departuresDatesSorted :
            stationTimetableModel?.timetable?.arrivalsDatesSorted else {
                return []
        }
        return dates
    }
    
    func journeyDetails(forDate: String) -> [JourneyDetailsIdable] {
        guard let journeyDet = isDepartures ?
            stationTimetableModel?.timetable?.departuresGrouped?[forDate] :
            stationTimetableModel?.timetable?.arrivalsGrouped?[forDate] else {
                return []
        }
        
        var idableJourneyDetails: [JourneyDetailsIdable] = []
        var id = 0
        
        for journey in journeyDet {
            idableJourneyDetails.append(JourneyDetailsIdable(id: id, journeyDetails: journey))
            id += 1
        }
        return idableJourneyDetails
    }
}

struct StationTimetableRow: View {
    
    var journeyDetails: JourneyDetails
    
    var body: some View {
        HStack(alignment: .top) {
            
            Text("\((journeyDetails.datetime?.dateString().time)!)")
            
            VStack(alignment: .leading) {
                VStack {
                    Text("\(journeyDetails.line_direction!)")
                        .foregroundColor(.gray)
                        .lineLimit(nil)
                }
                VStack {
                    Text("to \(journeyDetails.through_the_stations!)")
                        .lineLimit(nil)
                }
            }
            
        }
    }
}


#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StationTimetableView()
    }
}
#endif
