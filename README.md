# 🌁 ZoomableScrollView

## ✔️ Example
```swift
struct ContentView: View {
    
    var body: some View {
        TabView {
            ZoomableScrollView {
                Image("sample1")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
            }
            ZoomableScrollView {
                Image("sample2")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
            }
            ZoomableScrollView {
                Image("sample3")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
            }
        }.tabViewStyle(.page(indexDisplayMode: .never))
    }
}
```
