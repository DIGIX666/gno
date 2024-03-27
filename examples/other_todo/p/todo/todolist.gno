package todolist

import (
    "std"
)

type Todo struct {
    Title  string
    Tasks  []Task
    Owner  std.Address
}

type Task struct {
    Title string
    Done  bool
}

type TodoStats struct {
    Total      int
    Completed  int
    Incomplete int
}

func NewTodoList(title string) *Todo {
    return &Todo{
        Title: title,
        Tasks: []Task{},
        Owner: std.GetOrigCaller(),
    }
}

func (tl *Todo) AddTask(task Task) {
    tl.Tasks = append(tl.Tasks, task)
}

func (tl *Todo) ToggleTaskStatus(taskIndex int) {
    if taskIndex >= 0 && taskIndex < len(tl.Tasks) {
        tl.Tasks[taskIndex].Done = !tl.Tasks[taskIndex].Done
    }
}

func (tl *Todo) RemoveTask(taskIndex int) {
    if taskIndex >= 0 && taskIndex < len(tl.Tasks) {
        tl.Tasks = append(tl.Tasks[:taskIndex], tl.Tasks[taskIndex+1:]...)
    }
}

func (tl *Todo) ClearAllTasks() {
    tl.Tasks = []Task{}
}

func (tl *Todo) GetIncompleteTasks() []Task {
    var incompleteTasks []Task
    for _, task := range tl.Tasks {
        if !task.Done {
            incompleteTasks = append(incompleteTasks, task)
        }
    }
    return incompleteTasks
}

func (tl *Todo) GetCompletedTasks() []Task {
    var completedTasks []Task
    for _, task := range tl.Tasks {
        if task.Done {
            completedTasks = append(completedTasks, task)
        }
    }
    return completedTasks
}

func (tl *Todo) Stats() TodoStats {
    var stats TodoStats
    stats.Total = len(tl.Tasks)
    for _, task := range tl.Tasks {
        if task.Done {
            stats.Completed++
        } else {
            stats.Incomplete++
        }
    }
    return stats
}
