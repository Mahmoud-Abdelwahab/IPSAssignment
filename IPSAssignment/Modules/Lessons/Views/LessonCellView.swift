//
//  LessonCellView.swift
//  IPSAssignment
//
//  Created by Mahmoud Abdulwahab on 22/03/2023.
//

import SwiftUI
import Kingfisher

struct LessonCellView: View {
    let url: URL
    init(url: URL) {
        self.url = url
    }
    
    var body: some View {
        HStack {
            KFImage.url(url)
                .placeholder({
                    ProgressView()
                })
                .resizable()
                .fade(duration: 0.25)
                .cornerRadius(4)
                .frame(width: 110, height: 60)
            
            Text("The key to success iphone photography")
                .fontWeight(.semibold)
                .font(.subheadline)
                .padding(.leading, 5)
                .lineLimit(3)
                .foregroundColor(Color(#colorLiteral(red: 0.9215686321, green: 0.9215685725, blue: 0.9215685725, alpha: 1)))
            
            Spacer()
            Image(systemName: "chevron.right")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .background()
                .frame(width: 6)
                .padding(.trailing, 8)
                .foregroundColor(.accentColor)
        }
    }
}

struct LessonCellView_Previews: PreviewProvider {
    static var previews: some View {
        LessonCellView(url: URL(string: "https://ipsmedia.notion.site/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2Fb9fd02c6-f567-4e17-8bb0-27e1b07f33a6%2FiOS-design.png?id=5743fac0-7002-409a-8364-eede144c4a9a&table=block&spaceId=18c2b86f-5f00-4ff1-baf7-6be563e77c7d&width=2000&userId=&cache=v2")!)
    }
}
