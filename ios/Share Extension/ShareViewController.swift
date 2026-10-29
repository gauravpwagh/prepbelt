// Share into PrepBelt (docs/05-architecture.md). Shows no UI of its own:
// the shared PDF or link goes straight to the app, which opens Add source
// pre-filled.
import receive_sharing_intent

class ShareViewController: RSIShareViewController {
    override func shouldAutoRedirect() -> Bool {
        return true
    }
}
