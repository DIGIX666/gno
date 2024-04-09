package library

import (
	"std"
	"testing"
	"gno.land/p/demo/library"
)

func contains(str, substr string) bool {
	if len(substr) == 0 {
		return true
	}
	for i := 0; i <= len(str)-len(substr); i++ {
		if str[i:i+len(substr)] == substr {
			return true
		}
	}
	return false
}

func TestRender(t *testing.T) {
	var l library.Library
	l.AddBook("101", "Realm Book", "Realm Author")
	output := Render("some path or filter")
	expectedOutputContains := "Welcome to the library"
	if !contains(output, expectedOutputContains) {
		t.Errorf("Render output does not contain expected text. Expected to find '%s', got '%s'", expectedOutputContains, output)
	}
}

func TestAddBookThroughRealm(t *testing.T) {
	message := AddBook("202", "Realm Book 2", "Realm Author 2")
	expectedMessage := "Book added successfully"
	if message != expectedMessage {
		t.Errorf("Unexpected message from AddBook. Expected '%s', got '%s'", expectedMessage, message)
	}

	// Verify if the book was actually added
	output := Render("some path or filter")
	expectedOutputContains := "Realm Book 2"
	if !contains(output, expectedOutputContains) {
		t.Errorf("Book was not added. Render output does not contain expected book title. Expected to find '%s'", expectedOutputContains)
	}
}

func TestBorrowBookThroughRealm(t *testing.T) {
	var l library.Library
	l.AddBook("303", "Realm Book 3", "Realm Author 3")
	message := l.BorrowBook("303", "g1testaddress") // Ensure it operates on the instance `l`
	expectedMessage := "Book borrowed successfully"
	if message != expectedMessage {
		t.Errorf("Unexpected message from BorrowBook. Expected '%s', got '%s'", expectedMessage, message)
	}
}

func TestReturnBookThroughRealm(t *testing.T) {
	var l library.Library
	l.AddBook("404", "Realm Book 4", "Realm Author 4")
	messageBorrow := l.BorrowBook("404", "g1testaddress") // Ensure borrowing before returning
	if messageBorrow != "Book borrowed successfully" {
		t.Fatalf("Setup failed: borrowing the book failed.")
	}
	messageReturn := l.ReturnBook("404")
	expectedMessage := "Book returned successfully"
	if messageReturn != expectedMessage {
		t.Errorf("Unexpected message from ReturnBook. Expected '%s', got '%s'", expectedMessage, messageReturn)
	}
}
