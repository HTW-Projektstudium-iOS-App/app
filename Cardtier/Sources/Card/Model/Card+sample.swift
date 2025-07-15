import CoreLocation
import SwiftUI

extension Card {
  static var sampleCards: [Card] = [
    Card(
      name: "Klaus‑Michael Kühne",
      title: "Honorary Chairman",
      company: "Kühne + Nagel",
      contactInformation: ContactInformation(
        email: "info@kn-portal.com",
        phoneNumber: "+49 40 0000000"
      ),
      businessAddress: Address(city: "Hamburg", country: "Germany"),
      style: CardStyle(
        primaryColor: Color(red: 0.96, green: 0.94, blue: 0.98),  // pastel lavender
        secondaryColor: Color(red: 0.3, green: 0.2, blue: 0.4),  // darker purple text
        fontName: "Helvetica", designStyle: .traditional
      ),
      collectionDate: Date(),
      collectionLocation: CLLocationCoordinate2D(latitude: 53.5511, longitude: 9.9937)
    ),
    Card(
      name: "Dieter Schwarz",
      title: "Owner & Former CEO",
      company: "Schwarz Gruppe (Lidl, Kaufland)",
      contactInformation: ContactInformation(
        email: "info@schwarz-gruppe.de",
        phoneNumber: "+49 7131 3500"
      ),
      businessAddress: Address(city: "Heilbronn", country: "Germany"),
      slogan: "Voraushandeln statt nur vorausdenken.",
      style: CardStyle(
        primaryColor: Color(red: 0.98, green: 0.96, blue: 0.92),  // pastel peach
        secondaryColor: Color(red: 0.3, green: 0.2, blue: 0.3),  // dark muted purple
        fontName: "Arial", designStyle: .modern
      ),
      collectionDate: Date(),
      collectionLocation: CLLocationCoordinate2D(latitude: 49.1427, longitude: 9.2100)
    ),
    Card(
      name: "Georg Schaeffler",
      title: "Chairman",
      company: "Schaeffler Group",
      contactInformation: ContactInformation(
        email: "info@schaeffler.com",
        phoneNumber: "+49 9131 540"
      ),
      businessAddress: Address(city: "Herzogenaurach", country: "Germany"),
      slogan: "We pioneer motion.",

      style: CardStyle(
        primaryColor: Color(red: 0.94, green: 0.98, blue: 0.96),  // pastel mint
        secondaryColor: Color(red: 0.2, green: 0.3, blue: 0.2),  // dark forest green
        fontName: "Futura", designStyle: .modern
      ),
      collectionDate: Date(),
      collectionLocation: CLLocationCoordinate2D(latitude: 49.5711, longitude: 10.9275)
    ),
    Card(
      name: "Stefan Quandt",
      title: "Deputy Chairman",
      company: "BMW / Delton AG",
      contactInformation: ContactInformation(
        email: "contact@delton.de",
        phoneNumber: "+49 6131 1920"
      ),
      businessAddress: Address(city: "Bad Homburg", country: "Germany"),
      style: CardStyle(
        primaryColor: Color(red: 0.92, green: 0.96, blue: 0.98),  // pastel blue
        secondaryColor: Color(red: 0.05, green: 0.1, blue: 0.2),  // navy text
        fontName: "Verdana", designStyle: .minimal
      ),
      collectionDate: Date(),
      collectionLocation: CLLocationCoordinate2D(latitude: 50.2339, longitude: 8.6196)
    ),
    Card(
      name: "Alexander Otto",
      title: "CEO",
      company: "ECE Group (Otto Group)",
      contactInformation: ContactInformation(
        email: "info@ece.de",
        phoneNumber: "+49 40 60600"
      ),
      businessAddress: Address(city: "Hamburg", country: "Germany"),
      style: CardStyle(
        primaryColor: Color(red: 0.98, green: 0.94, blue: 0.96),  // pastel pink
        secondaryColor: Color(red: 0.3, green: 0.2, blue: 0.3),  // dark plum
        fontName: "Times New Roman", designStyle: .traditional
      ),
      collectionDate: Date(),
      collectionLocation: CLLocationCoordinate2D(latitude: 53.5511, longitude: 9.9937)
    ),
    Card(
      name: "Reinhold Würth",
      title: "Honorary Chairman",
      company: "Würth Group",
      contactInformation: ContactInformation(
        email: "info@wuerth.com",
        phoneNumber: "+49 7940 15-0"
      ),
      businessAddress: Address(city: "Künzelsau", country: "Germany"),
      style: CardStyle(
        primaryColor: Color(red: 0.96, green: 0.92, blue: 0.98),
        secondaryColor: Color(red: 0.25, green: 0.15, blue: 0.35),
        fontName: "Helvetica", designStyle: .traditional
      ),
      collectionDate: Date(),
      collectionLocation: CLLocationCoordinate2D(latitude: 49.1911, longitude: 9.6986)
    ),
    Card(
      name: "Susanne Klatten",
      title: "Major Shareholder",
      company: "BMW, Altana, SGL Carbon",
      contactInformation: ContactInformation(
        email: "contact@altana.com",
        phoneNumber: "+49 2166 51-0"
      ),
      businessAddress: Address(city: "Wesel", country: "Germany"),
      style: CardStyle(
        primaryColor: Color(red: 0.98, green: 0.96, blue: 0.94),
        secondaryColor: Color(red: 0.2, green: 0.1, blue: 0.2),
        fontName: "Palatino", designStyle: .minimal
      ),
      collectionDate: Date(),
      collectionLocation: CLLocationCoordinate2D(latitude: 51.6595, longitude: 6.6236)
    ),
    Card(
      name: "Theo Albrecht Jr.",
      title: "Owner & Chairman",
      company: "Aldi Nord & Trader Joe's",
      contactInformation: ContactInformation(
        email: "info@aldi-nord.de",
        phoneNumber: "+49 4631 9820"
      ),
      businessAddress: Address(city: "Essen", country: "Germany"),
      slogan: "Gutes für alle.",

      style: CardStyle(
        primaryColor: Color(red: 0.92, green: 0.98, blue: 0.94),
        secondaryColor: Color(red: 0.1, green: 0.2, blue: 0.1),
        fontName: "Arial", designStyle: .modern
      ),
      collectionDate: Date(),
      collectionLocation: CLLocationCoordinate2D(latitude: 51.4556, longitude: 7.0116)
    ),
    Card(
      name: "Martin Viessmann",
      title: "CEO",
      company: "Viessmann Group",
      contactInformation: ContactInformation(
        email: "info@viessmann.com",
        phoneNumber: "+49 6462 980"
      ),
      businessAddress: Address(city: "Allendorf (Eder)", country: "Germany"),
      style: CardStyle(
        primaryColor: Color(red: 0.94, green: 0.98, blue: 0.94),
        secondaryColor: Color(red: 0.1, green: 0.2, blue: 0.1),
        fontName: "Courier", designStyle: .traditional
      ),
      collectionDate: Date(),
      collectionLocation: CLLocationCoordinate2D(latitude: 51.078, longitude: 8.672)
    ),
    Card(
      name: "Hasso Plattner",
      title: "Co‑Founder",
      company: "SAP",
      contactInformation: ContactInformation(
        email: "info@sap.com",
        phoneNumber: "+49 6227 747474"
      ),
      businessAddress: Address(city: "Walldorf", country: "Germany"),
      slogan: "Run simple.",
      style: CardStyle(
        primaryColor: Color(red: 0.96, green: 0.94, blue: 0.98),
        secondaryColor: Color(red: 0.2, green: 0.1, blue: 0.3),
        fontName: "GillSans", designStyle: .modern
      ),
      collectionDate: Date(),
      collectionLocation: CLLocationCoordinate2D(latitude: 49.2931, longitude: 8.6472)
    ),
    Card(
      name: "Andreas Strüngmann",
      title: "Co‑Founder",
      company: "Hexal / BioNTech",
      contactInformation: ContactInformation(
        email: "info@biontech.de",
        phoneNumber: "+49 89 4140 4300"
      ),
      businessAddress: Address(city: "Mainz", country: "Germany"),
      style: CardStyle(
        primaryColor: Color(red: 0.92, green: 0.96, blue: 0.98),
        secondaryColor: Color(red: 0.1, green: 0.1, blue: 0.3),
        fontName: "Avenir", designStyle: .minimal
      ),
      collectionDate: Date(),
      collectionLocation: CLLocationCoordinate2D(latitude: 49.9929, longitude: 8.2473)
    ),
    Card(
      name: "Thomas Strüngmann",
      title: "Co‑Founder",
      company: "Hexal / BioNTech",
      contactInformation: ContactInformation(
        email: "info@hexal.com",
        phoneNumber: "+49 89 4140 4300"
      ),
      businessAddress: Address(city: "Mainz", country: "Germany"),
      slogan: "Gesundheit von Menschen weltweit verbessern.",
      style: CardStyle(
        primaryColor: Color(red: 0.96, green: 0.98, blue: 0.92),
        secondaryColor: Color(red: 0.2, green: 0.1, blue: 0.2),
        fontName: "Verdana", designStyle: .modern
      ),
      collectionDate: Date(),
      collectionLocation: CLLocationCoordinate2D(latitude: 49.9929, longitude: 8.2473)
    ),
    Card(
      name: "Beate Heister",
      title: "Co‑Owner",
      company: "Aldi Süd",
      contactInformation: ContactInformation(
        email: "contact@aldi-sued.de",
        phoneNumber: "+49 201 85900"
      ),
      businessAddress: Address(city: "Essen", country: "Germany"),
      style: CardStyle(
        primaryColor: Color(red: 0.94, green: 0.92, blue: 0.98),
        secondaryColor: Color(red: 0.3, green: 0.1, blue: 0.3),
        fontName: "Palatino", designStyle: .traditional
      ),
      collectionDate: Date(),
      collectionLocation: CLLocationCoordinate2D(latitude: 51.4556, longitude: 7.0116)
    ),
    Card(
      name: "Michael Otto",
      title: "Honorary Chairman",
      company: "Otto Group",
      contactInformation: ContactInformation(
        email: "info@ottogroup.com",
        phoneNumber: "+49 40 646140"
      ),
      businessAddress: Address(city: "Hamburg", country: "Germany"),
      style: CardStyle(
        primaryColor: Color(red: 0.98, green: 0.96, blue: 0.92),
        secondaryColor: Color(red: 0.2, green: 0.3, blue: 0.4),
        fontName: "CenturyGothic", designStyle: .minimal
      ),
      collectionDate: Date(),
      collectionLocation: CLLocationCoordinate2D(latitude: 53.5511, longitude: 9.9937)
    ),
  ]
}
