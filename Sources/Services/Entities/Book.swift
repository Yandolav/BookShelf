import Foundation

struct Book: Identifiable, Codable, Equatable, CustomStringConvertible {
    let id: UUID
    let title: String
    let author: String
    let publicationYear: Int?
    let genre: Genre
    let tags: [String]

    var description: String {
        let yearText = publicationYear.map(String.init) ?? "Unknown"
        return "Id: \(id), Title: \(title), Author: \(author), Publication Year: \(yearText), Genre: \(genre), tags: \(tags)"
    }
}
