//
//  TagView.swift
//  News
//
//  Created by Asil Arslan on 21.12.2020.
//

import SwiftUI

struct TagView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @State var selectedTags = [Tag]()
    @State var showAlert = false
    @Binding var showMenu : Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                FlexibleView(
                    data: mainViewModel.tags,
                    spacing: 8,
                    alignment: .leading
                ) { item in
                    Button(action: {
                        if let index = selectedTags.firstIndex(where: {$0.id == item.id}){
                            selectedTags.remove(at: index)
                        }else{
                            selectedTags.append(item)
                        }
                    }) {
                        Text(verbatim: item.name)
                            .foregroundColor(Color("customBlack"))
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(isInclude(item.id) ? Color.accentColor.opacity(0.2) : Color.gray.opacity(0.2))
                            )
                    }
                    
                }
                .padding(.horizontal, 8)
            }
            .navigationBarTitle(LocalizedStringKey("Tag"))
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        withAnimation{

                            self.showMenu.toggle()
                        }
                    }, label: {

                        Image(systemName: self.showMenu ? "xmark" : "line.horizontal.3")
                            .font(.title2)
                    })
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: {
//                        if selectedTags.count == 0 {
//                            showAlert.toggle()
//                        }else{
//
//                        }
//                    }) {
                    NavigationLink(destination: TagNewsView(tags:selectedTags)) {
                        Text("Next")
                    }
                        
//                    }
                }
            })
        }
        // prevent iPad split view
        .navigationViewStyle(StackNavigationViewStyle())
//        .onAppear(){
//            loadeData()
//        }
        .alert(isPresented: $showAlert) { () -> Alert in
            Alert(title: Text("Select Tag!"))
        }
    }
    
    func isInclude(_ id: Int) -> Bool{
        if selectedTags.firstIndex(where: {$0.id == id}) != nil{
            return true
        }
        return false
    }

}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView( showMenu: .constant(false))
    }
}

struct FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content
    @State private var availableWidth: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: alignment, vertical: .center)) {
            Color.clear
                .frame(height: 1)
                .readSize { size in
                    availableWidth = size.width
                }
            
            _FlexibleView(
                availableWidth: availableWidth,
                data: data,
                spacing: spacing,
                alignment: alignment,
                content: content
            )
        }
    }
}


struct _FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let availableWidth: CGFloat
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content
    @State var elementsSize: [Data.Element: CGSize] = [:]
    
    var body : some View {
        VStack(alignment: alignment, spacing: spacing) {
            ForEach(computeRows(), id: \.self) { rowElements in
                HStack(spacing: spacing) {
                    ForEach(rowElements, id: \.self) { element in
                        content(element)
                            .fixedSize()
                            .readSize { size in
                                elementsSize[element] = size
                            }
                    }
                }
            }
        }
    }
    
    func computeRows() -> [[Data.Element]] {
        var rows: [[Data.Element]] = [[]]
        var currentRow = 0
        var remainingWidth = availableWidth
        
        for element in data {
            let elementSize = elementsSize[element, default: CGSize(width: availableWidth, height: 1)]
            
            if remainingWidth - (elementSize.width + spacing) >= 0 {
                rows[currentRow].append(element)
            } else {
                currentRow = currentRow + 1
                rows.append([element])
                remainingWidth = availableWidth
            }
            
            remainingWidth = remainingWidth - (elementSize.width + spacing)
        }
        
        return rows
    }
}


extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
