import SwiftUI

struct Tabs: View {
    @State private var selectedTab = 1

    var body: some View {
        TabView(selection: $selectedTab) {
            VStack {
                Text("Welcome Home!")
                    .font(.largeTitle)
                    .padding()
                Image(systemName: "house.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(1)

            VStack {
                Text("Your Favorite Items")
                    .font(.largeTitle)
                    .padding()
                Image(systemName: "heart.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.red)
            }
            .tabItem {
                Label("Favorites", systemImage: "heart.fill")
            }
            .tag(2)

            VStack {
                Text("App Settings")
                    .font(.largeTitle)
                    .padding()
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape.fill")
            }
            .tag(3)

            VStack {
                Text("Your Profile")
                    .font(.largeTitle)
                    .padding()
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.green)
            }
            .tabItem {
                Label("Profile", systemImage: "person.crop.circle.fill")
            }
            .tag(4)
        }
        .accentColor(.purple) // Uncomment to change the selected tab's tint color
    }
}

struct Tabs_Previews: PreviewProvider {
    static var previews: some View {
        Tabs()
    }
}
