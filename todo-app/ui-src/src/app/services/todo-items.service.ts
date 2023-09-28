import { Injectable } from '@angular/core';
import { TodoItem, TodoItemsService as TodoItemsApiClient } from '../core/api/v1';
import { HttpContext } from '@angular/common/http';
import { BehaviorSubject, Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class TodoItemsService {

  public readonly todoItems : BehaviorSubject<Array<TodoItem>> = new BehaviorSubject(new Array<TodoItem>);

  constructor(private todoItemsApiClient: TodoItemsApiClient) { }

  public createTodoItem(todoItem?: TodoItem, observe?: 'body', reportProgress?: boolean, options?: {httpHeaderAccept?: '*/*', context?: HttpContext}): Observable<any> {
    var observable = this.todoItemsApiClient.createTodoItem(todoItem, observe, reportProgress, options);
    var update = () => this.getTodoItems();
    observable.subscribe({
      next(x) { },
      error(err) { },
      complete() {
        update();
      }
    });
    return observable;
  }

  public getTodoItems(observe?: 'body', reportProgress?: boolean, options?: {httpHeaderAccept?: 'application/json; charset&#x3D;utf-8' | 'text/plain; charset&#x3D;utf-8', context?: HttpContext}): Observable<Array<TodoItem>> {
    var observable = this.todoItemsApiClient.getTodoItems(observe, reportProgress, options);
    var subject = this.todoItems;
    observable.subscribe({
      next(todoItems: Array<TodoItem>) {
        subject.next(todoItems);
      },
      error(err) { },
      complete() { }
    });
    return this.todoItems;
  }

}
