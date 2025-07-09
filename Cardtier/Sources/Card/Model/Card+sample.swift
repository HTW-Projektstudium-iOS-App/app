import CoreLocation
import SwiftUI

// swiftlint:disable file_length
extension Card {
  static var sampleCards: [Card] = [
    Card(
      name: "John Doe",
      title: "Product Manager",
      role: "Management",
      company: "Acme Corp",
      contactInformation: ContactInformation(
        email: "john@acme.com",
        phoneNumber: "+49 123 456789",
        linkedInURL: URL(string: "https://linkedin.com/in/johndoe")
      ),
      businessAddress: Address(
        street: "Alexanderplatz 1",
        city: "Berlin",
        country: "Germany"
      ),
      logos: [UIImage(named: "acme_logo")].compactMap { $0 },
      style: CardStyle(
        primaryColor: Color(red: 0.9, green: 0.9, blue: 0.9, opacity: 1.0),
        secondaryColor: .black,
        fontName: "PartyLetPlain",
        designStyle: .traditional
      ),
      collectionDate: Date(),
      collectionLocation: CLLocationCoordinate2D(latitude: 52.5200, longitude: 13.4050)
    ),
    Card(
      name: "Jane Smith",
      title: "Software Engineer",
      role: "Engineering",
      company: "Tech Solutions",
      contactInformation: ContactInformation(
        email: "jane@techsolutions.com",
        phoneNumber: "+33 1 23 45 67 89",
        websiteURL: URL(string: "https://techsolutions.com")
      ),
      businessAddress: Address(
        street: "15 Rue de Rivoli",
        city: "Paris",
        country: "France"
      ),
      style: CardStyle(
        primaryColor: .white,
        secondaryColor: Color(red: 0.8, green: 0.3, blue: 0.3, opacity: 1.0),
        fontName: "Palatino-Italic ",
        designStyle: .minimal
      ),
      collectionDate: Date(),
      collectionLocation: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522)
    ),
    Card(
      name: "Alice Johnson",
      title: "Data Scientist",
      role: "Research",
      company: "Global Industries",
      contactInformation: ContactInformation(
        email: "alice@globalindustries.co.uk",
        phoneNumber: "+44 20 1234 5678",
        websiteURL: URL(string: "https://globalindustries.co.uk"),
        linkedInURL: URL(string: "https://linkedin.com/in/alicejohnson")
      ),
      slogan: "F*ck bitches, get data",
      style: CardStyle(
        primaryColor: .red,
        secondaryColor: .black,
        fontName: "Courier",
        designStyle: .modern
      ),
      collectionDate: Date(),
      collectionLocation: CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278)
    ),
    Card(
      name: "Bob Brown",
      title: "UX Designer",
      company: "Innovatech",
      contactInformation: ContactInformation(
        email: "bob@innovatech.com",
        phoneNumber: "+1 212 555 1234",
        websiteURL: URL(string: "https://bobbrowndesign.com")
      ),
      slogan: "Design with purpose",
      style: CardStyle(
        primaryColor: .white,
        secondaryColor: Color(red: 0.5, green: 0.3, blue: 0.7, opacity: 1.0),
        fontName: "SnellRoundhand",
        designStyle: .traditional
      ),
      collectionDate: Date(),
      collectionLocation: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)
    ),
    Card(
      name: "Charlie Green",
      title: "AI Researcher",
      company: "Future Tech",
      contactInformation: ContactInformation(
        email: "charlie@futuretech.ai",
        phoneNumber: "+1 323 555 4321"
      ),
      businessAddress: Address(
        city: "Los Angeles",
        state: "CA",
        country: "USA"
      ),
      style: CardStyle(
        primaryColor: .white,
        secondaryColor: Color(red: 0.1, green: 0.7, blue: 0.7, opacity: 1.0),
        designStyle: .modern
      ),
      collectionDate: Date(),
      collectionLocation: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437)
    ),
    Card(
      name: "Diana White",
      title: "Medical Advisor",
      role: "Healthcare",
      company: "Health Solutions",
      contactInformation: ContactInformation(
        email: "diana@healthsolutions.org",
        phoneNumber: "+1 415 555 6789",
        faxNumber: "+1 415 555 9876"
      ),
      style: CardStyle(
        primaryColor: .white,
        secondaryColor: Color(red: 0.0, green: 0.5, blue: 0.5, opacity: 1.0),
        designStyle: .minimal
      ),
      collectionDate: Date(),
      collectionLocation: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    ),
    Card(
      name: "Ethan Black",
      title: "Investment Analyst",
      company: "Finance Group",
      contactInformation: ContactInformation(
        email: "ethan@financegroup.com",
        phoneNumber: "+1 312 555 3456"
      ),
      businessAddress: Address(
        street: "221 Michigan Ave",
        city: "Chicago",
        state: "IL",
        postalCode: "60601",
        country: "USA"
      ),
      style: CardStyle(
        primaryColor: .white,
        secondaryColor: Color(red: 0.2, green: 0.2, blue: 0.4, opacity: 1.0),
        designStyle: .modern
      ),
      collectionDate: Date(),
      collectionLocation: CLLocationCoordinate2D(latitude: 41.8781, longitude: -87.6298)
    ),
    Card(
      name: "Fiona Blue",
      title: "Marketing Director",
      company: "Creative Agency",
      contactInformation: ContactInformation(
        email: "fiona@creativeagency.co",
        phoneNumber: "+1 303 555 7890",
        websiteURL: URL(string: "https://creativeagency.co")
      ),
      slogan: "Creating memorable brands",
      style: CardStyle(
        primaryColor: .white,
        secondaryColor: Color(red: 0.9, green: 0.4, blue: 0.0, opacity: 1.0),
        designStyle: .minimal
      ),
      collectionDate: Date(),
      collectionLocation: CLLocationCoordinate2D(latitude: 39.7392, longitude: -104.9903)
    ),
    Card(
      name: "George Yellow",
      title: "Supply Chain Manager",
      company: "Logistics Co",
      contactInformation: ContactInformation(
        email: "george@logisticsco.com",
        phoneNumber: "+1 206 555 2345"
      ),
      businessAddress: Address(
        city: "Seattle",
        state: "WA",
        country: "USA"
      ),
      style: CardStyle(
        primaryColor: .white,
        secondaryColor: Color(red: 0.9, green: 0.8, blue: 0.0, opacity: 1.0),
        designStyle: .modern
      ),
      collectionDate: Date(),
      collectionLocation: CLLocationCoordinate2D(latitude: 47.6062, longitude: -122.3321)
    ),
    Card(
      name: "Hannah Purple",
      title: "Curriculum Developer",
      role: "Education",
      company: "Education Org",
      contactInformation: ContactInformation(
        email: "hannah@eduorg.edu",
        phoneNumber: "+1 617 555 8901"
      ),
      style: CardStyle(
        primaryColor: .white,
        secondaryColor: Color(red: 0.6, green: 0.2, blue: 0.8, opacity: 1.0),
        designStyle: .minimal
      ),
      collectionDate: Date(),
      collectionLocation: CLLocationCoordinate2D(latitude: 42.3601, longitude: -71.0589)
    ),
    Card(
      name: "Ian Orange",
      title: "Store Manager",
      company: "Retail Group",
      contactInformation: ContactInformation(
        email: "ian@retailgroup.com",
        phoneNumber: "+1 512 555 6789"
      ),
      style: CardStyle(
        primaryColor: .white,
        secondaryColor: Color(red: 1.0, green: 0.5, blue: 0.0, opacity: 1.0),
        designStyle: .modern
      ),
      collectionDate: Date(),
      collectionLocation: CLLocationCoordinate2D(latitude: 30.2672, longitude: -97.7431)
    ),
    Card(
      name: "Julia Pink",
      title: "Event Coordinator",
      company: "Entertainment Inc",
      contactInformation: ContactInformation(
        email: "julia@entertainment.com",
        phoneNumber: "+1 305 555 4567",
        websiteURL: URL(string: "https://entertainment.com/events")
      ),
      businessAddress: Address(
        city: "Miami",
        state: "FL",
        country: "USA"
      ),
      style: CardStyle(
        primaryColor: .white,
        secondaryColor: Color(red: 0.9, green: 0.4, blue: 0.6, opacity: 1.0),
        designStyle: .minimal
      ),
      collectionDate: Date(),
      collectionLocation: CLLocationCoordinate2D(latitude: 25.7617, longitude: -80.1918)
    ),
    Card(
      name: "Kevin Gray",
      title: "Project Manager",
      company: "Construction Ltd",
      contactInformation: ContactInformation(
        email: "kevin@constructionltd.com",
        phoneNumber: "+1 602 555 3456"
      ),
      slogan: "Building the future",
      style: CardStyle(
        primaryColor: .white,
        secondaryColor: Color(red: 0.5, green: 0.5, blue: 0.5, opacity: 1.0),
        designStyle: .modern
      ),
      collectionDate: Date(),
      collectionLocation: CLLocationCoordinate2D(latitude: 33.4484, longitude: -112.0740)
    ),
    Card(
      name: "Laura Silver",
      title: "Business Analyst",
      company: "Consulting Firm",
      contactInformation: ContactInformation(
        email: "laura@consultingfirm.com",
        phoneNumber: "+1 202 555 7654",
        linkedInURL: URL(string: "https://linkedin.com/in/laurasilver")
      ),
      style: CardStyle(
        primaryColor: .white,
        secondaryColor: Color(red: 0.75, green: 0.75, blue: 0.8, opacity: 1.0),
        designStyle: .minimal
      ),
      collectionDate: Date(),
      collectionLocation: CLLocationCoordinate2D(latitude: 38.9072, longitude: -77.0369)
    ),
    Card(
      name: "Mike Gold",
      title: "Environmental Engineer",
      company: "Energy Corp",
      contactInformation: ContactInformation(
        email: "mike@energycorp.com",
        phoneNumber: "+1 713 555 9876"
      ),
      businessAddress: Address(
        city: "Houston",
        state: "TX",
        country: "USA"
      ),
      style: CardStyle(
        primaryColor: .white,
        secondaryColor: Color(red: 0.85, green: 0.7, blue: 0.2, opacity: 1.0),
        designStyle: .modern
      ),
      collectionDate: Date(),
      collectionLocation: CLLocationCoordinate2D(latitude: 29.7604, longitude: -95.3698)
    ),
    Card(
      name: "Nina Bronze",
      title: "Tour Planner",
      company: "Travel Agency",
      contactInformation: ContactInformation(
        email: "nina@travelagency.com",
        phoneNumber: "+1 503 555 8765",
        websiteURL: URL(string: "https://travelagency.com")
      ),
      slogan: "Explore the world with us",
      style: CardStyle(
        primaryColor: .white,
        secondaryColor: Color(red: 0.6, green: 0.4, blue: 0.2, opacity: 1.0),
        designStyle: .minimal
      ),
      collectionDate: Date(),
      collectionLocation: CLLocationCoordinate2D(latitude: 45.5231, longitude: -122.6765)
    ),
    Card(
      name: "Oscar Copper",
      title: "Property Manager",
      company: "Real Estate",
      contactInformation: ContactInformation(
        email: "oscar@realestate.com",
        phoneNumber: "+1 702 555 5432"
      ),
      businessAddress: Address(
        city: "Las Vegas",
        state: "NV",
        country: "USA"
      ),
      style: CardStyle(
        primaryColor: .white,
        secondaryColor: Color(red: 0.7, green: 0.4, blue: 0.3, opacity: 1.0),
        designStyle: .modern
      ),
      collectionDate: Date(),
      collectionLocation: CLLocationCoordinate2D(latitude: 36.1699, longitude: -115.1398)
    ),
    Card(
      name: "Paula Steel",
      title: "Hotel Manager",
      company: "Hospitality Group",
      contactInformation: ContactInformation(
        email: "paula@hospitalitygroup.com",
        phoneNumber: "+1 323 555 2468"
      ),
      businessAddress: Address(
        city: "Los Angeles",
        state: "CA",
        country: "USA"
      ),
      style: CardStyle(
        primaryColor: .white,
        secondaryColor: Color(red: 0.4, green: 0.4, blue: 0.5, opacity: 1.0),
        designStyle: .minimal
      ),
      collectionDate: Date(),
      collectionLocation: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437)
    ),
    Card(
      name: "Quinn Bronze",
      title: "Community Outreach",
      company: "Nonprofit Org",
      contactInformation: ContactInformation(
        email: "quinn@nonprofitorg.org",
        phoneNumber: "+1 312 555 1357"
      ),
      slogan: "Making a difference together",
      style: CardStyle(
        primaryColor: .white,
        secondaryColor: Color(red: 0.6, green: 0.5, blue: 0.3, opacity: 1.0),
        designStyle: .modern
      ),
      collectionDate: Date(),
      collectionLocation: CLLocationCoordinate2D(latitude: 41.8781, longitude: -87.6298)
    ),
    Card(
      name: "Rachel Silver",
      title: "Product Designer",
      company: "Tech Startup",
      contactInformation: ContactInformation(
        email: "rachel@techstartup.io",
        phoneNumber: "+1 415 555 2468",
        linkedInURL: URL(string: "https://linkedin.com/in/rachelsilver")
      ),
      style: CardStyle(
        primaryColor: .white,
        secondaryColor: Color(red: 0.7, green: 0.7, blue: 0.8, opacity: 1.0),
        designStyle: .minimal
      ),
      collectionDate: Date(),
      collectionLocation: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    ),
    Card(
      name: "Sam Gold",
      title: "Logistics Coordinator",
      company: "Shipping Co",
      contactInformation: ContactInformation(
        email: "sam@shippingco.com",
        phoneNumber: "+1 650 555 3692"
      ),
      style: CardStyle(
        primaryColor: .white,
        secondaryColor: Color(red: 0.8, green: 0.6, blue: 0.4, opacity: 1.0),
        designStyle: .modern
      ),
      collectionDate: Date(),
      collectionLocation: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    ),
  ]
}
