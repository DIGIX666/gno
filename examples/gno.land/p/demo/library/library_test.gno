package library

import (
	"std"
	"testing"
)

func TestAddBook(t *testing.T) {
	var l Library
	l.AddBook("123", "Test Book", "Author Test")
	if len(l.books) != 1 {
		t.Errorf("Book was not added. Expected library size 1, got %d", len(l.books))
	}
}

func TestBorrowBook(t *testing.T) {
	var l Library
	l.AddBook("456", "Test Book 2", "Author Test 2")
	borrowerAddress := std.Address("g1testaddress")
	message := l.BorrowBook("456", borrowerAddress)
	if message != "Book borrowed successfully" {
		t.Errorf("Failed to borrow the book. Expected 'Book borrowed successfully', got '%s'", message)
	}
	if l.books[0].Status != "borrowed" {
		t.Errorf("Book status was not updated to borrowed.")
	}
}

func TestReturnBook(t *testing.T) {
	var l Library
	l.AddBook("789", "Test Book 3", "Author Test 3")
	l.BorrowBook("789", std.Address("g1testaddress"))
	message := l.ReturnBook("789")
	if message != "Book returned successfully" {
		t.Errorf("Failed to return the book. Expected 'Book returned successfully', got '%s'", message)
	}
	if l.books[0].Status != "available" {
		t.Errorf("Book status was not updated to available.")
	}
}

func TestCheckBookStatus(t *testing.T) {
	var l Library
	l.AddBook("012", "Test Book 4", "Author Test 4")
	status, borrower := l.CheckBookStatus("012")
	if status != "available" || borrower != "" {
		t.Errorf("Status check failed. Expected status 'available' and empty borrower, got '%s' and '%s'", status, borrower)
	}
}
