protocol HistoryServiceProtocol {
    func addHistoryItem(historyItem: HistoryItem)
    func getHistoryItems() -> [HistoryItem]
}

final class HistoryService: HistoryServiceProtocol {

    //MARK: Private properties

    private let maxSize: Int
    private var historyItems: [HistoryItem]
    private var currentIndex = 0

    // MARK: Init

    init(maxSize: Int) {
        self.maxSize = maxSize
        self.historyItems = []
    }

    // MARK: Public properties

    func addHistoryItem(historyItem: HistoryItem) {
        if historyItems.count < maxSize {
            historyItems.append(historyItem)
        } else {
            historyItems[currentIndex] = historyItem
            currentIndex = (currentIndex + 1) % maxSize
        }
    }

    func getHistoryItems() -> [HistoryItem] {
        historyItems.sorted { $0.time < $1.time }
    }
}
