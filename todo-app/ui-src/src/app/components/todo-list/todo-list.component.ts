import { Component } from '@angular/core';
import { Observable } from 'rxjs';
import { TodoItem } from 'src/app/core/api/v1';
import { TodoItemsService } from 'src/app/services/todo-items.service';

@Component({
  selector: 'app-todo-list',
  templateUrl: './todo-list.component.html',
  styleUrls: ['./todo-list.component.css']
})
export class TodoListComponent {
  todoItems: Observable<Array<TodoItem>> = new Observable<Array<TodoItem>>;

  constructor(private todoItemsService: TodoItemsService) { }

  ngOnInit() {
    // Fetch the list of strings from the service
    this.todoItems = this.todoItemsService.getTodoItems();
  }
}
