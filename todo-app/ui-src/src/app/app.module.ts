import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { TodoListComponent } from './components/todo-list/todo-list.component';
import { ApiModule } from './core/api/v1/api.module';
import { HttpClientModule } from '@angular/common/http';
import { Configuration, ConfigurationParameters } from './core/api/v1';
import { AddTodoComponent } from './components/add-todo/add-todo.component';
import { TodoItemsService } from './services/todo-items.service';
import { FormsModule } from '@angular/forms';
import { environment } from '../environments/environment'

export function apiConfigFactory(): Configuration {
  const params: ConfigurationParameters = {
    basePath: environment.todoApiUrl(),
  };
  return new Configuration(params);
}

@NgModule({
  declarations: [
    AppComponent,
    TodoListComponent,
    AddTodoComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FormsModule,
    HttpClientModule,
    ApiModule.forRoot(apiConfigFactory)
  ],
  providers: [TodoItemsService],
  bootstrap: [AppComponent]
})
export class AppModule { }