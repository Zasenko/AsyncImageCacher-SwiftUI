//
//  ContentView.swift
//  AsyncImageCacher SwiftUI
//
//  Created by Dmitry Zasenko on 15.12.22.
//

import SwiftUI

struct ContentView: View {
    
    let url = "https://www.unilad.co.uk/wp-content/uploads/2019/12/CATERS_HAPPY_WAVING_SEAL_02.jpg"
    
    var body: some View {
        VStack {
            CachedImage(url: url, animation: .spring(), transition: .scale.combined(with: .opacity)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                case .failure(let error):
                    Image(systemName: "xmark")
                        .symbolVariant(.circle.fill)
                        .foregroundColor(.white)
                        .frame(width: 100, height: 100)
                        .background(.blue, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                @unknown default:
                    EmptyView()
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
