import { Component } from '@angular/core';
import { TodoItem } from 'src/app/core/api/v1';
import { TodoItemsService } from 'src/app/services/todo-items.service';

@Component({
  selector: 'app-add-todo',
  templateUrl: './add-todo.component.html',
  styleUrls: ['./add-todo.component.css']
})
export class AddTodoComponent {
  constructor(private todoItemsService: TodoItemsService) { }

  newTodoItem: TodoItem = { title: '' };

  addTodoItem() {
    if (this.newTodoItem.title.trim() !== '') {
      this.todoItemsService.createTodoItem(this.newTodoItem);
      this.newTodoItem.title = ''; // Clear the input field after adding
    }
  }
}
