import SwiftUI
import Combine

enum ViewState: Equatable {
    case pending
    case loading
    case error(String)
    case snack
}

protocol FullscreenLoadingView: View {
    associatedtype ContentView: View
    associatedtype LoaderView: View

    var state: Binding<ViewState> { get set }
    var content: ContentView { get }
    var loadingView: LoaderView { get }
}

extension FullscreenLoadingView {
    @ViewBuilder
    var body: some View {
        ZStack {
            self.content
                .disabled(state.wrappedValue == .loading)
            if state.wrappedValue == .loading {
                self.loadingView
            }
        }
    }
    
    // Default if next level of abstraction or view struct does not implement loading view
    var loadingView: some View {
        ProgressView()
    }
}

final class FullscreenLoadingImplementationViewModel: ObservableObject {
    @Published var viewState: ViewState = .pending

    func load() {
        viewState = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.viewState = .pending
        }
    }
}

struct FullscreenLoadingImplementation: FullscreenLoadingView {
    
    @ObservedObject private var viewModel: FullscreenLoadingImplementationViewModel
    var state: Binding<ViewState> = .constant(.pending) // needs a default value


    init(
        viewModel: FullscreenLoadingImplementationViewModel
    ) {
        self.viewModel = viewModel
        self.state = $viewModel.viewState
    }

    var content: some View {
        VStack {
            Text("Here is content")
            Button("set loading for a sec") {
                viewModel.load()
            }
        }
    }

    var loadingView: some View {
        ZStack {
            Color.white
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            ProgressView()
        }
    }
}

#Preview {
    FullscreenLoadingImplementation(
        viewModel: FullscreenLoadingImplementationViewModel()
    )
}
