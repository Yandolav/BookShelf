final class HistoryServiceMock: HistoryServiceProtocol {
    private(set) var items: [HistoryItem] = []

    func addHistoryItem(historyItem: HistoryItem) {
        items.append(historyItem)
    }

    func getHistoryItems() -> [HistoryItem] { items }
}
