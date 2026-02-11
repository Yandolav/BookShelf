import Foundation

protocol CodableStorageProtocol {
    func load<T: Decodable>(_ type: T.Type, fileName: String, default defaultValue: T) -> T
    func save<T: Encodable>(_ value: T, fileName: String)
}

final class Storage: CodableStorageProtocol {

    private let baseDirectory: URL
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(
        baseDirectory: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.baseDirectory = baseDirectory
        self.encoder = encoder
        self.decoder = decoder
    }

    func load<T: Decodable>(_ type: T.Type, fileName: String, default defaultValue: T) -> T {
        let url = baseDirectory.appendingPathComponent(fileName)
        guard FileManager.default.fileExists(atPath: url.path) else { return defaultValue }

        do {
            let data = try Data(contentsOf: url)
            guard !data.isEmpty else { return defaultValue }
            return try decoder.decode(T.self, from: data)
        } catch {
            print("load error (\(fileName)):", error)
            return defaultValue
        }
    }

    func save<T: Encodable>(_ value: T, fileName: String) {
        let url = baseDirectory.appendingPathComponent(fileName)

        do {
            let data = try encoder.encode(value)
            try data.write(to: url, options: [.atomic])
        } catch {
            print("save error (\(fileName)):", error)
        }
    }
}

