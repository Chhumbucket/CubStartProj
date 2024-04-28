//
//  JournalView.swift
//  TurnPages
//
//  Created by Carolyn Lin on 4/26/24.
//

import Foundation
import SwiftUI

struct FileItem: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var children: [FileItem]? = nil
    var contents: String

    var type: String {
        getFileType(fileName: name)
    }

    private func getFileType(fileName: String) -> String {
        if fileName.hasSuffix(".jpg") {
            return "photo"
        } else if fileName.hasSuffix(".txt") {
            return "doc"
        } else if fileName.hasSuffix(".mp4") {
            return "film"
        } else {
            return "folder"
        }
    }
}

struct JournalView: View {
    @State private var files: [FileItem] = [
        FileItem(name: "Users", children: [
            FileItem(name: "guest", children: [
                FileItem(name: "Photos", children: [FileItem(name: "photo001.jpg", contents: "")], contents: ""),
                FileItem(name: "Movies", children: [FileItem(name: "movie001.mp4", contents: "")], contents: ""),
                FileItem(name: "Documents", children: [FileItem(name: "document.txt", contents: "")], contents: "")
            ], contents: "")
        ], contents: ""),
        FileItem(name: "Shared", contents: "")
    ]
    @State private var selectedFile: FileItem?
    @State private var showingAddFileSheet = false

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        showingAddFileSheet = true
                    }, label:
                            {
                        Image(systemName: "plus")
                            .font(.system(size:30))
                            .bold()
                            .foregroundStyle(.yellow)
                    })
                }
                .padding()
                .sheet(isPresented: $showingAddFileSheet) {
                    AddFileItemView(files: $files)
                }

                List(files, children: \.children) { file in
                    Button(file.name) {
                        selectedFile = file
                    }
                    .sheet(item: $selectedFile) { detail in
                        EditFileView(content: detail.contents, files: $files, name: detail.name)
                    }
                }
            }
        }
    }
}

struct EditFileView: View {
    @FocusState private var focusedField: FocusedField?
    @State var content: String
    @Binding var files: [FileItem]
    var name: String

    var body: some View {
        VStack {
            TextField("Edit file content", text: $content)
                .focused($focusedField, equals: .contents)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            updateContents(files: &files, filename: name, newContents: content)
                        }
                    }
                }
        }
        .padding()
    }
    
    enum FocusedField {
        case contents
    }
}

struct AddFileItemView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var files: [FileItem]
    @State private var selectedDirectory: String = "root"
    @State private var selectedFileType: String = "Folder"
    @State private var fileName: String = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("File Name", text: $fileName)
                Picker("File Type", selection: $selectedFileType) {
                    Text("Folder").tag("Folder")
                    Text("Text").tag("Text")
                    Text("Image").tag("Image")
                    Text("Video").tag("Video")
                }
                Button("Add") {
                    let newFile = FileItem(name: fileName + resolveFileExtension(type: selectedFileType), contents: "")
                    insertNewFile(files: &files, parentDirectoryName: selectedDirectory, newFile: newFile)
                    dismiss()
                }
            }
            .navigationTitle("Add New File")
        }
    }
    
    func resolveFileExtension(type: String) -> String {
        switch type.lowercased() {
        case "text": return ".txt"
        case "image": return ".jpg"
        case "video": return ".mp4"
        default: return ""
        }
    }
}

//helpers
func getFileType(fileName: String) -> String {
    /* Given the file name as a string, returns the name of the corresponding SF symbol for the file type.
     
     Example:
     - getFileType(".jpg") -> "photo"
     - getFileType(".txt") -> "doc"
     - getFileType(".mp4") -> "film"
     - getFileType(".py") -> "folder"
     */
    if fileName.hasSuffix(".jpg") {
        return "photo"
    } else if fileName.hasSuffix(".txt"){
        return "doc"
    } else if fileName.hasSuffix(".mp4") {
        return "film"
    }
    return "folder"
}

func updateContents(files: inout [FileItem], filename: String, newContents: String) -> Bool {
    /* Updates the file contents of the file with 'filename' inside 'files' with 'newContents'.
     Returns true if contents were sucessfully updated. False otherwise.
     
     Example Usage:
     updateContents(files: &myFiles, filename: file.name, newContents: file.contents) -> true
     */
    for (index, file) in files.enumerated() {
        if file.name == filename {
            files[index].contents = newContents
            return true
        }
        
        // Recurse
        if let numChildren = files[index].children?.count, numChildren > 0 {
            if updateContents(files: &files[index].children!, filename: filename, newContents: newContents) {
                return true
            }
        }
    }
    return false
}

func insertNewFile(files: inout [FileItem], parentDirectoryName: String, newFile: FileItem) -> Bool {
    /* Inserts 'newFile' into the 'files' array. Specifically, the new FileItem is inserted in the folder with
     name 'parentDirectoryName'. Returns true if file was successfully inserted. False otherwise.
     
     Example Usage:
     insertNewFile(files: &myFiles, parentDirectoryName: "root", newFile: FileItem(name:"newFolder", contents: "")
     */
    
    // Root case
    if parentDirectoryName == "root" {
        files.append(newFile)
        return true
    }
    
    for (index, file) in files.enumerated() {
        // Add to directory
        if file.name == parentDirectoryName {
            if let _ = files[index].children {
                files[index].children!.append(newFile)
            } else {
                files[index].children = [newFile]
            }
            return true
        }
        
        // Recurse
        if let numChildren = files[index].children?.count, numChildren > 0 {
            if (insertNewFile(files: &files[index].children!, parentDirectoryName: parentDirectoryName, newFile: newFile)) {
                return true
            }
        }
    }
    return false
}

func getDirectoryNames(files: [FileItem]) -> [String] {
    /* Returns a list of the names of all directories in the file system excluding the root directory. */
    
    var directoryNames: [String] = []
    for file in files {
        if file.type == "folder" {
            directoryNames.append(file.name)
            
            // Recurse
            if let _ = file.children {
                directoryNames += getDirectoryNames(files: file.children!)
            }
        }
    }

    return directoryNames
}

func resolveFileExtension(type: String) -> String {
    /* Given a verbose file type string, returns the corresponding file extension.
     
     Example: resolveFileExtension("Text") -> ".txt"
     */
    if type.lowercased() == "text" {
        return ".txt"
    } else if type.lowercased() == "image" {
        return ".jpg"
    } else if type.lowercased() == "video" {
        return ".mp4"
    } else {
        return ""
    }
}

