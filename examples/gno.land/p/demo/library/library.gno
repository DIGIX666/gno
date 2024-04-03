package library

import (
	"std"
)

type Book struct {
	ID     string
	Title  string
	Author string
	Status string 
	Borrower std.Address 
}

var Library []Book 


func AddBook(id, title, author string) {
	book := Book{
		ID:     id,
		Title:  title,
		Author: author,
		Status: "available",
	}
	Library = append(Library, book)
}


func BorrowBook(bookID string, borrower std.Address) string {
	for i, book := range Library {
		if book.ID == bookID {
			if book.Status == "available" {
				Library[i].Status = "borrowed"
				Library[i].Borrower = borrower
				return "Book borrowed successfully"
			} else {
				return "Book is not available"
			}
		}
	}
	return "Book not found"
}


func ReturnBook(bookID string) string {
	for i, book := range Library {
		if book.ID == bookID {
			if book.Status == "borrowed" {
				Library[i].Status = "available"
				Library[i].Borrower = ""
				return "Book returned successfully"
			} else {
				return "Book was not borrowed"
			}
		}
	}
	return "Book not found"
}


func CheckBookStatus(bookID string) (string, std.Address) {
	for _, book := range Library {
		if book.ID == bookID {
			return book.Status, book.Borrower
		}
	}
	return "Book not found", ""
}