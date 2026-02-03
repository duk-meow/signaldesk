//
//  SummaryView.swift
//  signaldesk
//
//  Created by KIET9 on 03/02/26.
//

import SwiftUI

struct SummaryView: View {
    var body: some View {
        VStack {
            Text("Summary")
                .font(.largeTitle)
            
            Text("AI-generated summaries coming soon")
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    SummaryView()
}
