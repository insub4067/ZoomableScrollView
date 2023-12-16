# 🌁 ZoomableScrollView

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![Static Badge](https://img.shields.io/badge/iOS-v13-blue)
![Static Badge](https://img.shields.io/badge/Swift-5.4-orange)

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
