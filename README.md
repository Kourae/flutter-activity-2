1. Why does the application use SQLite instead of relying only on a Dart list?

The application uses SQLite instead of relying only on a Dart list because SQLite provides persistent storage that allows task data to remain available even after the application is closed and reopened. A Dart list stores data only in memory while the application is running, which means all tasks are lost when the application process ends. By using SQLite, the application can save task records locally on the device and retrieve them whenever the user launches the application again, ensuring that important information is preserved between sessions.

2. What is the purpose of the primary key in the tasks table?

The primary key serves as a unique identifier for each task stored in the database. In the tasks table, the ID is automatically generated and ensures that every record can be uniquely distinguished from other records, even if multiple tasks have the same title. The primary key is particularly important when updating a task’s completion status or deleting a specific task because it allows the application to target the correct record without affecting other tasks.

3. How does the repository simplify the UI's interaction with the database?

The repository simplifies the interaction between the user interface and the database by acting as an intermediary layer that handles all data-access operations. Instead of placing SQL queries and database logic directly inside the UI code, the UI communicates with the repository through simple methods such as creating, retrieving, updating, and deleting tasks. This separation of concerns makes the application easier to understand, maintain, test, and modify because changes to the database logic can be made in one place without affecting the user interface.

4. What would happen if a task were removed from the displayed list but not deleted from SQLite?

If a task were removed from the displayed list but not deleted from SQLite, the task would disappear only from the current view of the application while still remaining stored in the database. As a result, the task would reappear the next time the application reloads the task data or when the application is restarted because the record was never actually removed from persistent storage. This demonstrates the difference between modifying the UI and modifying the underlying database.

5. If the database schema later needed a new column for task priority, what parts of the application might need to change?

If the database schema later required a new column for task priority, several parts of the application would need to be updated. The database table definition would need to include the new column, and the database migration logic would need to handle upgrading existing databases. The Task model would need a new property for priority, while the CRUD operations and repository methods would need to store and retrieve the new data. Additionally, the user interface would need to provide a way for users to enter, edit, and view task priorities so that the new field could be fully utilized throughout the application.