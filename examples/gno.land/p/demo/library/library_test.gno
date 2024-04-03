package library

import (
	"std"
	"testing"

	"gno.land/p/demo/library"
)

func TestAddBook(t *testing.T) {
	AddBook("123", "Test Book", "Author Test")
	if len(Library) != 1 {
		t.Errorf("Book was not added. Expected library size 1, got %d", len(Library))
	}
}

func TestBorrowBook(t *testing.T) {
	AddBook("456", "Test Book 2", "Author Test 2")
	message := BorrowBook("456", "g1testaddress")
	if message != "Book borrowed successfully" {
		t.Errorf("Failed to borrow the book. Expected 'Book borrowed successfully', got '%s'", message)
	}
	if Library[1].Status != "borrowed" {
		t.Errorf("Book status was not updated to borrowed.")
	}
}

func TestReturnBook(t *testing.T) {
	AddBook("789", "Test Book 3", "Author Test 3")
	BorrowBook("789", "g1testaddress")
	message := ReturnBook("789")
	if message != "Book returned successfully" {
		t.Errorf("Failed to return the book. Expected 'Book returned successfully', got '%s'", message)
	}
	if Library[2].Status != "available" {
		t.Errorf("Book status was not updated to available.")
	}
}

func TestCheckBookStatus(t *testing.T) {
	AddBook("012", "Test Book 4", "Author Test 4")
	status, borrower := CheckBookStatus("012")
	if status != "available" || borrower != "" {
		t.Errorf("Status check failed. Expected status 'available' and empty borrower, got '%s' and '%s'", status, borrower)
	}
}
