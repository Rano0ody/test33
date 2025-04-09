import SwiftUI
import SwiftData

struct LogIn: View {
    @Environment(\.modelContext) private var modelContext

    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var navigateToHome = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 15) {
                Text("Welcome")
                    .font(.system(size: 50, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 50)
                
                Text("Good Evening")
                    .font(.custom("SF Pro Display", size: 25).weight(.regular))
                    .frame(maxWidth: .infinity, alignment: .center)
                
                // Email
                InputField(label: "Email", text: $email, placeholder: "Enter your email", isEmail: true)
                
                // Password
                InputField(label: "Password", text: $password, placeholder: "Enter your password", isSecure: true)
                
                // Show error message if any
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal, 24)
                }
                
                // Log In Button
                Button(action: logIn) {
                    Text("Log In")
                        .frame(maxWidth: .infinity)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                // Navigation link to home page
                NavigationLink(destination: SignUpView(), isActive: $navigateToHome) {
                    EmptyView()
                }

                Spacer()
                
                // Sign Up Section
                HStack {
                    Text("Don't have an account?")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    NavigationLink(destination: SignUpView()) {
                        Text("Sign Up")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 120)
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }

    private func logIn() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password are required."
            return
        }

        let descriptor = FetchDescriptor<UserData>(predicate: #Predicate {
            $0.email == email && $0.password == password
        })

        do {
            let result = try modelContext.fetch(descriptor)
            if let _ = result.first {
                navigateToHome = true
            } else {
                errorMessage = "Invalid email or password."
            }
        } catch {
            errorMessage = "An error occurred during login."
        }
    }
}

#Preview {
    LogIn()
        .modelContainer(for: [UserData.self])
}
