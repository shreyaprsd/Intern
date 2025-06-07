//
//  StoredView.swift
//  Intern
//
//  Created by Shreya Prasad on 07/06/25.
//

import SwiftUI

struct Movie : Codable{
    // model for the json
    let title : String?
    let year : String?
    
   
    let actors : String?
    
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        
        case actors = "Actors"
        
    }
}

class Storing : ObservableObject{
    @Published var movie : Movie?
    private let movieKey = "movieKey"
    
    init (){
        loadMovie()
    }
    
    func loadMovie(){
        if let data = UserDefaults.standard.data(forKey: movieKey),
           let decoded = try? JSONDecoder().decode(Movie.self, from : data)
        {
            self.movie = decoded
        }
    }
    
    func saveProfile(_ movie : Movie) {
        self.movie = movie
        if let encoded = try? JSONEncoder().encode(movie){
            UserDefaults.standard.set(encoded, forKey: movieKey)
        }
    }
    
    func fetchData(){
        let urlString = "https://www.omdbapi.com/?i=tt3896198&apikey=d4f97daa"
        guard let url = URL(string: urlString) else { return }
        
        // creation of task that runs on background
        URLSession.shared.dataTask(with: url) { data, response, error in
            // put the data and all the other tasks to the main thread
            DispatchQueue.main.async{
                guard let data = data else {
                    return
                }
                do{
                    let fetchedMovie = try JSONDecoder().decode(Movie.self, from: data)
                    self.movie = fetchedMovie
                    // Automatically save the fetched movie
                    self.saveProfile(fetchedMovie)
                    print("data decoded and saved")
                }
                catch{
                    print("Error decoding movie data: \(error)")
                }
            }
        }.resume() // resumes the network tasks
    }
}

struct StoredView: View {
    @StateObject private var movieStorage = Storing()
    
    var body: some View {
        VStack{
            Text("Stored Info")
                .padding()
                .font(.title)
                .bold()
            
            Text(movieStorage.movie?.title ?? "no title data")
                .font(.headline)
                .padding()
            
            Text(movieStorage.movie?.year ?? "no year data")
                .font(.subheadline)
                .padding()
            
            Text(movieStorage.movie?.actors ?? "no actor data")
                .font(.caption)
                .padding()
            
            HStack {
                // Button to test sample data storage
                Button("Save Test Movie") {
                    let testMovie = Movie(
                        title: "The Matrix",
                        year: "1999",
                       
                    
                        actors: "Keanu Reeves, Laurence Fishburne")
                                        movieStorage.saveProfile(testMovie)
                }
                .padding()
                
                // Button to fetch data from API
                Button("Fetch from API") {
                    movieStorage.fetchData()
                }
                .padding()
            }
        }
    }
}

#Preview {
    StoredView()
}
