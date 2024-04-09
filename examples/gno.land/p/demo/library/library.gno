package library

import (
	"std"
)

type Book struct {
	ID       string
	Title    string
	Author   string
	Status   string
	Borrower std.Address
}

type Library struct {
	books []Book
}

func (l *Library) GetBooks() []Book {
    return l.books
}

func (l *Library) AddBook(id, title, author string) {
	l.books = append(l.books, Book{
		ID:     id,
		Title:  title,
		Author: author,
		Status: "available",
	})
}

func (l *Library) BorrowBook(bookID string, borrower std.Address) string {
	for i, book := range l.books {
		if book.ID == bookID {
			if book.Status == "available" {
				l.books[i].Status = "borrowed"
				l.books[i].Borrower = borrower
				return "Book borrowed successfully"
			} else {
				return "Book is not available"
			}
		}
	}
	return "Book not found"
}

func (l *Library) ReturnBook(bookID string) string {
	for i, book := range l.books {
		if book.ID == bookID {
			if book.Status == "borrowed" {
				l.books[i].Status = "available"
				l.books[i].Borrower = ""
				return "Book returned successfully"
			} else {
				return "Book was not borrowed"
			}
		}
	}
	return "Book not found"
}

func (l *Library) CheckBookStatus(bookID string) (string, std.Address) {
	for _, book := range l.books {
		if book.ID == bookID {
			return book.Status, book.Borrower
		}
	}
	return "Book not found", ""
}
