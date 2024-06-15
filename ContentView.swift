import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ScrapeViewModel()
    
    var body: some View {
        NavigationView {
            TabView {
                // Home tab
                ScrollView {
                    Text("Welcome to ScholarSync")
                        .font(.title)
                        .fontWeight(.light)
                        .foregroundColor(Color(hue: 0.636, saturation: 0.874, brightness: 0.735))
                    Text("Start browsing opportunities from all over the web")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(Color(hue: 0.636, saturation: 0.874, brightness: 0.735))
                    
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(viewModel.combinedResults, id: \.self) { result in
                            NavigationLink(destination: ScholarshipDetailView(result: result)) {
                                ScholarshipTile(result: result)
                                    .padding()
                                    .frame(maxWidth: .infinity, minHeight: 100)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding()
                    .onAppear {
                        viewModel.scrapeAll()
                    }
                }
                .tabItem {
                    Image(systemName: "book")
                    Text("Home")
                }
                .tag(0)
                
                // Favorites tab
                ScrollView {
                    Text("Favorites")
                        .font(.title)
                        .fontWeight(.light)
                        .foregroundColor(Color(hue: 0.636, saturation: 0.874, brightness: 0.735))
                }
                .tabItem {
                    Image(systemName: "heart")
                    Text("Favorites")
                }
                .tag(1)
                
                // About tab
                ScrollView {
                    VStack(spacing: 20) {
                        Text("About ScholarSync")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                        
                        Text("ScholarSync is your ultimate companion in navigating the complex world of scholarships. Our mission is to simplify your search for financial aid by providing a centralized database of scholarships from various sources. \nWe understand the challenges and time constraints students face, which is why we designed ScholarSync to be intuitive, comprehensive, and user-friendly. \nWhether you're a high school junior, senior, or a college student, ScholarSync is here to help you find opportunities tailored to your needs. \nEmpower your academic journey with ScholarSync, where your future starts today.")
                            .font(.body)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        
                        Text("\nHow ScholarSync Works")
                            .font(.headline)
                            .foregroundColor(.blue)
                        
                        Text("\n• Data Aggregation: ScholarSync scours the internet, pulling scholarship information from reputable sources, ensuring our database is both extensive and reliable.")
                            .font(.footnote)
                        
                        Text("\n• Centralized Database: All collected scholarships are stored in a centralized database, categorized by eligibility criteria, award amounts, deadlines, and more, making it easy for you to find what you need.")
                            .font(.footnote)
                    }
                    .padding()
                }
                .tabItem {
                    Image(systemName: "info.circle")
                    Text("About")
                }
                .tag(2)
            }
        }
    }
}

// Tile view for brief scholarship info
struct ScholarshipTile: View {
    let result: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(parseTitle(from: result))
                .font(.headline)
                .foregroundColor(Color(hue: 0.636, saturation: 0.874, brightness: 0.735))
                .lineLimit(2) // Limit the title to 2 lines

            Text(parseBriefDescription(from: result))
                .font(.body)
                .foregroundColor(.black)
                .lineLimit(1)
                .truncationMode(.tail)

            HStack {
                Spacer()
                Image(systemName: "arrow.right.circle")
                    .foregroundColor(Color(hue: 0.636, saturation: 0.874, brightness: 0.735))
            }
        }
        .padding()
    }

    // Parsing functions to extract parts of the result string
    func parseTitle(from result: String) -> String {
        return extractLine(from: result, withPrefix: "Award Title:")
    }

    func parseBriefDescription(from result: String) -> String {
        return extractLine(from: result, withPrefix: "Award Description:")
    }

    func extractLine(from text: String, withPrefix prefix: String) -> String {
        guard let range = text.range(of: prefix) else { return "" }
        let line = text[range.upperBound...]
        return line.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// Detail view for full scholarship info
struct ScholarshipDetailView: View {
    let result: String

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(parseTitle(from: result))
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(hue: 0.636, saturation: 0.874, brightness: 0.735))

            Text(parseAmount(from: result))
                .font(.title2)
                .fontWeight(.semibold)

            if let deadline = parseDeadline(from: result), !deadline.isEmpty {
                Text(deadline)
                    .font(.title3)
                    .foregroundColor(.red)
            }

            Text(parseDescription(from: result))
                .font(.body)
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)

            Text(parseLink(from: result))
                .font(.footnote)
                .foregroundColor(.blue)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Scholarship Details")
    }

    // Parsing functions to extract parts of the result string
    func parseTitle(from result: String) -> String {
        return extractLine(from: result, withPrefix: "Award Title:")
    }

    func parseAmount(from result: String) -> String {
        return extractLine(from: result, withPrefix: "Award Amount:")
    }

    func parseDeadline(from result: String) -> String? {
        return extractLine(from: result, withPrefix: "Award Deadline:")
    }

    func parseDescription(from result: String) -> String {
        return extractLine(from: result, withPrefix: "Award Description:")
    }

    func parseLink(from result: String) -> String {
        return extractLine(from: result, withPrefix: "Award Link:")
    }

    func extractLine(from text: String, withPrefix prefix: String) -> String {
        guard let range = text.range(of: prefix) else { return "" }
        let line = text[range.upperBound...]
        return line.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

