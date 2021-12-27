//

import MapKit
import UIKit

protocol RestaurantsMapView: ViewProtocol {
    var presenter: RestaurantsMapPresenterProtocol! { get set }
    func changeViewState(viewState: RestaurantsMapViewState)
}

final class RestaurantsMapViewController: UIViewController, RestaurantsMapView {
    var presenter: RestaurantsMapPresenterProtocol!

    @IBOutlet private weak var mapView: MKMapView!

    static var storyboardName: String {
        "RestaurantsMap"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter.viewLoaded()
    }

    private func setupViews() {
        mapView.showsUserLocation = true
        mapView.delegate = self
    }

    func changeViewState(viewState: RestaurantsMapViewState) {
        switch viewState {
        case .clear:
            break
        case .render(let viewModel):
            renderViewModel(viewModel: viewModel)
        }
    }

    private func renderViewModel(viewModel: RestaurantsMapViewState.ViewModel) {
        mapView.removeAnnotations(mapView.annotations)
        let annotations = viewModel.restaurantsLocations.map {
            RestaurantAnnotation(title: $0.title, coordinate: $0.location, subtitle: $0.subtitle)
        }
        mapView.addAnnotations(annotations)
        let span = MKCoordinateSpan(latitudeDelta: 0.01,
                                    longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: viewModel.userLocation, span: span)
        mapView.setRegion(region, animated: true)
    }
}

extension RestaurantsMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let selectedAnnotation = view.annotation
        presenter.didSelectAnnotation(coordinate: selectedAnnotation?.coordinate)
    }
}
