//
//  WeightMenuView.swift
//  UI
//
//  Created by user196345 on 5/19/22.
//

import SwiftUI
import SwiftUICharts

struct WeightMenuView: View {
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var migration: Migration
    
    let days: Double = 24 * 60 * 60
    let maxDayHistory = 15
    var minTimeStamp: Date
    
    @State var weightPoints: [WeightPoint] = []
    @State var dataPoints: [DataPoint] = []
    var dateFormatter = DateFormatter()
    @State var showCloseWeightEntryButton = false
    @State var showEditMenu = false
    @State var initializedData = false
    
    
    let legend = Legend(color: .blue,
                        label: "KGs")
    
    @State private var newDataPointDate = Date()
    @State private var newDataPointWeight = "50"
    
    func UpdateDataPoints()
    {
        let sortedWeightPoints: [WeightPoint] = weightPoints.sorted{
            $0.timestamp < $1.timestamp
        }
        
   
        dataPoints = []//.init(value: 50, label: "05/05", legend: legend),
        var cnt = 0
        for point in sortedWeightPoints {
                        //if point.timestamp > minTimeStamp {
                cnt = cnt + 1
            if cnt >= sortedWeightPoints.count - 15 {
                let dateString = dateFormatter.string(from:point.timestamp)
                dataPoints.append(.init(value: Double(point.weightValue), label: LocalizedStringKey(dateString), legend: legend))
            }
            //}
        }
    }
    
    func addWeightPoint(weight: Float, date: Date)
    {
        if LocalDataStore.addNewDateToDabase(value: weight, newDate: date) == true {
            weightPoints = LocalDataStore.getLocalWeightHistory()
            let currentEmail = auth.getCurrentEmail()
            let currentName = auth.getCurrentDisplayName()
            if migration.syncDataWithFirestore(authType: auth.authType, email: currentEmail, name: currentName) == false {
               print("Error synchronizing with Firestore")
            }
        }
        
        UpdateDataPoints()
    }
    
    func removeWeightPoint(id: String?)
    {
        for (_, point) in weightPoints.enumerated() {
            if point.id == id {
//                weightPoints.remove(at: index)
                // remove from localstore here...
                if LocalDataStore.removeDateFromDatabase(id: id!) == true {
                    weightPoints = LocalDataStore.getLocalWeightHistory()
                    let currentEmail = auth.getCurrentEmail()
                    let currentName = auth.getCurrentDisplayName()
                    if migration.syncDataWithFirestore(authType: auth.authType, email: currentEmail, name: currentName) == false {
                       print("Error synchronizing with Firestore")
                    }
                }
                UpdateDataPoints()
                break
            }
        }
    }
    
    func updateWeightPoint(id: String?, weight: Float, date: Date)
    {
        for (index, point) in weightPoints.enumerated() {
            if point.id == id {
                weightPoints[index].timestamp = date
                weightPoints[index].weightValue = weight
                // update the localstore here...
                if LocalDataStore.editCurrentDateToDatabase(id: id!, weight: weight, date: date) == true {
                    weightPoints = LocalDataStore.getLocalWeightHistory()
                    let currentEmail = auth.getCurrentEmail()
                    let currentName = auth.getCurrentDisplayName()
                    if migration.syncDataWithFirestore(authType: auth.authType, email: currentEmail, name: currentName) == false {
                       print("Error synchronizing with Firestore")
                    }
                }
                UpdateDataPoints()
                break
            }
        }
    }
    
    init(){
        dateFormatter.dateFormat = "dd/MM"
        minTimeStamp = Date().addingTimeInterval(-Double(maxDayHistory) * days)
        weightPoints = []
        dataPoints = []
    }
    
    var body: some View {
        //NavigationView{
            ScrollView{
                VStack{
                    
                    HStack{
                        Text("Your Progress")
                            .font(.title)
                        
                        Button(action: {
                            showEditMenu = true
                        }) {
                            Image(systemName: "gearshape.2")
                                .font(.title)
                                .foregroundColor(.blue)
                        }
                        .sheet(isPresented: $showEditMenu, content: {
                            EditDataView(wp: weightPoints, rwp: removeWeightPoint, uwp: updateWeightPoint)
                        })
                        
                    }
                    .padding(.top, 5)
                    
                    LineChartView(dataPoints: dataPoints)
                        .onAppear {
                            if !initializedData
                            {
//                                initializedData = true
                                weightPoints = LocalDataStore.getLocalWeightHistory()
                                dataPoints = []
                                
                                UpdateDataPoints()
                            }
                        }
                    
                    VStack{
                        Text("Add a new entry:")
                            .font(.title)
                        HStack {
                            DatePicker("", selection: $newDataPointDate, in: ...Date(), displayedComponents: [.date])
                            
                            TextField("Weight:", text: $newDataPointWeight) {
                                isEditing in
                                showCloseWeightEntryButton = isEditing
                            }
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Button(action: {
                                showCloseWeightEntryButton = false
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                if let floatValue = Float(newDataPointWeight) {
                                    addWeightPoint(weight: floatValue, date: newDataPointDate)
                                }
                                else {
                                    
                                }
                            }) {
                                Image(systemName: "plus")
                                    .font(.largeTitle)
                                    .foregroundColor(.blue)
                            }
                            .padding(5)
                            
                            if (showCloseWeightEntryButton)
                            {
                                Button(action: {
                                    showCloseWeightEntryButton = false
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                }) {
                                    Image(systemName: "pencil.slash")
                                        .font(.largeTitle)
                                        .foregroundColor(.blue)
                                    
                                        
                                }
                                
                                .padding(5)
                            }
                            
                        }
                        /*
                        VStack {
                            ForEach(weightPoints) {weightPoint in
                                ExistingPointRow(weightPoint: weightPoint)
                            }
                        }*/
                        
                        
                        
                    }
                    .padding(5)
                }
                
                
            //}
            //.navigationTitle("Your Progress")
            .padding(5)
        }
        
    }
}

struct ExistingPointRow: View {
   
    var removeWeightPoint: (String?) -> Void
    var updateWeightPoint: (String?, Float, Date) -> Void
    
    var weightPoint: WeightPoint
    @State private var newDataPointDate = Date()
    @State private var newDataPointWeight = "50"
    @State var showCloseWeightEntryButton = false
    
    init(weightpoint: WeightPoint, rwp: @escaping (String?) -> Void, uwp: @escaping (String?, Float, Date) -> Void) {
        removeWeightPoint = rwp
        updateWeightPoint = uwp
        weightPoint = weightpoint
        newDataPointDate = weightPoint.timestamp
        newDataPointWeight = weightPoint.weightValue.description
        
    }
    
    var body: some View {
        HStack {
            DatePicker("", selection: $newDataPointDate, in: ...Date(), displayedComponents: [.date])
            
            TextField("Weight:", text: $newDataPointWeight) {
                isEditing in
                showCloseWeightEntryButton = isEditing
            }
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                showCloseWeightEntryButton = false
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                if let floatValue = Float(newDataPointWeight) {
                    updateWeightPoint(weightPoint.id, floatValue, newDataPointDate)
                    print("ok")
                }
                
            }) {
                Image(systemName: "pencil")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
            }
            .padding(5)
            
            Button(action: {
                showCloseWeightEntryButton = false
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                removeWeightPoint(weightPoint.id)
            }) {
                Image(systemName: "trash")
                    .font(.largeTitle)
                    .foregroundColor(.red)
            }
            .padding(5)
        }
        .onAppear{
            newDataPointDate = weightPoint.timestamp
            newDataPointWeight = weightPoint.weightValue.description
        }
        
    }
}


struct EditDataView: View {
    @Environment(\.presentationMode) var presentationMode
    var weightPoints: [WeightPoint]
    var removeWeightPoint: (String?) -> Void
    var updateWeightPoint: (String?, Float, Date) -> Void
    
    init(wp: [WeightPoint], rwp: @escaping (String?) -> Void, uwp: @escaping (String?, Float, Date) -> Void){
        weightPoints = wp
        removeWeightPoint = rwp
        updateWeightPoint = uwp
    }
    
    var body: some View {
        //Background {
            VStack (alignment: .center, spacing: 20) {
                ScrollView{
                    VStack {
                        ForEach(weightPoints) {weightPoint in
                            ExistingPointRow(weightpoint: weightPoint, rwp: removeWeightPoint, uwp: updateWeightPoint)
                        }
                    }
                }
                .padding(5)
                
                /*
                ScrollView{
                    ForEach(instructions) {instruction in
                        if (instruction.type == "text")
                        {
                            Text(instruction.data)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        else if (instruction.type == "image")
                        {
                            Image(instruction.data)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }
                        else if (instruction.type == "movie")
                        {
                            VideoPlayer(player: AVPlayer(url: Bundle.main.url(forResource:instruction.data, withExtension: "mp4")!))
                                .frame(height: 300)
                        }
                        
                    }
                    
                    
                }*/
                
                Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding(5)
            }.padding(20)
        /*}
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }*/
        
    }
}
/*
struct Background<Content: View>: View {
    private var content: Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }

    var body: some View {
        Color.white
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .overlay(content)
    }
}*/


struct WeightMenuView_Previews: PreviewProvider {
    static var previews: some View {
        WeightMenuView()
    }
}
