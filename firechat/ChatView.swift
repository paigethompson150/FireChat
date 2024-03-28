//
//  ChatView.swift
//  firechat
//
//  Created by Paige Thompson on 3/28/24.
//

import SwiftUI

struct ChatView: View {
    
    @State var messageManager: MessageManager
    
    init(isMocked: Bool = false) {
        messageManager = MessageManager(isMocked: isMocked)
    }
    // TODO: Access authManager from the environment
    @Environment(AuthManager.self) var authManager
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(messageManager.messages) { message in // <-- Add ForEach, accessing the messages property of the message manager
                        MessageRow(text: message.text, isOutgoing: authManager.userEmail == message.username) // <-- Display the text for each message
                    }
                }
            }
            .defaultScrollAnchor(.bottom)
            .toolbar {
                ToolbarItem {
                    Button("Sign out") {
                        authManager.signOut()
                    }
                }
            }
            .safeAreaInset(edge: .bottom) { // <-- Add safeAreaInset modifier to add and display send message view above the bottom safe area
                SendMessageView { messageText in // <-- Add SendMessageView
                    // TODO: Save message to Firestore
                    messageManager.sendMessage(text: messageText, username: authManager.userEmail ?? "")
                    
                }
            }
        }
    }
    
    #Preview {
        ChatView(isMocked: true)
            .environment(AuthManager(isMocked: true))
    }
}



    
struct MessageRow: View {
        let text: String // <-- The message text
        let isOutgoing: Bool // <-- true if sent by the current user
        
        var body: some View {
            HStack {
                if isOutgoing {
                    Spacer() // <-- Spacer shifts message bubble to the right for outgoing messages
                }
                messageBubble // <-- The message bubble
                if !isOutgoing {
                    Spacer() // <-- Spacer shifts message bubble to the left for incoming messages
                }
            }
        }
        
        private var messageBubble: some View {
            Text(text)
                .fixedSize(horizontal: false, vertical: true) // <-- Allow message text to expand and wrap vertically if needed
                .foregroundStyle(isOutgoing ? .white : .primary) // <-- Set the text color based on outgoing status
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20.0) // <-- Add bubble shape to the background
                        .fill(isOutgoing ? Color.blue.gradient : Color(.systemGray5).gradient) // <-- Set bubble color based on outgoing status
                )
                .padding(isOutgoing ? .trailing : .leading, 12) // <-- Set padding based on outgoing status
                .containerRelativeFrame(.horizontal, count: 7, span: 5, spacing: 0, alignment: isOutgoing ? .trailing : .leading) // <-- Set message size relative to container (the scroll view width in this case)
        }
    }




struct SendMessageView: View {
    var onSend: (String) -> Void // <-- Closure called with a message passed in when send message button is tapped

    @State private var messageText: String = "" // <-- Local state managed var to hold the message text as user types

    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            TextField("Message", text: $messageText, axis: .vertical) // <-- Message text field
                .padding(.leading)
                .padding(.trailing, 4)
                .padding(.vertical, 8)

            // Send message button
            Button {
                onSend(messageText) // <-- Call onSend closure passing in the message text when send button is tapped
                messageText = "" // <-- Clear the message text after being sent
            } label: {
                Image(systemName: "arrow.up.circle.fill") // <-- Use arrow image from SFSymbols
                    .resizable()
                    .frame(width: 30, height: 30)
                    .bold()
                    .padding(4)
            }
            .disabled(messageText.isEmpty) // <-- Disable button if text is empty
        }
        .overlay(RoundedRectangle(cornerRadius: 19).stroke(Color(uiColor: .systemGray2)))
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(.thickMaterial) // <-- Add material to background
        //        .focused($isMessageFieldFocused)
    }
}
