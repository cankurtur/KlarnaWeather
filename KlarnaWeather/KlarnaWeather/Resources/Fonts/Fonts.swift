//
//  Fonts.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 27.07.2024.
//

import SwiftUI

extension Font {
    static var extraLarge: Font {
        .system(size: 50, weight: .medium)
    }
    
    static var primaryHeadline: Font {
        .system(size: 32, weight: .medium)
    }
    
    static var primaryTitle: Font {
        .system(size: 26, weight: .bold)
    }
    
    static var secondaryTitle: Font {
        .system(size: 18, weight: .regular)
    }

    static var primaryMidTitle: Font {
        .system(size: 18, weight: .regular)
    }
    
    static var secondaryMidTitle: Font {
        .system(size: 18, weight: .bold)
    }
    
    static var primarySmallTitle: Font {
        .system(size: 14, weight: .semibold)
    }
    
    static var secondarySmallTitle: Font {
        .system(size: 12, weight: .regular)
    }
}
