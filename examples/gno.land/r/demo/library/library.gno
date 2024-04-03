package library

import (
	"std"
	"bytes"
	"gno.land/p/demo/library"
	"gno.land/p/demo/ufmt"
)


func AddBook(id, title, author string) string {
	library.AddBook(id, title, author)
	return "Book added successfully"
}


func BorrowBook(bookID string, borrower std.Address) string {
	return library.BorrowBook(bookID, borrower)
}


func ReturnBook(bookID string) string {
	return library.ReturnBook(bookID)
}


func CheckBookStatus(bookID string) string {
	status, borrower := library.CheckBookStatus(bookID)
	if status == "available" {
		return "Book is available"
	} else {
		return ufmt.Sprintf("Book is borrowed by %s", borrower.String())
	}
}


func Render(path string) string {
	var b bytes.Buffer

	
	b.WriteString("# Welcome to the library\n\n")

	if len(library.Library) == 0 {
		b.WriteString("No books in the library.\n")
		return b.String()
	}

	for _, book := range library.Library {
		b.WriteString(ufmt.Sprintf("ID: %s, Title: %s, Author: %s, Status: %s\n", book.ID, book.Title, book.Author, book.Status))
		if book.Status == "borrowed" {
			b.WriteString(ufmt.Sprintf(" - Borrowed by: %s\n", book.Borrower.String()))
		}
		b.WriteString("\n") 
	}

	return b.String()
}