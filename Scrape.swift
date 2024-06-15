import SwiftUI
import SwiftSoup

class ScrapeViewModel: ObservableObject {
    @Published var combinedResults: [String] = []

    func scrapeFastWeb(page: String) -> [String] {
        var results = [String]()
        
        let urlString = page
        if let url = URL(string: urlString),
           let html = try? String(contentsOf: url) {
            
            do {
                let document = try SwiftSoup.parse(html)
                let activeAwards = try document.select("a.active_award")
                var uniqueTitles = Set<String>()
                activeAwards.forEach { activeAward in
                    let awardTitle = try! activeAward.text()
                    uniqueTitles.insert(awardTitle)
                }
                
                var count = 0
                for title in uniqueTitles {
                    if count >= 5 { break }
                    let matchingAward = try document.select("a.active_award:contains(\(title))")
                    if let activeAward = matchingAward.first() {
                        let awardLink = try activeAward.attr("href")
                        if let awardAmount = try document.select("td.info").first() {
                            let result = """
                            Award Title: \(title)
                            Award Amount: \(try! awardAmount.text())
                            Award Link: fastweb.com\(awardLink)
                            From Fastweb
                            """
                            results.append(result)
                            count += 1
                        }
                    }
                }
            } catch {
                print("Error parsing HTML: \(error.localizedDescription)")
            }
        } else {
            print("Error fetching HTML content.")
        }
        
        return results
    }
    
    func scrapeScholarshipsDotCom(page: String) -> [String] {
        var results = [String]()
        
        let urlString = page
        if let url = URL(string: urlString),
           let html = try? String(contentsOf: url) {
            
            do {
                let document = try SwiftSoup.parse(html)
                let scholarships = try document.select("div.award-box")
                
                var count = 0
                for scholarship in scholarships {
                    if count >= 5 { break }
                    let title = try scholarship.select("h2").text()
                    let description = try scholarship.select("p").text()
                    let amount = try scholarship.select("span:contains($)").text()
                    let link = try scholarship.select("a").attr("href")
                    let deadline = try scholarship.select("span:contains(2024)").text()
                    
                    let result = """
                    Award Title: \(title)
                    Award Description: \(description)
                    Award Amount: \(amount)
                    Award Deadline: \(deadline)
                    Award Link: scholarships.com\(link)
                    """
                    results.append(result)
                    count += 1
                }
            } catch {
                print("Error parsing HTML: \(error.localizedDescription)")
            }
        } else {
            print("Error fetching HTML content.")
        }
        
        return results
    }
    
    func scrape360(page: String) -> [String] {
        var results = [String]()
        
        let urlString = page
        if let url = URL(string: urlString),
           let html = try? String(contentsOf: url) {
            
            do {
                let document = try SwiftSoup.parse(html)
                let scholarships = try document.select("div.re-scholarship-card")
                
                var count = 0
                for scholarship in scholarships {
                    if count >= 1 { break }
                    
                    let title = try scholarship.select("h4").text()
                    let description = try scholarship.select("p").text()
                    let amount = try scholarship.select("span:contains($)").text()
                    let link = try scholarship.select("a").attr("href")
                    let deadline = try scholarship.select("span:contains(2024)").text()
                    
                    let result = """
                    Award Title: \(title)
                    Award Description: \(description)
                    Award Amount: \(amount)
                    Deadline: \(deadline)
                    Award Link: \(link)
                    """
                    results.append(result)
                    count += 1
                }
            } catch {
                print("Error parsing HTML: \(error.localizedDescription)")
            }
        } else {
            print("Error fetching HTML content.")
        }
        
        return results
    }
    
    func scrapeAll() {
        var allResults = [String]()
        allResults.append(contentsOf: scrapeFastWeb(page: "https://www.fastweb.com/directory/scholarships-for-high-school-juniors"))
        allResults.append(contentsOf: scrapeFastWeb(page: "https://www.fastweb.com/directory/scholarships-for-high-school-seniors"))
        allResults.append(contentsOf: scrapeScholarshipsDotCom(page: "https://www.scholarships.com/financial-aid/college-scholarships/scholarships-by-grade-level/high-school-scholarships/scholarships-for-high-school-juniors"))
        allResults.append(contentsOf: scrapeScholarshipsDotCom(page: "https://www.scholarships.com/financial-aid/college-scholarships/scholarships-by-grade-level/high-school-scholarships/scholarships-for-high-school-seniors"))
//        allResults.append(contentsOf: scrape360(page: "https://scholarships360.org/scholarships/easy-scholarships-to-apply-for/"))
//        allResults.append(contentsOf: scrape360(page: "https://scholarships360.org/scholarships/no-essay-scholarships/"))
        
        allResults.shuffle()
        
        DispatchQueue.main.async {
            self.combinedResults = allResults
        }
    }
}

