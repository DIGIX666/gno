package todolist

import (
    "bytes"
    "gno.land/p/demo/todolist"
    "strconv"
    "gno.land/p/demo/ufmt"
)

var todos []*todolist.Todo

func init() {
    todos = []*todolist.Todo{}
}

func NewTodolist(title string) int {
    tl := todolist.NewTodoList(title)
    todos = append(todos, tl)
    return len(todos) - 1
}

func AddTask(todoID int, title string) {
    if todoID >= 0 && todoID < len(todos) {
        todos[todoID].AddTask(todolist.Task{Title: title, Done: false})
    }
}

func ToggleTaskStatus(todoID, taskIndex int) {
    if todoID >= 0 && todoID < len(todos) {
        todos[todoID].ToggleTaskStatus(taskIndex)
    }
}

func RemoveTodoList(todoID int) {
    if todoID >= 0 && todoID < len(todos) {
        todos = append(todos[:todoID], todos[todoID+1:]...)
    }
}

func ClearAllTasks(todoID int) {
    if todoID >= 0 && todoID < len(todos) {
        todos[todoID].ClearAllTasks()
    }
}

func Render(path string) string {
    if path == "" {
        return renderHomepage()
    }

    return "unknown page"
}

func renderHomepage() string {
    var b bytes.Buffer

    b.WriteString("# Welcome to TodoList\n\n")

    if len(todos) == 0 {
        b.WriteString("### No todo lists available currently!")
        return b.String()
    }

    for i, tl := range todos {
        b.WriteString(ufmt.Sprintf("## TodoList #%d: %s\n", i+1, tl.Title))
        b.WriteString(ufmt.Sprintf("#### TodoList owner: %s\n", tl.Owner))

        completedTasks := tl.GetCompletedTasks()
        if len(completedTasks) > 0 {
            b.WriteString("### Completed tasks:\n")
            for j, task := range completedTasks {
                b.WriteString(ufmt.Sprintf("\n#%d : %s", j+1, task.Title))
                b.WriteString("✓\n\n")
            }
        }

        incompleteTasks := tl.GetIncompleteTasks()
        if len(incompleteTasks) > 0 {
            b.WriteString("### Incomplete tasks:\n")
            for j, task := range incompleteTasks {
                b.WriteString(ufmt.Sprintf("\n#%d : %s\n", j+1, task.Title))
            }
        }

        stats := tl.Stats()
        b.WriteString(ufmt.Sprintf("\n### Statistics\n"))
        b.WriteString(ufmt.Sprintf("Total tasks: %d\n", stats.Total))
        b.WriteString(ufmt.Sprintf("Completed tasks: %d\n", stats.Completed))
        b.WriteString(ufmt.Sprintf("Incomplete tasks: %d\n", stats.Incomplete))
        b.WriteString("\n")
    }

    return b.String()
}
