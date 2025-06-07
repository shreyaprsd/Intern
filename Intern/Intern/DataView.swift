//
//  DataView.swift
//  Intern
//
//  Created by Shreya Prasad on 07/06/25.
//

import SwiftUI

struct DataView: View {
    @State var movieData : Json_Model?
    var body: some View {
        VStack{
            Text(movieData?.title ?? " no value")
                .font(.title)
            Text(movieData?.year ?? "no data")
                .font(.subheadline)
                .fontWeight(.bold)
            Text(movieData?.actors ?? "no data")
                .font(.caption)
                .fontWeight(.semibold)
            
        }
        .onAppear{
            print("appeared")
            fetchData()
        }
    }
    struct Json_Model : Codable {
        // model for the json
        let title : String?
        let year : String?
        
        let genre : String?
        let director : String?
        let writer : String?
        let actors : String?
        
        let language : String?
        let country : String?
        
        
        
        enum CodingKeys: String, CodingKey {
            
            case title = "Title"
            case year = "Year"
            case genre = "Genre"
            case director = "Director"
            case writer = "Writer"
            case actors = "Actors"
            case language = "Language"
            case country = "Country"
        }
        
        
    }
    func fetchData(){
        let urlString = "https://www.omdbapi.com/?i=tt3896198&apikey=d4f97daa"
        guard let url = URL(string: urlString) else { return
        }
        
        // creation of task that runs on background
        URLSession.shared.dataTask(with: url) { data, response, error in
            // put the data and all the other tasks to the main thread
            DispatchQueue.main.async{
                guard let data = data else {
                    return
                }
                do{
                    let movie = try JSONDecoder().decode(Json_Model.self, from: data)
                    self.movieData = movie
                    print("data decoded")
                    // decoding the data
                }
                catch{
                    print(error)
                    // used in case of an error
                }
            }
        }.resume()// resumes the  network tasks
        
    }
    
    
            }
        
        
     
        
    
    

#Preview {
    DataView()
}
